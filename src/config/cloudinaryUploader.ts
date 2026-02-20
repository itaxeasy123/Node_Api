import fs from "fs/promises"; // Correct import for `fs` with promises
import multer from "multer";
import { v2 as cloudinary } from "cloudinary"; // Correct import for cloudinary.v2
import { Request } from "express";
// import { config } from "../lib/config";
import path from "path";

cloudinary.config({
  cloud_name: "drl3vjskb",
  api_key: "873359697654574",
  api_secret: "64ENuKTsjjCp7F1Vs-KBHeWbtsw",
});

// Cloudinary-specific parameters
const params = {
  folder: (req: Request) => {
    if (req.user) {
      const urlSegment = req.url.split("/").at(0);
      return `dashboard/users/${req.user.id}/${urlSegment || "images"}`;
    }
    const { email } = req.body;
    return `dashboard/careers/${email}`;
  },
  allowedFormats: ["jpeg", "png", "jpg", "pdf"],
  public_id: (req: Request, file: Express.Multer.File) => {
    const originalFileName = file.originalname
      .split(".")
      .at(0)
      ?.substring(0, 5); // Limit file name to 5 characters
    const timestamp = Date.now();
    return `${originalFileName}_${timestamp}`;
  },
};

// Local storage configuration for Multer
const localStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = path.join(__dirname, "../routes/uploads");
    cb(null, uploadPath); // Save files to the 'uploads' directory
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
    cb(null, `${uniqueSuffix}-${file.originalname}`);
  },
});

// Multer instance for local storage
export const multerInstance = multer({
  storage: localStorage,
  limits: {
    fileSize: 1 * 1024 * 1024, // Limit file size to 1 MB
  },
  fileFilter: (
    req: Request,
    file: Express.Multer.File,
    cb: multer.FileFilterCallback
  ) => {
    if (!file.originalname.match(/\.(jpg|jpeg|png|pdf)$/i)) {
      return cb(new Error("Only image and PDF files are allowed!"));
    }
    cb(null, true);
  },
});

// Function to upload files to Cloudinary
export const uploadToCloudinary = async (
  localFilePath: string,
  resourceType: "image" | "raw", // Cloudinary resource type
  req: Request,
  file: Express.Multer.File // Pass the file object here
) => {
  try {
    const result = await cloudinary.uploader.upload(localFilePath, {
      resource_type: resourceType,
      folder: params.folder(req), // Dynamic folder based on user or email
      allowed_formats: params.allowedFormats, // Allowed formats
      public_id: params.public_id(req, file), // Unique public ID
    });

    // Delete the local file after successful upload
    await fs.unlink(localFilePath);

    return result;
  } catch (error) {
    console.error("Cloudinary upload failed:", error);

    // Ensure local file is removed even if the upload fails
    await fs.unlink(localFilePath).catch(() =>
      console.error("Failed to delete local file after Cloudinary error")
    );
    throw error;
  }
};

// Helper function to extract public ID from a Cloudinary URL
export const getPublicIdByUrl = (url: string) => {
  try {
    const decodedUrl = decodeURIComponent(url); // Decode percent-encoded characters
    const parts = decodedUrl.split("/");
    const uploadIndex = parts.indexOf("upload");

    if (uploadIndex !== -1) {
      let publicId = parts.slice(uploadIndex + 2).join("/");
      publicId = publicId.split(".").slice(0, -1).join(".");
      return publicId;
    }
    return url;
  } catch (error) {
    console.error("Failed to extract public ID:", error);
    return url;
  }
};

// Function to delete images from Cloudinary by URL
export const deleteImageByUrl = async (
  imageUrls: string[],
  type: "image" | "raw" = "image" // Default type to 'image'
) => {
  try {
    const publicIds = imageUrls.map((url) => getPublicIdByUrl(url));
    const response = await cloudinary.api.delete_resources(publicIds, {
      type: "upload",
      resource_type: type,
    });

    // Check if the first public ID was deleted successfully
    return response.deleted[publicIds[0]] === "deleted";
  } catch (error) {
    console.error("Failed to delete images:", error);
    return false;
  }
};
