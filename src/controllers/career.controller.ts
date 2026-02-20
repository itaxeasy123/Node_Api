
import { Request, Response } from "express";
import { sendCareerMail } from "../utils/sendCareerMail";

export default class CareerController {
  static async createCareer(req: Request, res: Response) {
    try {
      const file = req.file as Express.Multer.File;

      const { name, address, pin, email, mobile, skills, gender } = req.body;

      // Required fields validation
      if (!name || !skills || !gender || !email || !pin || !address || !mobile) {
        return res.status(400).json({
          success: false,
          message: "Missing required fields.",
        });
      }

      // File validation
      if (!file) {
        return res.status(400).json({
          success: false,
          message: "Resume PDF is required.",
        });
      }

      if (file.mimetype !== "application/pdf") {
        return res.status(400).json({
          success: false,
          message: "Only PDF files are allowed.",
        });
      }

      // Send Email
      await sendCareerMail(req.body, file);

      return res.status(200).json({
        success: true,
        message: "Application submitted successfully.",
      });

    } catch (error) {
      console.error("Career Error:", error);
      return res.status(500).json({
        success: false,
        message: "Something went wrong.",
      });
    }
  }
}
