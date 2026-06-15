import { uploadToCloudinary } from "../config/cloudinaryUploader";
import { prisma } from "../index";
import { Request, Response } from "express";
import EmailService from "../services/email.service";
import { getRazorpayInstance } from "../services/razorpay.service";

interface MulterFiles {
  [fieldname: string]: Express.Multer.File[];
}

const resourceTypeFor = (file: Express.Multer.File): "image" | "raw" =>
  file.mimetype.startsWith("image/") ? "image" : "raw";

export default class ItrInquiryController {
  // User submits an ITR filing inquiry with documents.
  static async submitInquiry(req: Request, res: Response): Promise<Response> {
    try {
      const user = req.user!;
      const name = (req.body?.name || "").toString().trim();
      const phone = (req.body?.phone || "").toString().trim();
      const aadhaarNumber = (req.body?.aadhaarNumber || "").toString().trim();
      const description = (req.body?.description || "").toString().trim();

      if (!name || !phone) {
        return res
          .status(400)
          .json({ success: false, message: "name and phone are required" });
      }

      const files = (req.files as MulterFiles) || {};
      const aadhaar = files.aadhaar?.[0];
      const pan = files.pan?.[0];
      const otherDoc = files.otherDoc?.[0];

      if (!aadhaar || !pan) {
        return res.status(400).json({
          success: false,
          message: "aadhaar and pan documents are required",
        });
      }

      const [aadhaarUpload, panUpload, otherDocUpload] = await Promise.all([
        uploadToCloudinary(aadhaar.path, resourceTypeFor(aadhaar), req, aadhaar),
        uploadToCloudinary(pan.path, resourceTypeFor(pan), req, pan),
        otherDoc
          ? uploadToCloudinary(otherDoc.path, resourceTypeFor(otherDoc), req, otherDoc)
          : Promise.resolve(null),
      ]);

      const inquiry = await prisma.itrInquiry.create({
        data: {
          userId: user.id,
          name,
          phone,
          aadhaarNumber: aadhaarNumber || null,
          description: description || null,
          aadhaarUrl: aadhaarUpload.secure_url,
          panUrl: panUpload.secure_url,
          otherDocUrl: otherDocUpload?.secure_url || null,
        },
      });

      // Notify the configured inbox (best-effort; do not fail the request on email error).
      const to = process.env.OTP_EMAIL;
      if (to) {
        const body = [
          `New ITR filing inquiry received.`,
          ``,
          `Name: ${name}`,
          `Phone: ${phone}`,
          `Aadhaar number: ${aadhaarNumber || "-"}`,
          `User email: ${user.email}`,
          `Description: ${description || "-"}`,
          ``,
          `Aadhaar: ${aadhaarUpload.secure_url}`,
          `PAN: ${panUpload.secure_url}`,
          `Other doc: ${otherDocUpload?.secure_url || "-"}`,
          ``,
          `Review and approve it in the super-admin dashboard.`,
        ].join("\n");
        EmailService.sendMail(to, "New ITR Filing Inquiry", body).catch((e) =>
          console.error("ITR inquiry email failed:", e)
        );
      }

      return res.status(201).json({ success: true, data: inquiry });
    } catch (error) {
      console.error("ITR inquiry submit error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong" });
    }
  }

  // The logged-in user's own inquiries.
  static async getMyInquiries(req: Request, res: Response): Promise<Response> {
    try {
      const user = req.user!;
      const inquiries = await prisma.itrInquiry.findMany({
        where: { userId: user.id },
        orderBy: { createdAt: "desc" },
      });
      return res.status(200).json({ success: true, data: inquiries });
    } catch (error) {
      console.error("ITR inquiry (my) error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong" });
    }
  }

  // Super-admin: all inquiries with submitter info.
  static async getAllInquiries(req: Request, res: Response): Promise<Response> {
    try {
      const inquiries = await prisma.itrInquiry.findMany({
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
      return res.status(200).json({ success: true, data: inquiries });
    } catch (error) {
      console.error("ITR inquiry (all) error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong" });
    }
  }

  // Super-admin: approve an inquiry and set the amount the user must pay.
  static async approveInquiry(req: Request, res: Response): Promise<Response> {
    try {
      const id = parseInt(req.params.id, 10);
      const amount = Number(req.body?.amount);

      if (!id || !Number.isFinite(amount) || amount <= 0) {
        return res.status(400).json({
          success: false,
          message: "Valid inquiry id and positive amount are required",
        });
      }

      const inquiry = await prisma.itrInquiry.update({
        where: { id },
        data: { status: "approved", amount },
      });

      return res.status(200).json({ success: true, data: inquiry });
    } catch (error) {
      console.error("ITR inquiry approve error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong" });
    }
  }

  // Super-admin: reject an inquiry.
  static async rejectInquiry(req: Request, res: Response): Promise<Response> {
    try {
      const id = parseInt(req.params.id, 10);
      if (!id) {
        return res
          .status(400)
          .json({ success: false, message: "Valid inquiry id is required" });
      }

      const inquiry = await prisma.itrInquiry.update({
        where: { id },
        data: { status: "rejected" },
      });

      return res.status(200).json({ success: true, data: inquiry });
    } catch (error) {
      console.error("ITR inquiry reject error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong" });
    }
  }

  // User: create a Razorpay order for an approved inquiry's amount.
  static async createInquiryPayment(
    req: Request,
    res: Response
  ): Promise<Response> {
    try {
      const user = req.user!;
      const id = parseInt(req.params.id, 10);

      const inquiry = await prisma.itrInquiry.findUnique({ where: { id } });
      if (!inquiry || inquiry.userId !== user.id) {
        return res
          .status(404)
          .json({ success: false, message: "Inquiry not found" });
      }
      if (inquiry.status !== "approved" || !inquiry.amount) {
        return res.status(400).json({
          success: false,
          message: "Inquiry is not approved for payment",
        });
      }

      const razorpay = getRazorpayInstance();
      const order = await razorpay.orders.create({
        amount: Math.round(inquiry.amount * 100), // paise
        currency: "INR",
        receipt: `itr_inquiry_${inquiry.id}`,
        payment_capture: 1,
        notes: { inquiryId: inquiry.id.toString(), userId: user.id.toString() },
      });

      await prisma.itrInquiry.update({
        where: { id },
        data: { razorpayOrderId: order.id },
      });

      return res.status(200).json({ success: true, order, amount: inquiry.amount });
    } catch (error) {
      console.error("ITR inquiry payment error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Payment initiation failed" });
    }
  }

  // User: mark inquiry paid after a successful Razorpay payment.
  static async markInquiryPaid(req: Request, res: Response): Promise<Response> {
    try {
      const user = req.user!;
      const id = parseInt(req.params.id, 10);

      const inquiry = await prisma.itrInquiry.findUnique({ where: { id } });
      if (!inquiry || inquiry.userId !== user.id) {
        return res
          .status(404)
          .json({ success: false, message: "Inquiry not found" });
      }

      const wasAlreadyPaid = inquiry.status === "paid";

      const updated = await prisma.itrInquiry.update({
        where: { id },
        data: { status: "paid" },
      });

      // Record the payment as a transaction so it shows in the user's and the
      // super-admin's transaction sections. Idempotent: only on first payment.
      if (!wasAlreadyPaid && inquiry.amount) {
        await prisma.subscriptions
          .create({
            data: {
              userId: user.id,
              amountForServices: inquiry.amount,
              status: "success",
              pid: inquiry.razorpayOrderId || `ITR-${inquiry.id}`,
              note: `ITR Filing — ${inquiry.name}`,
            },
          })
          .catch((e) =>
            console.error("ITR payment -> subscription create failed:", e)
          );
      }

      return res.status(200).json({ success: true, data: updated });
    } catch (error) {
      console.error("ITR inquiry mark-paid error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong" });
    }
  }
}
