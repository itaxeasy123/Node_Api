import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import BankController from "../controllers/sandbox/bank.controller";

const bankRouter = Router();

bankRouter.post('/details', verifyToken, BankController.getBankDetailsByIfsc);

bankRouter.post('/verify-account', verifyToken, BankController.verifyBankAccount);

bankRouter.post('/upi-verify', verifyToken, BankController.upiVerification);

export default bankRouter;