import { Request, Response } from "express";
import { prisma } from "../..";
import { BillShieldError } from "../../services/billshield/voucher.service";
import { ReportService } from "../../services/billshield/report.service";
import { createLedgerSchema, updateLedgerSchema } from "../../types/billshield";
import { handleBillShieldError, parseBody, parseDateRange } from "./util";

export class LedgerController {
  static async list(req: Request, res: Response) {
    try {
      const { groupId, search } = req.query;
      const ledgers = await prisma.ledgerAccount.findMany({
        where: {
          companyId: req.companyId!,
          ...(groupId ? { groupId: groupId as string } : {}),
          ...(search ? { name: { contains: search as string, mode: "insensitive" } } : {}),
        },
        include: { group: { select: { name: true, path: true, nature: true } } },
        orderBy: { name: "asc" },
      });
      return res.json({ success: true, data: ledgers });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async get(req: Request, res: Response) {
    try {
      const ledger = await prisma.ledgerAccount.findFirst({
        where: { id: req.params.id, companyId: req.companyId! },
        include: { group: true, party: true },
      });
      if (!ledger) throw new BillShieldError("Ledger not found", 404);
      return res.json({ success: true, data: ledger });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  /** Ledger account statement with running balance. */
  static async statement(req: Request, res: Response) {
    try {
      const { from, to } = parseDateRange(req.query);
      const statement = await ReportService.ledgerStatement(req.companyId!, req.params.id, from, to);
      return res.json({ success: true, data: statement });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async create(req: Request, res: Response) {
    try {
      const input = parseBody(res, createLedgerSchema, req.body);
      if (!input) return;

      const group = await prisma.accountGroup.findFirst({
        where: { id: input.groupId, companyId: req.companyId! },
      });
      if (!group) throw new BillShieldError("Group not found", 404);

      const ledger = await prisma.ledgerAccount.create({
        data: { companyId: req.companyId!, ...input },
      });
      return res.status(201).json({ success: true, data: ledger });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async update(req: Request, res: Response) {
    try {
      const input = parseBody(res, updateLedgerSchema, req.body);
      if (!input) return;

      const ledger = await prisma.ledgerAccount.findFirst({
        where: { id: req.params.id, companyId: req.companyId! },
      });
      if (!ledger) throw new BillShieldError("Ledger not found", 404);
      if (ledger.isSystem && input.name && input.name !== ledger.name) {
        throw new BillShieldError("System ledgers cannot be renamed");
      }
      if (input.groupId) {
        const group = await prisma.accountGroup.findFirst({
          where: { id: input.groupId, companyId: req.companyId! },
        });
        if (!group) throw new BillShieldError("Group not found", 404);
        if (ledger.isSystem) throw new BillShieldError("System ledgers cannot be moved");
      }

      const updated = await prisma.ledgerAccount.update({ where: { id: ledger.id }, data: input });
      return res.json({ success: true, data: updated });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async remove(req: Request, res: Response) {
    try {
      const ledger = await prisma.ledgerAccount.findFirst({
        where: { id: req.params.id, companyId: req.companyId! },
        include: { _count: { select: { lines: true } } },
      });
      if (!ledger) throw new BillShieldError("Ledger not found", 404);
      if (ledger.isSystem) throw new BillShieldError("System ledgers cannot be deleted");
      if (ledger._count.lines > 0) {
        throw new BillShieldError("Ledger has voucher entries and cannot be deleted");
      }
      await prisma.ledgerAccount.delete({ where: { id: ledger.id } });
      return res.json({ success: true, message: "Ledger deleted" });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }
}
