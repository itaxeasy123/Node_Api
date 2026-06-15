import { Request, Response } from "express";
import { ReportService } from "../../services/billshield/report.service";
import { handleBillShieldError, parseDateRange } from "./util";

export class ReportController {
  static async cashbook(req: Request, res: Response) {
    try {
      const { from, to } = parseDateRange(req.query);
      return res.json({ success: true, data: await ReportService.cashbook(req.companyId!, from, to) });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async bankbook(req: Request, res: Response) {
    try {
      const { from, to } = parseDateRange(req.query);
      return res.json({ success: true, data: await ReportService.bankbook(req.companyId!, from, to) });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async dayBook(req: Request, res: Response) {
    try {
      const { from, to } = parseDateRange(req.query);
      return res.json({ success: true, data: await ReportService.dayBook(req.companyId!, from, to) });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async trialBalance(req: Request, res: Response) {
    try {
      const asOf = req.query.asOf ? new Date(req.query.asOf as string) : undefined;
      return res.json({ success: true, data: await ReportService.trialBalance(req.companyId!, asOf) });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async profitAndLoss(req: Request, res: Response) {
    try {
      const { from, to } = parseDateRange(req.query);
      return res.json({ success: true, data: await ReportService.profitAndLoss(req.companyId!, from, to) });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async balanceSheet(req: Request, res: Response) {
    try {
      const asOf = req.query.asOf ? new Date(req.query.asOf as string) : undefined;
      return res.json({ success: true, data: await ReportService.balanceSheet(req.companyId!, asOf) });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }
}
