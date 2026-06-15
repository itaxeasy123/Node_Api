import { Prisma, VoucherBaseType } from "@prisma/client";
import { prisma } from "../..";
import { CreateVoucherInput, VoucherLineInput } from "../../types/billshield";

type Tx = Prisma.TransactionClient;

export class BillShieldError extends Error {
  status: number;
  constructor(message: string, status = 400) {
    super(message);
    this.status = status;
  }
}

const CASH_BANK_PATH_PREFIXES = [
  "current-assets/cash-in-hand",
  "current-assets/bank-accounts",
  "loans-liability/bank-od-occ-accounts",
];

function isCashOrBank(path: string) {
  return CASH_BANK_PATH_PREFIXES.some((p) => path === p || path.startsWith(p + "/"));
}

function underGroup(path: string, prefix: string) {
  return path === prefix || path.startsWith(prefix + "/");
}

/** Per-voucher-type posting rules, checked against the ledger's group path. */
function validateTypeRules(
  baseType: VoucherBaseType,
  lines: { debit: number; credit: number; path: string; ledgerName: string }[],
) {
  switch (baseType) {
    case "CONTRA": {
      const bad = lines.find((l) => !isCashOrBank(l.path));
      if (bad)
        throw new BillShieldError(
          `Contra vouchers may only touch cash/bank ledgers — "${bad.ledgerName}" is not one`,
        );
      break;
    }
    case "PAYMENT": {
      if (!lines.some((l) => l.credit > 0 && isCashOrBank(l.path)))
        throw new BillShieldError("Payment vouchers must credit a cash or bank ledger");
      break;
    }
    case "RECEIPT": {
      if (!lines.some((l) => l.debit > 0 && isCashOrBank(l.path)))
        throw new BillShieldError("Receipt vouchers must debit a cash or bank ledger");
      break;
    }
    case "SALES": {
      if (!lines.some((l) => l.credit > 0 && underGroup(l.path, "sales-accounts")))
        throw new BillShieldError("Sales vouchers must credit a ledger under Sales Accounts");
      break;
    }
    case "PURCHASE": {
      if (!lines.some((l) => l.debit > 0 && underGroup(l.path, "purchase-accounts")))
        throw new BillShieldError("Purchase vouchers must debit a ledger under Purchase Accounts");
      break;
    }
    case "CREDIT_NOTE": {
      if (!lines.some((l) => l.debit > 0 && underGroup(l.path, "sales-accounts")))
        throw new BillShieldError("Credit notes must debit a ledger under Sales Accounts (sales return)");
      break;
    }
    case "DEBIT_NOTE": {
      if (!lines.some((l) => l.credit > 0 && underGroup(l.path, "purchase-accounts")))
        throw new BillShieldError("Debit notes must credit a ledger under Purchase Accounts (purchase return)");
      break;
    }
    case "JOURNAL":
      break;
  }
}

function assertBalanced(lines: VoucherLineInput[]) {
  if (lines.length < 2) throw new BillShieldError("A voucher needs at least 2 lines");
  const dr = lines.reduce((s, l) => s + l.debit, 0);
  const cr = lines.reduce((s, l) => s + l.credit, 0);
  if (Math.round(dr * 100) !== Math.round(cr * 100))
    throw new BillShieldError(`Voucher is unbalanced: Dr ${dr.toFixed(2)} ≠ Cr ${cr.toFixed(2)}`);
}

async function loadLineLedgers(tx: Tx, companyId: string, lines: VoucherLineInput[]) {
  const ledgers = await tx.ledgerAccount.findMany({
    where: { companyId, id: { in: lines.map((l) => l.ledgerId) } },
    include: { group: { select: { path: true } } },
  });
  const byId = new Map(ledgers.map((l) => [l.id, l]));
  return lines.map((l) => {
    const ledger = byId.get(l.ledgerId);
    if (!ledger) throw new BillShieldError(`Ledger ${l.ledgerId} not found in this company`, 404);
    return { ...l, path: ledger.group.path, ledgerName: ledger.name };
  });
}

async function findOpenFiscalYear(tx: Tx, companyId: string, date: Date) {
  const fy = await tx.fiscalYear.findFirst({
    where: { companyId, startDate: { lte: date }, endDate: { gte: date } },
  });
  if (!fy)
    throw new BillShieldError(
      `No fiscal year covers ${date.toISOString().slice(0, 10)} — create it first`,
    );
  if (fy.isClosed) throw new BillShieldError(`Fiscal year ${fy.label} is closed`);
  return fy;
}

/** Atomically allocates the next voucher number for (type, FY). */
async function allocateVoucherNo(tx: Tx, voucherTypeId: string, fiscalYearId: string, code: string, fyLabel: string) {
  const rows = await tx.$queryRaw<{ nextNumber: number }[]>`
    INSERT INTO "VoucherSequence" (id, "voucherTypeId", "fiscalYearId", "nextNumber")
    VALUES (gen_random_uuid(), ${voucherTypeId}, ${fiscalYearId}, 2)
    ON CONFLICT ("voucherTypeId", "fiscalYearId")
    DO UPDATE SET "nextNumber" = "VoucherSequence"."nextNumber" + 1
    RETURNING "nextNumber"`;
  const allocated = rows[0].nextNumber - 1;
  return `${code}/${fyLabel}/${String(allocated).padStart(4, "0")}`;
}

async function postWithinTx(tx: Tx, companyId: string, voucherId: string) {
  const voucher = await tx.voucher.findFirst({
    where: { id: voucherId, companyId },
    include: { voucherType: true, lines: true },
  });
  if (!voucher) throw new BillShieldError("Voucher not found", 404);
  if (voucher.status !== "DRAFT") throw new BillShieldError(`Voucher is already ${voucher.status}`);

  const lines = voucher.lines.map((l) => ({
    ledgerId: l.ledgerId,
    debit: Number(l.debit),
    credit: Number(l.credit),
  }));
  assertBalanced(lines as VoucherLineInput[]);
  const enriched = await loadLineLedgers(tx, companyId, lines as VoucherLineInput[]);
  validateTypeRules(voucher.voucherType.baseType, enriched);

  const fy = await findOpenFiscalYear(tx, companyId, voucher.voucherDate);
  if (fy.id !== voucher.fiscalYearId)
    await tx.voucher.update({ where: { id: voucherId }, data: { fiscalYearId: fy.id } });

  const voucherNo = await allocateVoucherNo(tx, voucher.voucherTypeId, fy.id, voucher.voucherType.code, fy.label);

  return tx.voucher.update({
    where: { id: voucherId },
    data: { status: "POSTED", voucherNo, postedAt: new Date() },
    include: { lines: true, gstLines: true, voucherType: true },
  });
}

export class VoucherService {
  static async create(companyId: string, userId: number, input: CreateVoucherInput) {
    return prisma.$transaction(async (tx) => {
      const voucherType = await tx.voucherType.findFirst({
        where: { companyId, code: input.voucherTypeCode },
      });
      if (!voucherType) throw new BillShieldError(`Unknown voucher type ${input.voucherTypeCode}`, 404);

      assertBalanced(input.lines);
      const enriched = await loadLineLedgers(tx, companyId, input.lines);
      validateTypeRules(voucherType.baseType, enriched);
      const fy = await findOpenFiscalYear(tx, companyId, input.voucherDate);

      const voucher = await tx.voucher.create({
        data: {
          companyId,
          fiscalYearId: fy.id,
          voucherTypeId: voucherType.id,
          voucherDate: input.voucherDate,
          narration: input.narration,
          partyId: input.partyId ?? null,
          status: "DRAFT",
          createdById: userId,
          lines: {
            create: input.lines.map((l, i) => ({
              lineNo: i + 1,
              ledgerId: l.ledgerId,
              debit: l.debit,
              credit: l.credit,
              narration: l.narration,
            })),
          },
          gstLines: input.gstLines?.length ? { create: input.gstLines } : undefined,
        },
        include: { lines: true, gstLines: true, voucherType: true },
      });

      if (!input.post) return voucher;
      return postWithinTx(tx, companyId, voucher.id);
    });
  }

  static async post(companyId: string, voucherId: string) {
    return prisma.$transaction((tx) => postWithinTx(tx, companyId, voucherId));
  }

  static async reverse(companyId: string, userId: number, voucherId: string, opts: { voucherDate?: Date; narration?: string } = {}) {
    return prisma.$transaction(async (tx) => {
      const original = await tx.voucher.findFirst({
        where: { id: voucherId, companyId },
        include: { lines: true, voucherType: true },
      });
      if (!original) throw new BillShieldError("Voucher not found", 404);
      if (original.status !== "POSTED")
        throw new BillShieldError(`Only POSTED vouchers can be reversed (this one is ${original.status})`);

      const date = opts.voucherDate ?? original.voucherDate;
      const fy = await findOpenFiscalYear(tx, companyId, date);

      const reversal = await tx.voucher.create({
        data: {
          companyId,
          fiscalYearId: fy.id,
          voucherTypeId: original.voucherTypeId,
          voucherDate: date,
          narration: opts.narration ?? `Reversal of ${original.voucherNo}`,
          partyId: original.partyId,
          status: "DRAFT",
          reversalOfId: original.id,
          createdById: userId,
          lines: {
            create: original.lines.map((l) => ({
              lineNo: l.lineNo,
              ledgerId: l.ledgerId,
              debit: l.credit, // mirror
              credit: l.debit,
              narration: l.narration,
            })),
          },
        },
      });

      const voucherNo = await allocateVoucherNo(tx, original.voucherTypeId, fy.id, original.voucherType.code, fy.label);
      const posted = await tx.voucher.update({
        where: { id: reversal.id },
        data: { status: "POSTED", voucherNo, postedAt: new Date() },
        include: { lines: true, voucherType: true },
      });

      await tx.voucher.update({ where: { id: original.id }, data: { status: "REVERSED" } });
      return posted;
    });
  }

  static async updateDraft(companyId: string, voucherId: string, input: Partial<CreateVoucherInput>) {
    return prisma.$transaction(async (tx) => {
      const voucher = await tx.voucher.findFirst({
        where: { id: voucherId, companyId },
        include: { voucherType: true },
      });
      if (!voucher) throw new BillShieldError("Voucher not found", 404);
      if (voucher.status !== "DRAFT") throw new BillShieldError("Only DRAFT vouchers can be edited");

      if (input.lines) {
        assertBalanced(input.lines);
        await tx.voucherLine.deleteMany({ where: { voucherId } });
        await tx.voucherLine.createMany({
          data: input.lines.map((l, i) => ({
            voucherId,
            lineNo: i + 1,
            ledgerId: l.ledgerId,
            debit: l.debit,
            credit: l.credit,
            narration: l.narration,
          })),
        });
      }
      if (input.gstLines) {
        await tx.voucherGstLine.deleteMany({ where: { voucherId } });
        if (input.gstLines.length)
          await tx.voucherGstLine.createMany({ data: input.gstLines.map((g) => ({ voucherId, ...g })) });
      }

      return tx.voucher.update({
        where: { id: voucherId },
        data: {
          voucherDate: input.voucherDate,
          narration: input.narration,
          partyId: input.partyId === undefined ? undefined : input.partyId,
        },
        include: { lines: true, gstLines: true, voucherType: true },
      });
    });
  }

  static async deleteDraft(companyId: string, voucherId: string) {
    const voucher = await prisma.voucher.findFirst({ where: { id: voucherId, companyId } });
    if (!voucher) throw new BillShieldError("Voucher not found", 404);
    if (voucher.status !== "DRAFT")
      throw new BillShieldError("Only DRAFT vouchers can be deleted — reverse posted ones instead");
    await prisma.voucher.delete({ where: { id: voucherId } });
  }
}
