import { Request, Response, Router } from "express";
import userRouter from "./user.routes";
import businessProfileRouter from "./businessProfile.routes";
import invoiceRouter from "./invoice.routes";
import pincodeRouter from "./pincode.routes";
import cmsRouter from "./cms.routes";
import postOfficeRouter from "./postOffice.routes";
import servicesRouter from "./services.routes";
import paymentsRouter from "./payments.routes";
import paymentRouter from "./payment.routes";
import ordersRouter from "./orders.routes";
import libraryRouter from "./library.routes";
import blogRouter from "./blog.routes";
import panRouter from "./pan.routes";

// import gstRouter from "./gst.routes";
   //  ******** GST SANDBOX TESTING ROUTES ********
import gstSandboxRoutes from "./sandbox/gst.routes";
import sandboxGstRoutes from "./sandbox/gst.routes";
// ***********************************************
import careerRouter from "./career.routes";
import internshipRouter from "./internship.routes"; // 🔥 ADD THIS LINE
import mcaRouter from "./mca.routes";
import calculatorRouter from "./calculators.routes";
import tanRouter from "./tan.routes";
import bankRouter from "./bank.routes";
import aadhaarRouter from "./aadhaar.routes";
import loanRouter from "./loan.routes";
import documentRouter from "./document.routes";
import visitorRouter from "./visitorCounter.routes";
import registerStartupRouter from "./registerStartup.routes";
import contactUsRouter from "./contactUs.routes";
import insurancerouter from "./insurance.routes";
import { registerAbout } from "./about.routes";
import accountancyRouter from "./accountancy.routes";
import HsnAndSACRouter from "./hsnAndSac.routes";
import billpayablerouter from "./billpayable.routes";
import billrecievablerouter from "./billrecivable.routes";
import gstr1Router from "./gstr1.routes";
import orcRoutes from "./ocr.routes";
import registerServicesRouter from "./registerServices.routes";
import pdfRouter from "./pdfhandler.routes";
import gstRatesRouter from "./gstrates.routes";
import apirouter from "./apiservice.routes";
import strictLimiter from "../middlewares/redis-adder"   // this is redis for saving data in real time to limit api calls of sandbox api
import downloadrouter from "./download.routes";
import verifyToken from "../middlewares/verify-token";
import razorpayRouter from "./razorpay.routes";
// import EinvoiceController from "../controllers/sandbox/einvoice.controller";
import einvoiceRouter from "./Einvoice.routes";
import ewaybill from "./ewaybill.routes";
import cartRouter from "./cart.routes";
import cartStartupRouter from "./cartstartup.routes";
import tdsRouter from "./tds.routes";
import tcsRouter from "./tcs.routes";
const router = Router();

router.use("/user", userRouter);

router.use("/business", businessProfileRouter);

router.use("/invoice", invoiceRouter);

router.use("/cart",  cartRouter);

router.use("/cartStartup",  cartStartupRouter);

router.use("/gstrates", gstRatesRouter);

router.use("/cms",cmsRouter);

router.use("/pincode", pincodeRouter);

router.use("/postOffice", postOfficeRouter);

router.use("/pan",verifyToken,panRouter);

router.use("/razorpay",verifyToken,razorpayRouter);

// router.use("/gst",verifyToken,strictLimiter,gstRouter);

// router.use("/gst",gstRouter);
 
// Sandbox GST testing routes
router.use("/sandbox/gst", gstSandboxRoutes);
router.use("/sandbox/gst", sandboxGstRoutes);
// 🔥 ADD THIS LINE (MOST IMPORTANT)


router.use("/accountancy", accountancyRouter);

router.use("/services", servicesRouter);

router.use("/payments", paymentsRouter);

router.use("/payment", paymentRouter);

router.use("/orders", ordersRouter);

router.use("/library", libraryRouter);

router.use("/blog", blogRouter);

router.use("/mca",verifyToken, mcaRouter);

router.use("/tan",verifyToken,strictLimiter, tanRouter);

router.use("/bank", bankRouter);

router.use("/aadhaar",verifyToken,aadhaarRouter);

router.use("/calculator", calculatorRouter);

router.use("/career", careerRouter);

router.use("/internship", internshipRouter);  // 🔥 ADD THIS LINE

router.use("/loan", loanRouter);

router.use("/documents", documentRouter);

// router.use("/insurance", documentRouter);

router.use("/visitorCount", visitorRouter);

router.use("/Startup", registerStartupRouter);
router.use("/registration", registerServicesRouter);

router.use("/contactUs", contactUsRouter);

router.use("/insurance", insurancerouter);

router.use("/aboutTeam", registerAbout);

router.use("/codes", HsnAndSACRouter);

router.use("/billpayable", billpayablerouter);

router.use("/billrecieve", billrecievablerouter);

router.use("/gstr1",verifyToken,strictLimiter,gstr1Router);

router.use("/ocr", orcRoutes);

router.use("/pdf", pdfRouter);

router.use("/apis",apirouter);

router.use("/download",downloadrouter);
router.use("/einvoice",einvoiceRouter);

router.use("/ewaybill",ewaybill);

router.use("/tds", tdsRouter);

router.use("/tcs",tcsRouter);

router.get("/", (req, res) => {
  return res.send({ message: "Up and running" });
});

const handlePageNotFound = (req: Request, res: Response) => {
  return res.status(404).send({ message: "Endpoint not found" });
};

router.get("*", handlePageNotFound);

router.post("*", handlePageNotFound);

export default router;
