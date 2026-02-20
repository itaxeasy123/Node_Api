import { Router } from "express";
import TanController from "../controllers/sandbox/tan.controller";
import verifyToken from "../middlewares/verify-token";

const tanRouter = Router();

tanRouter.post('/search', verifyToken, TanController.searchByTanNo);

export default tanRouter;