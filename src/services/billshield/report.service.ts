import { Prisma } from "@prisma/client";
import { prisma } from "../..";
import { BillShieldError } from "./voucher.service";

// Lines of POSTED and REVERSED vouchers both stay in the books —
// a reversal is cancelled by its mirror voucher, never by deletion.
const IN_BOOKS = Prisma.sql`v.status IN ('POSTED', 'REVERSED')`;

const CASHBOOK_PREFIX = "current-assets/cash-in-hand";
const BANKBOOK_PREFIX = "current-assets/bank-accounts";

function signedOpening(openingBalance: Prisma.Decimal | number, type: "DR" | "CR") {
  const n = Number(openingBalance);
  return type === "DR" ? n : -n;
}

export class ReportService {
  /** One ledger's account statement: opening → dated lines with running balance → closing. */
  static async ledgerStatement(companyId: string, ledgerId: string, from?: Date, to?: Date) {
    const ledger = await prisma.ledgerAccount.findFirst({
      where: { id: ledgerId, companyId },
      include: { group: { select: { name: true, path: true } } },
    });
    if (!ledger) throw new BillShieldError("Ledger not found", 404);

    const priorFilter = from ? Prisma.sql`AND v."voucherDate" < ${from}` : Prisma.sql``;
    const [prior] = await prisma.$queryRaw<{ net: number }[]>`
      SELECT COALESCE(SUM(vl.debit - vl.credit), 0)::float8 AS net
      FROM "VoucherLine" vl JOIN "Voucher" v ON v.id = vl."voucherId"
      WHERE vl."ledgerId" = ${ledgerId} AND ${IN_BOOKS} ${priorFilter}`;

    const opening = signedOpening(ledger.openingBalance, ledger.openingBalanceType) + (from ? prior.net : 0);

    const rangeFilter = Prisma.sql`
      ${from ? Prisma.sql`AND v."voucherDate" >= ${from}` : Prisma.sql``}
      ${to ? Prisma.sql`AND v."voucherDate" <= ${to}` : Prisma.sql``}`;

    const rows = await prisma.$queryRaw<any[]>`
      SELECT v."voucherNo", v."voucherDate", vt.name AS "voucherType",
             COALESCE(vl.narration, v.narration) AS narration,
             vl.debit::float8 AS debit, vl.credit::float8 AS credit,
             ${opening}::float8 + SUM(vl.debit - vl.credit)
               OVER (ORDER BY v."voucherDate", v."createdAt", vl."lineNo")::float8 AS "runningBalance"
      FROM "VoucherLine" vl
      JOIN "Voucher" v ON v.id = vl."voucherId"
      JOIN "VoucherType" vt ON vt.id = v."voucherTypeId"
      WHERE vl."ledgerId" = ${ledgerId} AND ${IN_BOOKS} ${rangeFilter}
      ORDER BY v."voucherDate", v."createdAt", vl."lineNo"`;

    const closing = rows.length ? rows[rows.length - 1].runningBalance : opening;
    return {
      ledger: { id: ledger.id, name: ledger.name, group: ledger.group.name },
      opening: { amount: Math.abs(opening), type: opening >= 0 ? "DR" : "CR" },
      entries: rows,
      closing: { amount: Math.abs(closing), type: closing >= 0 ? "DR" : "CR" },
    };
  }

  /** Cashbook / bankbook: every line on ledgers under the given group subtree. */
  private static async book(companyId: string, pathPrefix: string, from?: Date, to?: Date, withReco = false) {
    const rangeFilter = Prisma.sql`
      ${from ? Prisma.sql`AND v."voucherDate" >= ${from}` : Prisma.sql``}
      ${to ? Prisma.sql`AND v."voucherDate" <= ${to}` : Prisma.sql``}`;

    const recoSelect = withReco
      ? Prisma.sql`, br."instrumentNo", br."instrumentDate", br."clearedOn", br."statementRef"`
      : Prisma.sql``;
    const recoJoin = withReco
      ? Prisma.sql`LEFT JOIN "BankReconciliation" br ON br."voucherLineId" = vl.id`
      : Prisma.sql``;

    return prisma.$queryRaw<any[]>`
      SELECT la.id AS "ledgerId", la.name AS "ledgerName",
             v."voucherNo", v."voucherDate", vt.name AS "voucherType",
             COALESCE(vl.narration, v.narration) AS narration,
             vl.id AS "lineId", vl.debit::float8 AS debit, vl.credit::float8 AS credit,
             (CASE WHEN la."openingBalanceType" = 'DR' THEN la."openingBalance" ELSE -la."openingBalance" END)::float8
               + SUM(vl.debit - vl.credit)
                 OVER (PARTITION BY la.id ORDER BY v."voucherDate", v."createdAt", vl."lineNo")::float8
               AS "runningBalance"
             ${recoSelect}
      FROM "VoucherLine" vl
      JOIN "Voucher" v ON v.id = vl."voucherId"
      JOIN "VoucherType" vt ON vt.id = v."voucherTypeId"
      JOIN "LedgerAccount" la ON la.id = vl."ledgerId"
      JOIN "AccountGroup" g ON g.id = la."groupId"
      ${recoJoin}
      WHERE la."companyId" = ${companyId} AND ${IN_BOOKS}
        AND (g.path = ${pathPrefix} OR g.path LIKE ${pathPrefix + "/%"})
        ${rangeFilter}
      ORDER BY la.name, v."voucherDate", v."createdAt", vl."lineNo"`;
  }

  static cashbook(companyId: string, from?: Date, to?: Date) {
    return ReportService.book(companyId, CASHBOOK_PREFIX, from, to, false);
  }

  static bankbook(companyId: string, from?: Date, to?: Date) {
    return ReportService.book(companyId, BANKBOOK_PREFIX, from, to, true);
  }

  /** Per-ledger closing balances as of a date. Sum(Dr) always equals Sum(Cr). */
  static async trialBalance(companyId: string, asOf?: Date) {
    const dateFilter = asOf ? Prisma.sql`AND v."voucherDate" <= ${asOf}` : Prisma.sql``;
    const rows = await prisma.$queryRaw<any[]>`
      SELECT la.id AS "ledgerId", la.name AS "ledgerName",
             g.name AS "groupName", g.path AS "groupPath", g.nature,
             ((CASE WHEN la."openingBalanceType" = 'DR' THEN la."openingBalance" ELSE -la."openingBalance" END)
               + COALESCE(SUM(vl.debit - vl.credit), 0))::float8 AS net
      FROM "LedgerAccount" la
      JOIN "AccountGroup" g ON g.id = la."groupId"
      LEFT JOIN LATERAL (
        SELECT vl.debit, vl.credit
        FROM "VoucherLine" vl JOIN "Voucher" v ON v.id = vl."voucherId"
        WHERE vl."ledgerId" = la.id AND ${IN_BOOKS} ${dateFilter}
      ) vl ON TRUE
      WHERE la."companyId" = ${companyId}
      GROUP BY la.id, la.name, g.name, g.path, g.nature,
               la."openingBalance", la."openingBalanceType"
      HAVING ((CASE WHEN la."openingBalanceType" = 'DR' THEN la."openingBalance" ELSE -la."openingBalance" END)
               + COALESCE(SUM(vl.debit - vl.credit), 0)) <> 0
      ORDER BY g.path, la.name`;

    const ledgers = rows.map((r) => ({
      ...r,
      debit: r.net > 0 ? r.net : 0,
      credit: r.net < 0 ? -r.net : 0,
    }));
    return {
      ledgers,
      totals: {
        debit: ledgers.reduce((s, l) => s + l.debit, 0),
        credit: ledgers.reduce((s, l) => s + l.credit, 0),
      },
    };
  }

  /** Trading A/c + P&L: primary-group rollup of income/expense ledgers in the period. */
  static async profitAndLoss(companyId: string, from?: Date, to?: Date) {
    const rangeFilter = Prisma.sql`
      ${from ? Prisma.sql`AND v."voucherDate" >= ${from}` : Prisma.sql``}
      ${to ? Prisma.sql`AND v."voucherDate" <= ${to}` : Prisma.sql``}`;

    const rows = await prisma.$queryRaw<any[]>`
      SELECT split_part(g.path, '/', 1) AS "primaryPath",
             pg.name AS "groupName", pg.nature, pg."reportSection",
             COALESCE(SUM(vl.credit - vl.debit), 0)::float8 AS "creditNet"
      FROM "VoucherLine" vl
      JOIN "Voucher" v ON v.id = vl."voucherId"
      JOIN "LedgerAccount" la ON la.id = vl."ledgerId"
      JOIN "AccountGroup" g ON g.id = la."groupId"
      JOIN "AccountGroup" pg ON pg."companyId" = g."companyId" AND pg.path = split_part(g.path, '/', 1)
      WHERE la."companyId" = ${companyId} AND ${IN_BOOKS}
        AND g.nature IN ('INCOME', 'EXPENSE')
        ${rangeFilter}
      GROUP BY split_part(g.path, '/', 1), pg.name, pg.nature, pg."reportSection"
      ORDER BY pg."reportSection", pg.nature`;

    // creditNet: positive for income, negative for expenses
    const trading = rows.filter((r) => r.reportSection === "TRADING");
    const pl = rows.filter((r) => r.reportSection === "PROFIT_AND_LOSS");
    const grossProfit = trading.reduce((s, r) => s + r.creditNet, 0);
    const netProfit = grossProfit + pl.reduce((s, r) => s + r.creditNet, 0);

    const fmt = (r: any) => ({
      group: r.groupName,
      nature: r.nature,
      amount: Math.abs(r.creditNet),
    });
    return {
      trading: {
        income: trading.filter((r) => r.nature === "INCOME").map(fmt),
        expenses: trading.filter((r) => r.nature === "EXPENSE").map(fmt),
        grossProfit,
      },
      profitAndLoss: {
        income: pl.filter((r) => r.nature === "INCOME").map(fmt),
        expenses: pl.filter((r) => r.nature === "EXPENSE").map(fmt),
        netProfit,
      },
    };
  }

  /** Balance sheet as of a date: asset vs liability primary groups + net profit. */
  static async balanceSheet(companyId: string, asOf?: Date) {
    const dateFilter = asOf ? Prisma.sql`AND v."voucherDate" <= ${asOf}` : Prisma.sql``;

    const rows = await prisma.$queryRaw<any[]>`
      SELECT pg.name AS "groupName", pg.nature,
             SUM((CASE WHEN la."openingBalanceType" = 'DR' THEN la."openingBalance" ELSE -la."openingBalance" END)
                 + COALESCE(lines.net, 0))::float8 AS "debitNet"
      FROM "LedgerAccount" la
      JOIN "AccountGroup" g ON g.id = la."groupId"
      JOIN "AccountGroup" pg ON pg."companyId" = g."companyId" AND pg.path = split_part(g.path, '/', 1)
      LEFT JOIN LATERAL (
        SELECT SUM(vl.debit - vl.credit) AS net
        FROM "VoucherLine" vl JOIN "Voucher" v ON v.id = vl."voucherId"
        WHERE vl."ledgerId" = la.id AND ${IN_BOOKS} ${dateFilter}
      ) lines ON TRUE
      WHERE la."companyId" = ${companyId} AND g.nature IN ('ASSET', 'LIABILITY')
      GROUP BY pg.name, pg.nature
      HAVING SUM((CASE WHEN la."openingBalanceType" = 'DR' THEN la."openingBalance" ELSE -la."openingBalance" END)
                 + COALESCE(lines.net, 0)) <> 0
      ORDER BY pg.nature, pg.name`;

    const pnl = await ReportService.profitAndLoss(companyId, undefined, asOf);
    const assets = rows
      .filter((r) => r.nature === "ASSET")
      .map((r) => ({ group: r.groupName, amount: r.debitNet }));
    const liabilities = rows
      .filter((r) => r.nature === "LIABILITY")
      .map((r) => ({ group: r.groupName, amount: -r.debitNet }));

    const totalAssets = assets.reduce((s, r) => s + r.amount, 0);
    const totalLiabilities =
      liabilities.reduce((s, r) => s + r.amount, 0) + pnl.profitAndLoss.netProfit;

    return {
      assets,
      liabilities: [
        ...liabilities,
        { group: "Profit & Loss (current period)", amount: pnl.profitAndLoss.netProfit },
      ],
      totals: {
        assets: totalAssets,
        liabilities: totalLiabilities,
        difference: Math.round((totalAssets - totalLiabilities) * 100) / 100,
      },
    };
  }

  /** Day book: all vouchers in a date range. */
  static async dayBook(companyId: string, from?: Date, to?: Date) {
    return prisma.voucher.findMany({
      where: {
        companyId,
        status: { in: ["POSTED", "REVERSED"] },
        voucherDate: { gte: from, lte: to },
      },
      include: {
        voucherType: { select: { name: true, code: true } },
        party: { select: { partyName: true } },
        lines: { include: { ledger: { select: { name: true } } } },
      },
      orderBy: [{ voucherDate: "asc" }, { createdAt: "asc" }],
    });
  }
}
