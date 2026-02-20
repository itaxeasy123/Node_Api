import { Router } from "express";
import InsuranceController from "../controllers/insurance.controller";
import verifyToken from "../middlewares/verify-token";
import bodyValidator from "../middlewares/body-validator";
import adminCheck from "../middlewares/admin-check";

const insuranceRouter = Router();

insuranceRouter.post(
  "/apply",
  verifyToken,
  adminCheck,
  bodyValidator,
  InsuranceController.applyForInsurance
);

insuranceRouter.put(
  "/update/:id",
  verifyToken,
  adminCheck, 
  bodyValidator,
  InsuranceController.updateInsurance
);

insuranceRouter.get(
  "/getOne/:id",
  verifyToken,
  adminCheck,
  InsuranceController.getInsuranceById
);

insuranceRouter.get(
  "/getAll",
  verifyToken,
  adminCheck,
  InsuranceController.getInsuranceApplications
);

insuranceRouter.get(
  "/user/:id",
  verifyToken,
  adminCheck,
  InsuranceController.getInsuranceApplicationsByUser
);

insuranceRouter.delete(
  "/delete/:id",
  verifyToken,
  adminCheck,
  InsuranceController.deleteInsourance
);

export default insuranceRouter;
