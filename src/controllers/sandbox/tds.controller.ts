import { Request, Response } from "express";
import Sandbox from "../../services/sandbox.service";
import axios from "axios";

export default class TdsController {
  static async submitTxtJob(req: Request, res: Response) {
    try {
      const { tan, financial_year, quarter, form, previous_receipt_number } =
        req.body;

      // Validate required fields
      if (!tan || !financial_year || !quarter || !form) {
        return res.status(400).json({
          success: false,
          message:
            "Missing required fields: tan, financial_year, quarter, form",
        });
      }

      // Ensure financial_year has 'FY ' prefix
      let formattedYear = financial_year.trim();
      if (!formattedYear.startsWith("FY ")) {
        formattedYear = `FY ${formattedYear}`;
      }

      // Define the endpoint
      const endpoint = `${Sandbox.BASE_URL}/tds/reports/txt`;

      // Generate access token
      const token = await Sandbox.generateAccessToken();

      // Request headers
      const headers = {
        Authorization: token,
        Accept: "application/json",
        "x-api-key": process.env.SANDBOX_KEY!,
        "x-api-version": process.env.SANDBOX_API_VERSION!,
      };

      // Prepare request body
      const body: any = {
        "@entity": "in.co.sandbox.tds.reports.request",
        tan,
        financial_year: formattedYear,
        quarter,
        form,
      };

      // Add optional field if provided
      if (previous_receipt_number) {
        body.previous_receipt_number = previous_receipt_number;
      }

      // Make the API call
      const { status, data } = await axios.post(endpoint, body, { headers });

      if (status !== 200) {
        return res
          .status(500)
          .json({ success: false, message: "Something went wrong" });
      }

      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error submitting TDS TXT job:", error);

      if (axios.isAxiosError(error)) {
        return res.status(error.response?.status || 500).json({
          success: false,
          message:
            error.response?.data?.message || "Failed to submit TDS TXT job",
          debug: error.response?.data,
        });
      }

      return res.status(500).json({
        success: false,
        message: "Something went wrong during TXT job submission",
      });
    }
  }
  static async pollTxtJobStatus(req: Request, res: Response) {
    try {
      const { job_id } = req.params;
      if (!job_id) {
        return res.status(400).json({
          success: false,
          message: "Path parameter 'job_id' is required",
        });
      }

      const endpoint = `${Sandbox.BASE_URL}/tds/reports/txt/${job_id}`;
      const token = await Sandbox.generateAccessToken();

      const headers = {
        Authorization: token,
        Accept: "application/json",
        "x-api-key": process.env.SANDBOX_KEY!,
        "x-api-version": process.env.SANDBOX_API_VERSION!,
      };


      const response = await axios.get(endpoint, { headers });
      const { status: code, data } = response;

      if (code !== 200) {
        return res
          .status(500)
          .json({ success: false, message: "Failed to poll job status" });
      }

      return res.status(200).json({ success: true, data });
    } catch (error) {
      console.error("Error polling TDS TXT job status:", error);

      if (axios.isAxiosError(error)) {
        return res.status(error.response?.status || 500).json({
          success: false,
          message: error.response?.data?.message || "Polling TXT job failed",
          debug: error.response?.data,
        });
      }

      return res.status(500).json({
        success: false,
        message: "Something went wrong polling TXT job status",
      });
    }
  }
    static async fetchTxtJobs(req: Request, res: Response) {
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

    // Set the endpoint
    const endpoint = `${Sandbox.BASE_URL}/tds/reports/txt/search`;

    // Generate access token
    const token = await Sandbox.generateAccessToken();

    // Prepare headers
    const headers = {
      Authorization: token,
      Accept: "application/json",
      "x-api-key": process.env.SANDBOX_KEY!,
      "x-api-version": process.env.SANDBOX_API_VERSION!,
    };

    // Prepare request body
    const body: any = {
      "@entity": "in.co.sandbox.tds.reports.jobs.search",
      
    };

    if (tan) body.tan = tan;
      if (quarter) body.quarter = quarter;
      if (form) body.form = form;
      if (financial_year)
        body.financial_year = financial_year.startsWith("FY")
          ? financial_year
          : `FY ${financial_year}`;
      if (from_date) body.from_date = from_date;
      if (to_date) body.to_date = to_date;
      if (page_size) body.page_size = page_size;
      if (last_evaluated_key) body.last_evaluated_key = last_evaluated_key;


    const { status, data } = await axios.post(endpoint, body, { headers });

    if (status !== 200) {
      return res
        .status(500)
        .json({ success: false, message: "Failed to fetch TDS jobs" });
    }

    return res.status(200).json({ success: true, data });
  } catch (error) {
    console.error("❌ Error fetching TDS jobs:", error);

    if (axios.isAxiosError(error)) {
      return res.status(error.response?.status || 500).json({
        success: false,
        message: error.response?.data?.message || "Fetching TDS jobs failed",
        debug: error.response?.data,
      });
    }

    return res.status(500).json({
      success: false,
      message: "Something went wrong while fetching TDS jobs",
    });
  }
}

}
