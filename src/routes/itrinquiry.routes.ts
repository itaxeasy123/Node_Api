import { Router } from "express";
import ItrInquiryController from "../controllers/itrinquiry.controller";
import verifyToken from "../middlewares/verify-token";
import SuperadminCheck from "../middlewares/super-admin";
import { multerInstance } from "../config/cloudinaryUploader";

const itrInquiryRouter = Router();

// User submits an inquiry with documents
itrInquiryRouter.post(
  "/submit",
  verifyToken,
  multerInstance.fields([
    { name: "aadhaar", maxCount: 1 },
    { name: "pan", maxCount: 1 },
    { name: "otherDoc", maxCount: 1 },
  ]),
  ItrInquiryController.submitInquiry
);

// Logged-in user's own inquiries
itrInquiryRouter.get("/my", verifyToken, ItrInquiryController.getMyInquiries);

// User initiates payment for an approved inquiry
itrInquiryRouter.post(
  "/:id/pay",
  verifyToken,
  ItrInquiryController.createInquiryPayment
);

// User confirms a successful payment
itrInquiryRouter.post(
  "/:id/paid",
  verifyToken,
  ItrInquiryController.markInquiryPaid
);

// Super-admin: list all inquiries
itrInquiryRouter.get(
  "/all",
  verifyToken,
  SuperadminCheck,
  ItrInquiryController.getAllInquiries
);

// Super-admin: approve (with amount) / reject
itrInquiryRouter.post(
  "/:id/approve",
  verifyToken,
  SuperadminCheck,
  ItrInquiryController.approveInquiry
);
itrInquiryRouter.post(
  "/:id/reject",
  verifyToken,
  SuperadminCheck,
  ItrInquiryController.rejectInquiry
);

export default itrInquiryRouter;
