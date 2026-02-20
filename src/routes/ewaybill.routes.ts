import { Router } from "express";
import ewaybillcontroller from "../controllers/sandbox/ewaybill.controller";
import verifyToken from "../middlewares/verify-token";

const ewaybill = Router();

ewaybill.post('/generate', verifyToken, ewaybillcontroller.generateEwaybill);
ewaybill.post("/auth", verifyToken, ewaybillcontroller.ewayauth);
ewaybill.post("/getebydate", verifyToken, ewaybillcontroller.getewaybillbydate);
ewaybill.post("/getebydoc", verifyToken, ewaybillcontroller.getewaybillbydocumentdata);
ewaybill.post("/cancel", verifyToken, ewaybillcontroller.cancelewaybill);
ewaybill.post("/getbydateconsignee", verifyToken, ewaybillcontroller.getewaybillbydateconsignee);
ewaybill.post("/rejecteway", verifyToken, ewaybillcontroller.rejectewaybill);
ewaybill.post("/ewaybydatestate", verifyToken, ewaybillcontroller.ewaybillsbydateandstate);
ewaybill.post("/ewaybillbygenerator", verifyToken, ewaybillcontroller.listewaybillbygenerator);
ewaybill.post("/updatevehicle", verifyToken, ewaybillcontroller.updatevehicledetails);
ewaybill.post("/extendeway", verifyToken, ewaybillcontroller.extendewaybillvalidity);
ewaybill.post("/updatetransporter", verifyToken, ewaybillcontroller.updatetransporterdetails);

export default ewaybill;