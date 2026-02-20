import { Router } from "express";
import RazorpayController from "../controllers/payment/razorpay.controller";
import verifyToken from "../middlewares/verify-token";

const razorpayRouter = Router();

razorpayRouter.post('/initiate_payment', verifyToken, RazorpayController.createOrder);
razorpayRouter.post('/callback', verifyToken, RazorpayController.razorCallback);
razorpayRouter.put('/refetch', verifyToken, RazorpayController.refetchOrder);

export default razorpayRouter;