import { Request, Response } from "express";
import { prisma } from "../..";
import { BillShieldError, VoucherService } from "../../services/billshield/voucher.service";
import {
  createVoucherSchema,
  updateVoucherSchema,
  reverseVoucherSchema,
  reconcileLineSchema,
} from "../../types/billshield";
import { handleBillShieldError, parseBody, parseDateRange } from "./util";

export class VoucherController {
  static async create(req: Request, res: Response) {
    try {
      const input = parseBody(res, createVoucherSchema, req.body);
      if (!input) return;
      const voucher = await VoucherService.create(req.companyId!, req.user!.id, input);
      return res.status(201).json({ success: true, data: voucher });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async list(req: Request, res: Response) {
    try {
      const { from, to } = parseDateRange(req.query);
      const { type, status, ledgerId, partyId } = req.query;
      const page = Math.max(parseInt((req.query.page as string) ?? "1", 10), 1);
      const limit = Math.min(Math.max(parseInt((req.query.limit as string) ?? "50", 10), 1), 200);

      const where = {
        companyId: req.companyId!,
        ...(from || to ? { voucherDate: { gte: from, lte: to } } : {}),
        ...(type ? { voucherType: { code: type as string } } : {}),
        ...(status ? { status: status as any } : {}),
        ...(partyId ? { partyId: partyId as string } : {}),
        ...(ledgerId ? { lines: { some: { ledgerId: ledgerId as string } } } : {}),
      };

      const [vouchers, total] = await Promise.all([
        prisma.voucher.findMany({
          where,
          include: {
            voucherType: { select: { name: true, code: true } },
            party: { select: { partyName: true } },
            lines: { include: { ledger: { select: { name: true } } } },
          },
          orderBy: [{ voucherDate: "desc" }, { createdAt: "desc" }],
          skip: (page - 1) * limit,
          take: limit,
        }),
        prisma.voucher.count({ where }),
      ]);
      return res.json({ success: true, data: vouchers, pagination: { page, limit, total } });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async get(req: Request, res: Response) {
    try {
      const voucher = await prisma.voucher.findFirst({
        where: { id: req.params.id, companyId: req.companyId! },
        include: {
          voucherType: true,
          party: true,
          fiscalYear: { select: { label: true } },
          lines: { include: { ledger: { select: { name: true } }, reconciliation: true } },
          gstLines: true,
          reversalOf: { select: { id: true, voucherNo: true } },
          reversedBy: { select: { id: true, voucherNo: true } },
        },
      });
      if (!voucher) throw new BillShieldError("Voucher not found", 404);
      return res.json({ success: true, data: voucher });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async update(req: Request, res: Response) {
    try {
      const input = parseBody(res, updateVoucherSchema, req.body);
      if (!input) return;
      const voucher = await VoucherService.updateDraft(req.companyId!, req.params.id, input);
      return res.json({ success: true, data: voucher });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async post(req: Request, res: Response) {
    try {
      const voucher = await VoucherService.post(req.companyId!, req.params.id);
      return res.json({ success: true, data: voucher });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async reverse(req: Request, res: Response) {
    try {
      const input = parseBody(res, reverseVoucherSchema, req.body ?? {});
      if (!input) return;
      const reversal = await VoucherService.reverse(req.companyId!, req.user!.id, req.params.id, input);
      return res.json({ success: true, data: reversal });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async remove(req: Request, res: Response) {
    try {
      await VoucherService.deleteDraft(req.companyId!, req.params.id);
      return res.json({ success: true, message: "Draft voucher deleted" });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  /** Bank reconciliation entry for a single voucher line. */
  static async reconcileLine(req: Request, res: Response) {
    try {
      const input = parseBody(res, reconcileLineSchema, req.body);
      if (!input) return;

      const line = await prisma.voucherLine.findFirst({
        where: { id: req.params.lineId, voucher: { companyId: req.companyId! } },
      });
      if (!line) throw new BillShieldError("Voucher line not found", 404);

      const reco = await prisma.bankReconciliation.upsert({
        where: { voucherLineId: line.id },
        create: { voucherLineId: line.id, ...input },
        update: input,
      });
      return res.json({ success: true, data: reco });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }
}
