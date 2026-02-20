import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import TcsController from "../controllers/sandbox/tcs.controller";

const tcsRouter = Router();

tcsRouter.post("/prepare-txt", verifyToken, TcsController.submitTcsJob);
tcsRouter.get(
  "/poll-txt/:job_id",
  verifyToken,
  TcsController.pollTcsTxtJobStatus
);
tcsRouter.post("/jobs-search", verifyToken, TcsController.fetchAllTcsJobs);

export default tcsRouter;
