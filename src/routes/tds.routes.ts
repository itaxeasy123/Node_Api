import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import TdsController from "../controllers/sandbox/tds.controller";

const tdsRouter = Router();

// Submit TDS TXT Generation Job
tdsRouter.post("/prepare-txt", verifyToken, TdsController.submitTxtJob);
tdsRouter.get(
  "/job-status/:job_id",
  verifyToken,
  TdsController.pollTxtJobStatus
);
tdsRouter.post("/jobs-search", verifyToken, TdsController.fetchTxtJobs);

export default tdsRouter;
