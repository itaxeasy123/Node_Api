import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import PanAadhaarController from "../controllers/sandbox/panAadhaar.controller";
import PanController from "../controllers/sandbox/pan.controller";

const panRouter = Router();

panRouter.post('/pan-aadhaar-link-status', PanAadhaarController.checkLinkStatus);

panRouter.post('/get-pan-details', verifyToken, PanController.getAdvancePanDetails);

export default panRouter;