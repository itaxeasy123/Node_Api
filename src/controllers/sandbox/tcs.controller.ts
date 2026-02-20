// src/controllers/tds/tcs.controller.ts
import { Request, Response } from "express";
import Sandbox from "../../services/sandbox.service";
import axios from "axios";

export default class TcsController {
  static async submitTcsJob(req: Request, res: Response) {
    try {
      const { tan, financial_year, quarter, previous_receipt_number } = req.body;

      if (!tan || !financial_year || !quarter) {
        return res.status(400).json({
          success: false,
          message: "Missing required fields: tan, financial_year, quarter",
        });
      }

      // Auto add "FY " if not present
      const fy = financial_year.startsWith("FY") ? financial_year : `FY ${financial_year}`;

      const endpoint = `${Sandbox.BASE_URL}/tcs/reports/txt`;
      const token = await Sandbox.generateAccessToken();

      const headers = {
        Authorization: token,
        Accept: "application/json",
        "x-api-key": process.env.SANDBOX_KEY!,
        "x-api-version": process.env.SANDBOX_API_VERSION || "1.0",
      };

      const body: any = {
        "@entity": "in.co.sandbox.tcs.reports.request",
        tan,
        financial_year: fy,
        quarter,
      };

      if (previous_receipt_number) {
        body.previous_receipt_number = previous_receipt_number;
      }

      const { status, data } = await axios.post(endpoint, body, { headers });

      if (status !== 200) {
        return res.status(500).json({
          success: false,
          message: "Something went wrong",
        });
      }

      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error submitting TCS TXT job:", error);

      if (axios.isAxiosError(error)) {
        return res.status(error.response?.status || 500).json({
          success: false,
          message: error.response?.data?.message || "Failed to submit TCS TXT job",
          debug: error.response?.data,
        });
      }

      return res.status(500).json({
        success: false,
        message: "Something went wrong during TCS job submission",
      });
    }
  }
  static async pollTcsTxtJobStatus(req: Request, res: Response) {
    try {
      const { job_id } = req.params;

      if (!job_id) {
        return res.status(400).json({
          success: false,
          message: "Path parameter 'job_id' is required",
        });
      }

      const endpoint = `${Sandbox.BASE_URL}/tcs/reports/txt/${job_id}`;

      const token = await Sandbox.generateAccessToken();

      const headers = {
        Authorization: token,
        Accept: "application/json",
        "x-api-key": process.env.SANDBOX_KEY!,
        "x-api-version": process.env.SANDBOX_API_VERSION!,
      };

      const { status, data } = await axios.get(endpoint, { headers });

      if (status !== 200) {
        return res.status(500).json({
          success: false,
          message: "Failed to fetch TCS job status",
        });
      }

      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("❌ Error polling TCS TXT job status:", error);

      if (axios.isAxiosError(error)) {
        return res.status(error.response?.status || 500).json({
          success: false,
          message: error.response?.data?.message || "Polling TCS job failed",
          debug: error.response?.data,
        });
      }

      return res.status(500).json({
        success: false,
        message: "Something went wrong polling TCS TXT job status",
      });
    }
  }

  static async fetchAllTcsJobs(req: Request, res: Response) {
    try {
      const {
        tan,
        quarter,
        form,
        financial_year,
        from_date,
        to_date,
        page_size,
        last_evaluated_key,
      } = req.body;

      // Automatically prefix financial_year with "FY" if not present
      const fy = financial_year?.startsWith("FY")
        ? financial_year
        : `FY ${financial_year}`;

      const endpoint = `${Sandbox.BASE_URL}/tcs/reports/txt/search`;
      const token = await Sandbox.generateAccessToken();

      const headers = {
        Authorization: token,
        Accept: "application/json",
        "x-api-key": process.env.SANDBOX_KEY!,
        "x-api-version": process.env.SANDBOX_API_VERSION!,
      };

      const body: any = {
        "@entity": "in.co.sandbox.tcs.reports.jobs.search",
      };

      if (tan) body.tan = tan;
      if (quarter) body.quarter = quarter;
      if (form) body.form = form;
      if (financial_year) body.financial_year = fy;
      if (from_date) body.from_date = from_date;
      if (to_date) body.to_date = to_date;
      if (page_size) body.page_size = page_size;
      if (last_evaluated_key) body.last_evaluated_key = last_evaluated_key;

      const { status, data } = await axios.post(endpoint, body, { headers });

      if (status !== 200) {
        return res.status(500).json({
          success: false,
          message: "Failed to get all TCS report jobs",
        });
      }

      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error fetching TCS report jobs:", error);
      if (axios.isAxiosError(error)) {
        return res.status(error.response?.status || 500).json({
          success: false,
          message: error.response?.data?.message || "TCS job fetch failed",
          debug: error.response?.data,
        });
      }

      return res.status(500).json({
        success: false,
        message: "Something went wrong while fetching TCS jobs",
      });
    }
  }
}
