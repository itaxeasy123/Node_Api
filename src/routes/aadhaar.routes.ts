import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import AadhaarController from "../controllers/sandbox/aadhaar.controller";

const aadhaarRouter = Router();

aadhaarRouter.post('/verify', verifyToken, AadhaarController.verifyAadhaar);

aadhaarRouter.post('/aadhaar-generate-otp',verifyToken,AadhaarController.aadharGenerateOtp)

aadhaarRouter.post('/aadhaar-verify-otp',verifyToken,AadhaarController.aadhaarVerifyOtp)

export default aadhaarRouter;