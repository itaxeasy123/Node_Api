// import { Router } from "express";
// import verifyToken from "../middlewares/verify-token";
// import { ContactUsController } from "../controllers/contactUs.controller";

// const contactUsRouter = Router()

// contactUsRouter.post('/create', verifyToken, ContactUsController.contactUs);
// contactUsRouter.get('/getAll', verifyToken, ContactUsController.findAllContactUs);
// contactUsRouter.get('/getOne/:id', verifyToken, ContactUsController.getById);
// contactUsRouter.delete('/delete/:id', verifyToken, ContactUsController.delete);

// export default contactUsRouter

import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import { ContactUsController } from "../controllers/contactUs.controller";
import multer from "multer";

const contactUsRouter = Router();

// ✅ multer config (IMPORTANT)
const upload = multer({
  storage: multer.memoryStorage(), // file buffer me ayegi
});

// ✅ FINAL ROUTE
contactUsRouter.post(
  "/create",
  verifyToken,
  upload.single("profile"), // 🔥 must match frontend key
  ContactUsController.contactUs
);

contactUsRouter.get("/getAll", verifyToken, ContactUsController.findAllContactUs);
contactUsRouter.get("/getOne/:id", verifyToken, ContactUsController.getById);
contactUsRouter.delete("/delete/:id", verifyToken, ContactUsController.delete);

export default contactUsRouter;