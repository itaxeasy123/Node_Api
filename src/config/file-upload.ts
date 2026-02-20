import multer from "multer";
import path from "path";
import fs from "fs";

const createUploadsFolder = () => {
  const folderPath = path.join(__dirname, "uploads");
  if (!fs.existsSync(folderPath)) {
    fs.mkdirSync(folderPath);
  }
};

// Call the function to create the uploads folder
createUploadsFolder();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    console.log(file);
    const fileExtension = path.extname(file.originalname);
    const filename = file.fieldname + "-" + uniqueSuffix + fileExtension;
    cb(null, filename);
  },
});

export const upload = multer({ storage });
