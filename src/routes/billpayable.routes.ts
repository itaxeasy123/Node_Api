import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import bodyValidator from "../middlewares/body-validator";
import queryValidator from "../middlewares/query-validator";
import { Accountscontroller } from "../controllers/accounts.controller";
import adminCheck from "../middlewares/admin-check";

const billpayablerouter = Router();

billpayablerouter.post("/create",verifyToken,Accountscontroller.Payablebill)

billpayablerouter.get("/getOne/:id",verifyToken,Accountscontroller.getonepayablebill)

// bills are user-scoped now (userId filter in the controller) — no admin gate
billpayablerouter.get("/getAll",verifyToken,Accountscontroller.getallpayablebill)

billpayablerouter.post("/update/:id",verifyToken,Accountscontroller.updatepayablebill)

billpayablerouter.delete("/delete/:id",verifyToken,Accountscontroller.deletepayablebill)
export default billpayablerouter;