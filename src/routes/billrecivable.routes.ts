import { Router } from "express";
import adminCheck from "../middlewares/admin-check";
import { Accountscontroller } from "../controllers/accounts.controller";
import verifyToken from "../middlewares/verify-token";

const billrecievablerouter = Router();

billrecievablerouter.post("/create",verifyToken,Accountscontroller.createbillrecivable)

billrecievablerouter.get("/getOne/:id",verifyToken,Accountscontroller.getonerecievablebill)

billrecievablerouter.get("/getAll",verifyToken,adminCheck,Accountscontroller.getallrecivablebill)

 billrecievablerouter.post("/update/:id",verifyToken,Accountscontroller.updaterecivalebill)

billrecievablerouter.delete("/delete/:id",verifyToken,Accountscontroller.deleterecivalebill)

export default billrecievablerouter;