import { Router } from "express";
import GSTController from "../../controllers/sandbox/gst.controller";
import gstr1Routes from "./gstr1.routes";

const router = Router();

/**
 * ======================
 * ROOT – SANDBOX HEALTH
 * ======================
 */
router.get("/", (_req, res) => {
  res.json({
    success: true,
    module: "GST Sandbox",
    message: "GST Sandbox APIs are working",
    routes: {
      searchGstin: "POST /api/sandbox/gst/search-gstin",
      searchPan: "POST /api/sandbox/gst/search-pan",

      otpGenerate: "POST /api/sandbox/gst/otp/generate",
      otpVerify: "POST /api/sandbox/gst/otp/verify",

      trackReturn: "POST /api/sandbox/gst/track-return",

      gstr1Summary: "GET /api/sandbox/gst/gstr1/summary",
      gstr1B2B: "GET /api/sandbox/gst/gstr1/b2b",
      gstr1B2CS: "GET /api/sandbox/gst/gstr1/b2cs",
      gstr1B2CL: "GET /api/sandbox/gst/gstr1/b2cl",
      gstr1CDNR: "GET /api/sandbox/gst/gstr1/cdnr",
      gstr1HSN: "GET /api/sandbox/gst/gstr1/hsn",
      gstr1NIL: "GET /api/sandbox/gst/gstr1/nil",
      gstr1DOC: "GET /api/sandbox/gst/gstr1/doc-issue",
      gstr1AT: "GET /api/sandbox/gst/gstr1/at",
      gstr1ATA: "GET /api/sandbox/gst/gstr1/ata",

      gstr1Save: "POST /api/sandbox/gst/gstr1/save",
      gstr1File: "POST /api/sandbox/gst/gstr1/file",

      gstr3bSummary: "GET /api/sandbox/gst/gstr3b/summary"
    }
  });
});

/**
 * ======================
 * BASIC GST
 * ======================
 */

// GST Search
router.post("/search-gstin", GSTController.searchByGSTIN);
router.post("/search-pan", GSTController.searchGSTINNumberByPan);

// OTP
router.post("/otp/generate", GSTController.generateOTP);
router.post("/otp/verify", GSTController.verifyOTP);

// Track Return
router.post("/track-return", GSTController.trackGSTReturn);

/**
 * ======================
 * GSTR-1
 * ======================
 */

// Base summary
router.get("/gstr1/summary", GSTController.gstr1Summary);

// Save / File
router.post("/gstr1/save", GSTController.saveGstr1);
router.post("/gstr1/file", GSTController.fileGSTR1);

// All GSTR-1 sections
router.use("/gstr1", gstr1Routes);

/**
 * ======================
 * GSTR-3B
 * ======================
 */
router.get("/gstr3b/summary", GSTController.getGSTR3BSummary);

export default router;
