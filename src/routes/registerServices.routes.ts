import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import { RegisterServicesController } from "../controllers/registerServices.controller";
import { multerInstance } from "../config/cloudinaryUploader";
import adminCheck from "../middlewares/admin-check";

const registerServicesRouter = Router();

registerServicesRouter.post(
  "/",
  verifyToken,
  
  // multerInstance.single('aadhaarCard'),
  // multerInstance.single('panCard'),
  // multerInstance.single('gstCertificate'),
  // multerInstance.single('photo'),
  multerInstance.fields([
    { name: "aadhaarCard", maxCount: 1 },
    { name: "panCard", maxCount: 1 },
    { name: "gstCertificate", maxCount: 1 },
    { name: "photo", maxCount: 1 },
  ]),
  RegisterServicesController.registerService
);
registerServicesRouter.get(
  "/",
  verifyToken,
  RegisterServicesController.findAllServices
);
registerServicesRouter.put(
  "/:id",
  verifyToken,
  adminCheck,
  multerInstance.fields([
    { name: "aadhaarCard", maxCount: 1 },
    { name: "panCard", maxCount: 1 },
    { name: "gstCertificate", maxCount: 1 },
    { name: "photo", maxCount: 1 },
  ]),
  RegisterServicesController.updateService
);
registerServicesRouter.get(
  "/:id",
  verifyToken,
  RegisterServicesController.getServiceById
);
registerServicesRouter.delete(
  "/:id",
  verifyToken,
  adminCheck,
  RegisterServicesController.deleteService
);

export default registerServicesRouter;
