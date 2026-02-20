import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import bodyValidator from "../middlewares/body-validator";
import queryValidator from "../middlewares/query-validator";
import { Accountscontroller } from "../controllers/accounts.controller";
import adminCheck from "../middlewares/admin-check";

const billpayablerouter = Router();

billpayablerouter.post("/create",verifyToken,Accountscontroller.Payablebill)

billpayablerouter.get("/getOne/:id",verifyToken,Accountscontroller.getonepayablebill)

billpayablerouter.get("/getAll",verifyToken,adminCheck,Accountscontroller.getallpayablebill)

billpayablerouter.post("/update/:id",verifyToken,Accountscontroller.updatepayablebill)

billpayablerouter.delete("/delete/:id",verifyToken,Accountscontroller.deletepayablebill)
export default billpayablerouter;