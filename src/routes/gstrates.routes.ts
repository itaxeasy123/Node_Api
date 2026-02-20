import { Router } from "express";
import GstController from "../controllers/gst.controller";

const gstRatesRouter = Router();

gstRatesRouter.get('/gst-rates', GstController.getAllGSTRates);
gstRatesRouter.get('/gst-rates/:rate', GstController.getGSTRate);

export default gstRatesRouter;