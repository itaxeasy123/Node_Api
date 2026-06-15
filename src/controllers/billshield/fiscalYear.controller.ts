import { Request, Response } from "express";
import { FiscalYearService } from "../../services/billshield/fiscalYear.service";
import { createFiscalYearSchema } from "../../types/billshield";
import { handleBillShieldError, parseBody } from "./util";

export class FiscalYearController {
  static async list(req: Request, res: Response) {
    try {
      return res.json({ success: true, data: await FiscalYearService.list(req.companyId!) });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async create(req: Request, res: Response) {
    try {
      const input = parseBody(res, createFiscalYearSchema, req.body);
      if (!input) return;
      const fy = await FiscalYearService.create(req.companyId!, input.startDate);
      return res.status(201).json({ success: true, data: fy });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async close(req: Request, res: Response) {
    try {
      const fy = await FiscalYearService.close(req.companyId!, req.params.id);
      return res.json({ success: true, data: fy });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }
}
