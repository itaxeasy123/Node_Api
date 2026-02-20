import { Request, Response } from "express";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

class FinanceDataController {
  static async getStatusWiseIncomeTaxCode(req: Request, res: Response) {
    try {
      const data = await prisma.statusWiseIncomeTaxCode.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error fetching Status Wise Income Tax Code:", error);
      return res.status(500).json({ success: false, message: "Failed to fetch data" });
    }
  }

  static async getPanCode(req: Request, res: Response) {
    try {
      const data = await prisma.panAndITCodeByStatus.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error fetching PAN Code:", error);
      return res.status(500).json({ success: false, message: "Failed to fetch data" });
    }
  }

  static async getGoldSilverRate(req: Request, res: Response) {
    try {
      const data = await prisma.goldAndSilver.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error fetching Gold & Silver Rates:", error);
      return res.status(500).json({ success: false, message: "Failed to fetch data" });
    }
  }

  static async getInterestNSC(req: Request, res: Response) {
    try {
      const data = await prisma.interestAccruedonNational.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error fetching Interest Accrued on NSC:", error);
      return res.status(500).json({ success: false, message: "Failed to fetch data" });
    }
  }

  static async getInterestIVP(req: Request, res: Response) {
    try {
      const data = await prisma.interestAccruedonNationalList.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error fetching Interest Accrued on IVP:", error);
      return res.status(500).json({ success: false, message: "Failed to fetch data" });
    }
  }

  static async getInterestNSCIX(req: Request, res: Response) {
    try {
      const data = await prisma.interestRatesAccrued.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error fetching Interest Accrued on NSC IXth Issue:", error);
      return res.status(500).json({ success: false, message: "Failed to fetch data" });
    }
  }

  static async getDepreciationTable(req: Request, res: Response) {
    try {
      const data = await prisma.depreciationTable.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error fetching Depreciation Table:", error);
      return res.status(500).json({ success: false, message: "Failed to fetch data" });
    }
  }

  static async getInterestKVP(req: Request, res: Response) {
    try {
      const data = await prisma.interestOnKVP.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error fetching Interest on KVP:", error);
      return res.status(500).json({ success: false, message: "Failed to fetch data" });
    }
  }

  static async getAll(req: Request, res: Response) {
    try {
      const data = await prisma.costInflationIndex.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error('Error fetching Cost Inflation Index data:', error);
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch Cost Inflation Index data',
      });
    }
  }

  static async getcostlistindex(req: Request, res: Response) {
    try {
      const data = await prisma.costInflationList.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error('Error fetching Cost Inflation Index data:', error);
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch Cost Inflation Index data',
      });
    }
  }

  static async getcountrycodelist(req: Request, res: Response) {
    try {
      const data = await prisma.countryCode.findMany({
        take: 15, // Limit to first 15 records
      });
      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error('Error fetching Country Code data:', error);
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch Country Code data',
      });
    }
  }
}


export default FinanceDataController;

