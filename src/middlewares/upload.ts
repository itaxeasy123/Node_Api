import multer from "multer";

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 1024 * 1024 }, // 1MB
  fileFilter: (req, file, cb) => {
    if (file.mimetype !== "application/pdf") {
      return cb(new Error("Only PDF files allowed"));
    }
    cb(null, true);
  },
});

export default upload;
