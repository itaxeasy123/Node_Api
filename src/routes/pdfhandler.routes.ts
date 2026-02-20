import fs from "fs";
import { Router } from "express";
import multer,{StorageEngine} from "multer";
import pdfController from "../controllers/pdf.controller";
import path from "path";

const uploadPath = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadPath)) {
  fs.mkdirSync(uploadPath);
}

// Define custom storage engine for multer
const storage: StorageEngine = multer.diskStorage({
  destination: function (req, file, cb) {
    // Specify the directory where files should be stored
    cb(null, uploadPath);
  },
  filename: function (req, file, cb) {
    // Generate a unique filename with the correct file extension
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);

    // Extract the file extension from the original filename
    const ext = path.extname(file.originalname).toLowerCase();

    cb(null, file.fieldname + "-" + uniqueSuffix + ext);
  },
});

// Initialize multer with the custom storage configuration
const upload = multer({ 
  storage,
  fileFilter: (req, file, cb) => {
    // Accept only specific file types
    const allowedTypes = ['.pdf', '.jpg', '.jpeg'];
    const ext = path.extname(file.originalname).toLowerCase();
    if (allowedTypes.includes(ext)) {
      cb(null, true);
    } else {
      cb(new Error("Only .pdf and .jpg files are allowed"));
    }
  }
});

const pdfRouter = Router();

pdfRouter.post("/merge-files", upload.array("files", 2),pdfController.mergeFiles)
// Split PDF File
pdfRouter.post(
    "/split-files",
    upload.single("file"), // Accept a single file
    pdfController.splitFiles
  );
  
  // Reduce PDF Size
  pdfRouter.post(
    "/reduce-size",
    upload.single("file"), // Accept a single file
    pdfController.reducePdfSize
  );

  pdfRouter.post(
    "/images-to-pdf",
    upload.array("images", 10), // Accept up to 10 image files
    pdfController.imagesToPdf
  );

export default pdfRouter
