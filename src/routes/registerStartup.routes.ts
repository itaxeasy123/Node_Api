import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import { RegisterStartupController } from "../controllers/registerStartup.controller";
import { multerInstance } from "../config/cloudinaryUploader";
import adminCheck from "../middlewares/admin-check";

const registerStartupRouter = Router();

registerStartupRouter.post(
  "/register",
  verifyToken,
  adminCheck,
  multerInstance.single("image"),
  RegisterStartupController.RegisterStartup
);
registerStartupRouter.get(
  "/getAll",
  verifyToken,
  RegisterStartupController.findAllStartup
);
registerStartupRouter.put(
  "/register/:id",
  verifyToken,
  adminCheck,
  multerInstance.single("image"),
  RegisterStartupController.update
);
registerStartupRouter.get(
  "/getOne/:id",
  verifyToken,
  RegisterStartupController.getById
);
registerStartupRouter.delete(
  "/delete/:id",
  verifyToken,
  adminCheck,
  RegisterStartupController.delete
);

export default registerStartupRouter;
