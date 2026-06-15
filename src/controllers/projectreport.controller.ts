import { uploadToCloudinary } from "../config/cloudinaryUploader";
import { prisma } from "../index";
import { Request, Response } from "express";

export default class ProjectReportController {
  // User submits a generated project-report PDF; store it on Cloudinary and persist a row.
  static async submitReport(req: Request, res: Response): Promise<Response> {
    try {
      const user = req.user!;
      const businessName = (req.body?.businessName || "").toString().trim();

      if (!businessName) {
        return res
          .status(400)
          .json({ success: false, message: "businessName is required" });
      }

      if (!req.file) {
        return res
          .status(400)
          .json({ success: false, message: "PDF file is required" });
      }

      const cloudinaryResult = await uploadToCloudinary(
        req.file.path,
        "raw",
        req,
        req.file
      );

      const report = await prisma.projectReport.create({
        data: {
          userId: user.id,
          businessName,
          pdfUrl: cloudinaryResult.secure_url,
          pdfPublicId: cloudinaryResult.public_id,
        },
      });

      return res.status(201).json({ success: true, data: report });
    } catch (error) {
      console.error("Project report submit error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong" });
    }
  }

  // The logged-in user's own report history.
  static async getMyReports(req: Request, res: Response): Promise<Response> {
    try {
      const user = req.user!;
      const reports = await prisma.projectReport.findMany({
        where: { userId: user.id },
        orderBy: { createdAt: "desc" },
      });
      return res.status(200).json({ success: true, data: reports });
    } catch (error) {
      console.error("Project report (my) error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong" });
    }
  }

  // Super-admin: every user's reports, newest first, with submitter info.
  static async getAllReports(req: Request, res: Response): Promise<Response> {
    try {
      const limit = req.query.limit
        ? parseInt(req.query.limit as string, 10)
        : undefined;

      const reports = await prisma.projectReport.findMany({
        take: limit,
        orderBy: { createdAt: "desc" },
        include: {
          user: {
            select: {
              id: true,
              firstName: true,
              lastName: true,
              email: true,
              phone: true,
            },
          },
        },
      });

      return res.status(200).json({ success: true, data: reports });
    } catch (error) {
      console.error("Project report (all) error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong" });
    }
  }
}
