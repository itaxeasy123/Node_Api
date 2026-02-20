import { Request, Response } from "express";
// Import the necessary types from @prisma/client
import { prisma } from "../index";
import { RegisterStartup } from "@prisma/client";
import { ZodError, z } from "zod";
import { deleteImageByUrl } from "../config/cloudinaryUploader";

// Interface to properly type the user object expected on the Request object
// This is typically added by authentication middleware.
// Update User interface to match UserData properties
// Request is globally augmented (see `src/types/express/index.d.ts`) with `user?: UserData`.
// Use `Request` directly for handlers that access `req.user`.

const categoriesType = z.enum([
  "registration",
  "companyRegistration",
  "returns",
  "audits",
]);

const startupCreateSchema = z.object({
  title: z.string(),
  categories: categoriesType,
  image: z.string().optional(),
  priceWithGst: z.string().min(1, "priceWithGst is required"),
  aboutService: z.string().min(1, "aboutService is required"),
});

export class RegisterStartupController {
  // Refactored to use prisma.registerStartup.create() for safer, cleaner insertion
  static async RegisterStartup(req: Request, res: Response) {
    // Determine the path of the uploaded image
    const imageUrl: string | undefined = req.file?.path;

    try {
      // 1. Validate request body
      const { title, categories, aboutService, priceWithGst } =
        startupCreateSchema.parse(req.body);

      if (!imageUrl) {
        return res.status(400).json({ error: "Image is required" });
      }

      // 2. Extract userId from the request (added by middleware)
      const userId = req.user?.id;

      if (!userId) {
        // This usually means the user is not authenticated
        if (imageUrl) await deleteImageByUrl([imageUrl]);
        return res.status(401).json({ error: "Unauthorized: User ID is missing" });
      }

      // 3. Check if user exists (Optional, Prisma handles foreign key constraints)
      const existingUser = await prisma.user.findUnique({
        where: { id: userId },
      });

      if (!existingUser) {
        // If user not found, delete the uploaded image
        if (imageUrl) await deleteImageByUrl([imageUrl]);
        return res.status(404).json({ error: "User not found" });
      }

      // 4. Create the record using Prisma's create method
      // This is much safer than manual MAX(id) and raw INSERT query,
      // as it uses the database's auto-increment feature and is atomic.
      const createdRecord = await prisma.registerStartup.create({
        data: {
          title,
          categories,
          image: imageUrl,
          userId: userId,
          aboutService,
          // Convert string price to integer for database storage
          priceWithGst: parseInt(priceWithGst, 10),
        },
      });

      return res.status(201).json({
        result: createdRecord,
        message: "Successfully Register Startup Setting created",
      });
    } catch (error) {
      console.error("RegisterStartup Error:", error);

      // Clean up uploaded image on failure
      if (imageUrl) {
        try {
          await deleteImageByUrl([imageUrl]);
        } catch (cleanupError) {
          console.error("Cleanup (deleteImageByUrl) failed:", cleanupError);
        }
      }

      if (error instanceof ZodError) {
        return res.status(400).json({
          success: false,
          message: "Validation Error",
          errors: error.errors,
        });
      }

      return res.status(500).json({
        success: false,
        message: "Internal server error",
        errors: error instanceof Error ? error.message : "An unknown error occurred",
      });
    }
  }

  static async findAllStartup(req: Request, res: Response) {
    try {
      // Type is now correctly imported
      const AllStartup: RegisterStartup[] =
        await prisma.registerStartup.findMany({});
      return res.status(200).json({ success: true, AllStartup });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        errors: error,
      });
    }
  }

  static async getById(req: Request, res: Response) {
    try {
      const { id } = req.params;

      // Type is now correctly imported
      const Startup: RegisterStartup | null =
        await prisma.registerStartup.findUnique({
          where: { id: parseInt(id) },
        });

      if (!Startup) {
        return res
          .status(404)
          .json({ success: false, message: "Startup not found" });
      }

      return res.status(200).json(Startup);
    } catch (error) {
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  static async delete(req: Request, res: Response) {
    const { id } = req.params;
    const startupId = parseInt(id);

    try {
      if (isNaN(startupId)) {
        return res.status(400).json({ success: false, message: "Invalid startup ID" });
      }

      // 1. Find the record to get the image URL before deletion
      const startupToDelete = await prisma.registerStartup.findUnique({
        where: { id: startupId },
        select: { image: true }, // Select only the image field for efficiency
      });

      if (!startupToDelete) {
        return res.status(404).json({ success: false, message: "Startup not found" });
      }

      // 2. Delete the record
      const deletedStartup: RegisterStartup =
        await prisma.registerStartup.delete({
          where: { id: startupId },
        });

      // 3. Delete the associated image from cloud storage
      if (startupToDelete.image) {
        try {
          // We use the image from the initial find operation (startupToDelete)
          await deleteImageByUrl([startupToDelete.image]);
        } catch (cleanupError) {
          console.error(`Error deleting image for ID ${startupId}:`, cleanupError);
          // Log the error but continue, as the database operation succeeded.
        }
      }

      return res.status(200).json({
        success: true,
        deletedStartup,
        message: "Register Startup deleted successfully",
      });
    } catch (error) {
      console.error("RegisterStartup Delete Error:", error);
      // Handle the case where the record might not exist due to concurrent deletion
      interface PrismaError {
        code?: string;
      }
      if (
        typeof error === "object" &&
        error !== null &&
        "code" in error &&
        (error as PrismaError).code === 'P2025'
      ) { // Prisma code for record not found
        return res.status(404).json({ success: false, message: "Startup not found or already deleted" });
      }
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  static async update(req: Request, res: Response) {
    try {
      const { id } = req.body;
      const { title, categories, aboutService, priceWithGst } =
        startupCreateSchema.parse(req.body);

      const image: string | undefined = req.file?.path;
      const userId = req.user?.id;

      if (!userId) {
        if (image) await deleteImageByUrl([image]);
        return res.status(401).json({ error: "Unauthorized: User ID is missing" });
      }

      const existingUser = await prisma.user.findUnique({
        where: { id: userId },
      });

      if (!existingUser) {
        if (image) await deleteImageByUrl([image]);
        return res.status(404).json({ error: "User not found" });
      }

      // Ensure 'id' for update is present and valid
      const startupId = parseInt(id);
      if (isNaN(startupId)) {
        if (image) await deleteImageByUrl([image]);
        return res.status(400).json({ error: "Invalid startup ID provided for update." });
      }

      const existingStartup = await prisma.registerStartup.findUnique({
        where: { id: startupId },
        select: { image: true }, // Only need the image path for cleanup
      });

      if (!existingStartup) {
        if (image) await deleteImageByUrl([image]);
        return res.status(404).json({ error: "Startup record to update not found." });
      }

      // If a new image is uploaded, delete the old one
      if (existingStartup.image && image) {
        await deleteImageByUrl([existingStartup.image]);
      }

      // Type is now correctly imported
      const updatedStartup: RegisterStartup =
        await prisma.registerStartup.update({
          where: { id: startupId },
          data: {
            title,
            categories,
            userId,
            // Use the new image path if provided, otherwise retain the existing one
            image: image ?? existingStartup.image,
            aboutService,
            priceWithGst: parseInt(priceWithGst, 10),
          },
        });

      return res.status(200).json({
        success: true,
        updatedStartup,
        message: "Register Startup updated successfully",
      });
    } catch (error) {
      console.error("RegisterStartup Update Error:", error);

      // Clean up new image on update failure
      const image: string | undefined = req.file?.path;
      if (image) {
        try {
          await deleteImageByUrl([image]);
        } catch (cleanupError) {
          console.error("Cleanup (deleteImageByUrl) failed during update:", cleanupError);
        }
      }

      if (error instanceof ZodError) {
        return res.status(400).json({
          success: false,
          message: "Validation Error",
          errors: error.errors,
        });
      }

      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }
}