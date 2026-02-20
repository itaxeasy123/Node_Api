import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import EinvoiceController from "../controllers/sandbox/einvoice.controller";

const einvoiceRouter = Router();
einvoiceRouter.post('/auth', verifyToken, EinvoiceController.einvoiceLogin);
einvoiceRouter.post('/generate', verifyToken, EinvoiceController.generateEinvoice);
einvoiceRouter.post('/by-irn', verifyToken, EinvoiceController.einvoicebyirn);
einvoiceRouter.post('/cancel', verifyToken, EinvoiceController.einvoiceCancel);
einvoiceRouter.post("/einvoicepdf", verifyToken, EinvoiceController.generateEinvoicePdf);
einvoiceRouter.post("/einvoicedoc", verifyToken, EinvoiceController.einvoicebydocumentdata);

export default einvoiceRouter;