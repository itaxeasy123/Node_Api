import { Router } from "express";
import CareerController from "../controllers/career.controller";
import upload from "../middlewares/upload";

const careerRouter = Router();

// Create Career (Send Email Only)
careerRouter.post(
  "/create",
  upload.single("cv"),
  CareerController.createCareer
);

export default careerRouter;
