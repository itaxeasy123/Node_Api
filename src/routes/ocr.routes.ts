import { Router } from "express";
import multer, { StorageEngine } from "multer";
import ocrController from "../controllers/ocr.controller";

const orcRoutes = Router();

const storage: StorageEngine = multer.diskStorage({
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, file.fieldname + "-" + uniqueSuffix);
  },
});

const upload = multer({ storage });

orcRoutes.post("/", upload.single("file"), ocrController.ocrPost);

export default orcRoutes;
