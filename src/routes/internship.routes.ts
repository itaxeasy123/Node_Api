import { Router } from "express";
import multer from "multer";
import { submitInternship } from "../controllers/internship.controller";

const router = Router();

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB
});

router.post("/", upload.single("documents"), submitInternship);

export default router;