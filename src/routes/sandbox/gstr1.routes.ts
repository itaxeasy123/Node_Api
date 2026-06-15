import { Router } from "express";
import GSTR1MockController from "../../controllers/sandbox/gstr1.controller";

const router = Router();

// Summary
router.get("/summary", GSTR1MockController.summary);

// Sections
router.get("/b2b", GSTR1MockController.b2b);
router.get("/b2cs", GSTR1MockController.b2cs);
router.get("/b2cl", GSTR1MockController.b2cl);
router.get("/cdnr", GSTR1MockController.cdnr);
router.get("/hsn", GSTR1MockController.hsn);
router.get("/nil", GSTR1MockController.nil);
router.get("/doc-issue", GSTR1MockController.docIssue);
router.get("/at", GSTR1MockController.at);
router.get("/ata", GSTR1MockController.ata);

// Actions
router.post("/save", GSTR1MockController.save);
router.post("/file", GSTR1MockController.file);
router.post("/reset", GSTR1MockController.reset);

export default router;
