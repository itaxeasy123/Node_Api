import { Router } from "express";
import ProjectReportController from "../controllers/projectreport.controller";
import verifyToken from "../middlewares/verify-token";
import SuperadminCheck from "../middlewares/super-admin";
import { multerInstance } from "../config/cloudinaryUploader";

const projectReportRouter = Router();

// User submits a generated PDF (multipart field name: "pdf")
projectReportRouter.post(
  "/submit",
  verifyToken,
  multerInstance.single("pdf"),
  ProjectReportController.submitReport
);

// Logged-in user's own report history
projectReportRouter.get("/my", verifyToken, ProjectReportController.getMyReports);

// Super-admin: all users' reports
projectReportRouter.get(
  "/all",
  verifyToken,
  SuperadminCheck,
  ProjectReportController.getAllReports
);

export default projectReportRouter;
