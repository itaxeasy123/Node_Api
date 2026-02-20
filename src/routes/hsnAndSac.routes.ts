import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import queryValidator from "../middlewares/query-validator";
import HsnAndSacController from "../controllers/hsnAndSac.controller";

const HsnAndSACRouter = Router();

HsnAndSACRouter.get('/getallhsncode',HsnAndSacController.getallHsncode )

HsnAndSACRouter.get('/getbyhsncode',HsnAndSacController.getbyhsncode )

HsnAndSACRouter.get('/getallsaccodes',HsnAndSacController.getallSaccode )

HsnAndSACRouter.get('/getbysaccode',HsnAndSacController.getbysaccode )
export default HsnAndSACRouter;