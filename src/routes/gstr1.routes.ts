import { Router } from "express";
import GSTR1Controller from "../controllers/gstr1.controller";
import verifyToken from "../middlewares/verify-token";

const gstr1Router = Router();

// GSTR1 _4A

gstr1Router.post("/4a-create",verifyToken,GSTR1Controller.create)

gstr1Router.get("/4a-getone/:id",verifyToken,GSTR1Controller.getsingle)

gstr1Router.post("/4a-update/:id",verifyToken,GSTR1Controller.update)

gstr1Router.get("/4a-getall",verifyToken,GSTR1Controller.getll)

gstr1Router.get("/4a-viewall",verifyToken,GSTR1Controller.getallview4A)

gstr1Router.get("/4a-getbygstn/:id",verifyToken,GSTR1Controller.getbygstin4A)

gstr1Router.delete("/4a-delete/:id",verifyToken,GSTR1Controller.delete)

// GSTR1- 5A

gstr1Router.post("/5a-create",verifyToken,GSTR1Controller.create5A)

gstr1Router.post("/5a-update/:id",verifyToken,GSTR1Controller.update5A)

gstr1Router.get("/5a-getall",verifyToken,GSTR1Controller.getall5A)

gstr1Router.delete("/5a-delete/:id",verifyToken,GSTR1Controller.delete5A)

// GSTR1 - 6A

gstr1Router.post("/6a-create",verifyToken,GSTR1Controller.create6A)

gstr1Router.post("/6a-update/:id",verifyToken,GSTR1Controller.update6A)

gstr1Router.get("/6a-getall",verifyToken,GSTR1Controller.getall6A)

gstr1Router.delete("/6a-delete/:id",verifyToken,GSTR1Controller.delete6A)

// GSTR1-7B2C
gstr1Router.post("/7b-create",verifyToken,GSTR1Controller.Create7B)

gstr1Router.post("/7b-update/:id",verifyToken,GSTR1Controller.update7B)

gstr1Router.get("/7b-getall",verifyToken,GSTR1Controller.getall7B)

gstr1Router.delete("/7b-delete/:id",verifyToken,GSTR1Controller.delete7B)


// GSTR1 - 8ABCD

gstr1Router.post("/8abcd-create",verifyToken,GSTR1Controller.create8ABCD)

gstr1Router.get("/8abcd-getone/:id",verifyToken,GSTR1Controller.getsingle8ABCD)

// GSTR1 - 9B

gstr1Router.post("/9b-create",verifyToken,GSTR1Controller.create9B)

gstr1Router.post("/9b-update/:id",verifyToken,GSTR1Controller.update9B)

gstr1Router.get("/9b-getall",verifyToken,GSTR1Controller.getall9B)

gstr1Router.delete("/9b-delete/:id",verifyToken,GSTR1Controller.delete9B)


// GSTR1- 9BUNregistered

gstr1Router.post("/9bunregister-create",verifyToken,GSTR1Controller.create9Bunregister)

gstr1Router.post("/9bunregister-update",verifyToken,GSTR1Controller.update9Bunregister)

gstr1Router.get("/9bunregister-get",verifyToken,GSTR1Controller.get9bunregster)

// GSTR1 -11A2A2

gstr1Router.post("/11A1A2-create",verifyToken,GSTR1Controller.create11A2A2)

gstr1Router.post("/11A1A2-update",verifyToken,GSTR1Controller.update11A2A2)

gstr1Router.get("/11A1A2-get",verifyToken,GSTR1Controller.get11A2A2)

// Gstr1 B2B2

gstr1Router.post("/11B2B2-create",verifyToken,GSTR1Controller.create11B1B2)

gstr1Router.post("/11B2B2-update",verifyToken,GSTR1Controller.update11B1B2)

gstr1Router.get("/11B2B2-get",verifyToken,GSTR1Controller.get11B1B2)


export default gstr1Router;