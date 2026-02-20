import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import CMSController from "../controllers/cms.controller";
import adminCheck from "../middlewares/admin-check";
import SuperadminCheck from "../middlewares/super-admin";

const cmsRouter = Router();

cmsRouter.get("/homescreen", CMSController.getHomeScreen);

cmsRouter.get("/total-users", CMSController.getUserCount);

cmsRouter.get("/stats", CMSController.getStats);

cmsRouter.get(
  "/mailing-list",
  verifyToken,
  adminCheck,
  CMSController.getMailingList
);

cmsRouter.get("/phone-list", SuperadminCheck, CMSController.getPhoneList);

cmsRouter.post(
  "/main-heading-content",
  verifyToken,
  adminCheck,
  CMSController.updateMainHeadingcontent
);

cmsRouter.post(
  "/navcards",
  verifyToken,
  adminCheck,
  CMSController.updateNavCards
);

cmsRouter.post("/cards", verifyToken, adminCheck, CMSController.updatehomeCard);

cmsRouter.post(
  "/ongoingprojects",
  verifyToken,
  adminCheck,
  CMSController.updateOnGoingprojects
);

cmsRouter.post(
  "/corporateprojects",
  verifyToken,
  adminCheck,
  CMSController.updateCorporateprojects
);

// Footer
cmsRouter.put("/footer", verifyToken, adminCheck, CMSController.updateFooter);
cmsRouter.get("/footer", CMSController.getFooter);

export default cmsRouter;
