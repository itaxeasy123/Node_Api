import { Request, Response } from "express";
import { prisma } from "../index";
import { Prisma } from "@prisma/client";
import { ZodError, z } from "zod";
import { deleteImageByUrl, uploadToCloudinary } from "../config/cloudinaryUploader";
// Removed: import * as Multer from 'multer'; // This import was causing type conflicts.

// Local helper types for this controller
interface MulterFiles {
  aadhaarCard?: Express.Multer.File[];
  panCard?: Express.Multer.File[];
  gstCertificate?: Express.Multer.File[];
  photo?: Express.Multer.File[];
}

const servicesCreateSchema = z.object({
  // serviceId is transformed to an integer
  serviceId: z.string().transform((n) => parseInt(n, 10)),
});

export class RegisterServicesController {
  // Updated registerService method with Cloudinary integration
  static async registerService(req: Request, res: Response) {
    try {
      // TypeScript now understands req.user
      const userId = req.user?.id;

      if (!userId) {
        return res.status(400).json({
          success: false,
          message: "Token not found",
        });
      }

      // Verify user exists
      const user = await prisma.user.findUnique({
        where: { id: userId }
      });

      if (!user) {
        return res.status(404).json({
          success: false,
          message: "User not found",
        });
      }

      const { serviceId } = servicesCreateSchema.parse(req.body);
      // TypeScript now understands req.files as MulterFiles
      const files = req.files as MulterFiles;
      const aadhaarCard = files.aadhaarCard;
      const panCard = files.panCard;
      const gstCertificate = files.gstCertificate;
      const photo = files.photo;

      // Validate that all required files are present
      if (!aadhaarCard?.[0] || !panCard?.[0] || !gstCertificate?.[0] || !photo?.[0]) {
        return res.status(400).json({
          success: false,
          message: "All required files (aadhaarCard, panCard, gstCertificate, photo) must be uploaded",
        });
      }

      // Upload files to Cloudinary
      const [aadhaarUpload, panUpload, gstUpload, photoUpload] = await Promise.all([
        uploadToCloudinary(
          aadhaarCard[0].path,
          aadhaarCard[0].mimetype.startsWith('image/') ? "image" : "raw",
          req,
          aadhaarCard[0]
        ),
        uploadToCloudinary(
          panCard[0].path,
          panCard[0].mimetype.startsWith('image/') ? "image" : "raw",
          req,
          panCard[0]
        ),
        uploadToCloudinary(
          gstCertificate[0].path,
          gstCertificate[0].mimetype.startsWith('image/') ? "image" : "raw",
          req,
          gstCertificate[0]
        ),
        uploadToCloudinary(
          photo[0].path,
          "image",
          req,
          photo[0]
        ),
      ]);

      // Create service registration record with Cloudinary URLs
      const newService = await prisma.registerServices.create({
        data: {
          serviceId,
          userId,
          aadhaarCard: aadhaarUpload.secure_url,
          panCard: panUpload.secure_url,
          gstCertificate: gstUpload.secure_url,
          photo: photoUpload.secure_url,
        },
      });

      return res.status(201).json({
        success: true,
        result: newService,
        message: "Service registered successfully",
      });
    } catch (error) {
      console.error("Service registration error:", error);

      if (error instanceof ZodError) {
        return res.status(400).json({
          success: false,
          message: "Validation Error",
          errors: error.errors,
        });
      }

      // Handle Cloudinary upload errors
      if (error instanceof Error && error.message.includes("Cloudinary")) {
        return res.status(500).json({
          success: false,
          message: "File upload failed",
          error: error.message,
        });
      }

      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }

  static async findAllServices(req: Request, res: Response) {
    try {
      const userId = req.user?.id;
      const whereClause: Prisma.RegisterServicesWhereInput = {};

      if (!userId) {
        return res.status(400).json({
          success: false,
          message: "Invalid Request",
        });
      }

      if (req.user?.userType === "normal") {
        whereClause["userId"] = userId;
      }

      // Pagination parameters
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 10;
      const skip = (page - 1) * limit;

      const allServices = await prisma.registerServices.findMany({
        where: whereClause,
        include: {
          user: {
            select: {
              firstName: true,
              middleName: true,
              lastName: true,
              email: true,
              phone: true,
              id: true,
              address: true,
            },
          },
          registerStartup: {
            select: {
              title: true,
              priceWithGst: true,
              categories: true,
            },
          },
        },
        skip,
        take: limit,
      });

      // Total count for pagination info
      const totalCount = await prisma.registerServices.count({
        where: whereClause,
      });

      return res.status(200).json({
        success: true,
        data: allServices,
        pagination: {
          total: totalCount,
          totalPages: Math.ceil(totalCount / limit),
          currentPage: page,
          pageSize: limit,
        },
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error instanceof Error && error.toString(),
      });
    }
  }

  static async getServiceById(req: Request, res: Response) {
    try {
      const { id } = req.params;

      const service = await prisma.registerServices.findUnique({
        where: { id: parseInt(id) },
      });

      if (!service) {
        return res
          .status(404)
          .json({ success: false, message: "Service not found" });
      }

      return res.status(200).json({ success: true, data: service });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error instanceof Error && error.toString(),
      });
    }
  }

  static async deleteService(req: Request, res: Response) {
    try {
      const { id } = req.params;

      // First, retrieve the record to get the Cloudinary URLs
      const serviceToDelete = await prisma.registerServices.findUnique({
        where: { id: parseInt(id) }
      });

      if (!serviceToDelete) {
        return res.status(404).json({ success: false, message: "Service not found" });
      }

      // Extract URLs before deletion
      const { aadhaarCard, gstCertificate, panCard, photo } = serviceToDelete;

      // Delete the record from the database
      await prisma.registerServices.delete({
        where: { id: parseInt(id) },
      });

      // Delete files from Cloudinary
      await deleteImageByUrl([aadhaarCard, gstCertificate, panCard, photo]);

      return res.status(200).json({
        success: true,
        message: "Service deleted successfully",
      });
    } catch (error) {
      // Check for Prisma P2025 (Record to delete does not exist) if it's not a 404 handled above
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2025') {
        return res.status(404).json({
          success: false,
          message: "Service not found",
        });
      }

      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error instanceof Error && error.toString(),
      });
    }
  }

  // --- UPDATED METHOD TO INTEGRATE CLOUDINARY UPLOAD AND CLEANUP ---
  static async updateService(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const serviceIdToUpdate = parseInt(id);
      const userId = req.user?.id;

      // 1. Validate ID and find existing service to get old URLs
      const existingService = await prisma.registerServices.findUnique({
        where: { id: serviceIdToUpdate },
      });

      if (!existingService) {
        return res.status(404).json({ success: false, message: "Service registration not found" });
      }

      // Optional: Authorization check (ensure user owns the service)
      if (existingService.userId !== userId) {
        return res.status(403).json({ success: false, message: "Unauthorized to update this service" });
      }

      // Parse body, only including fields that are expected to be updated
      const { serviceId } = servicesCreateSchema.parse(req.body);
      const files = req.files as MulterFiles;

      // Prepare data structure for update
      const updateData: Prisma.RegisterServicesUpdateArgs['data'] = {
        serviceId: serviceId, // Update serviceId
      };

      // Helper array to track files uploaded and their corresponding old URLs
      const filesToUpload: { name: keyof typeof existingService, file: Express.Multer.File, oldUrl: string }[] = [];

      // Define which fields hold file URLs
      const fileFields: (keyof Pick<typeof existingService, 'aadhaarCard' | 'panCard' | 'gstCertificate' | 'photo'>)[] =
        ['aadhaarCard', 'panCard', 'gstCertificate', 'photo'];

      // Check for new files and prepare for upload
      for (const field of fileFields) {
        const fileArray = files[field] as Express.Multer.File[];
        if (fileArray && fileArray.length > 0) {
          filesToUpload.push({
            name: field,
            file: fileArray[0],
            // Get the current (old) URL from the existing service record
            oldUrl: existingService[field] as string,
          });
        }
      }

      // Upload new files to Cloudinary
      const uploadPromises = filesToUpload.map(item =>
        uploadToCloudinary(
          item.file.path,
          item.name === 'photo' || item.file.mimetype.startsWith('image/') ? "image" : "raw",
          req,
          item.file
        )
      );

      const uploadResults = await Promise.all(uploadPromises);

      // Update updateData with new Cloudinary URLs and prepare old URLs for deletion
      const oldUrlsToDelete: string[] = [];

      uploadResults.forEach((upload, index) => {
        const field = filesToUpload[index].name;
        // Set new URL in the update payload
        updateData[field] = upload.secure_url;
        // Collect the old URL for cleanup
        oldUrlsToDelete.push(filesToUpload[index].oldUrl);
      });

      // 4. Perform the database update
      const updatedService = await prisma.registerServices.update({
        where: { id: serviceIdToUpdate },
        data: updateData, // This now contains new Cloudinary URLs for uploaded files
      });

      // 5. Delete the old files from Cloudinary only if the DB update succeeded
      if (oldUrlsToDelete.length > 0) {
        console.log(`Cleaning up ${oldUrlsToDelete.length} old Cloudinary files.`);
        await deleteImageByUrl(oldUrlsToDelete);
      }

      return res.status(200).json({
        success: true,
        data: updatedService,
        message: "Service updated successfully and old files cleaned up.",
      });
    } catch (error) {
      console.error("Service update error:", error);

      if (error instanceof ZodError) {
        return res.status(400).json({
          success: false,
          message: "Validation Error",
          errors: error.errors,
        });
      }

      // Handle Cloudinary upload errors
      if (error instanceof Error && error.message.includes("Cloudinary")) {
        return res.status(500).json({
          success: false,
          message: "File upload failed",
          error: error.message,
        });
      }

      // Handle Prisma P2025 (Record to update does not exist)
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2025') {
        return res.status(404).json({
          success: false,
          message: "Service not found for update",
        });
      }

      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }
}