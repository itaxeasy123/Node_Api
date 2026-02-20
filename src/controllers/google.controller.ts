import { PrismaClient } from "@prisma/client";
import { google } from "googleapis";
import { config } from "dotenv";
import { Request, Response } from "express";
import { oauth2Client } from "../config/google.config";
import TokenService from "../services/token.service";
import { ZodError } from "zod";
import crypto from "crypto";
import bcrypt from "bcrypt";

config();

const prisma = new PrismaClient();

export const googleController = {
  async getUserIdentity({ access_token }: { access_token: string }) {
    if (!access_token) {
      throw new Error("Access token not provided for fetching user profile");
    }

    oauth2Client.setCredentials({ access_token });

    const oauth2 = google.oauth2({
      auth: oauth2Client,
      version: "v2",
    });

    const { data } = await oauth2.userinfo.get();
    return data;
  },

  async signupWithGoogle(req: Request, res: Response) {
    try {
      const { access_token } = req.body;
  
      if (!access_token) {
        return res.status(400).json({ success: false, message: "Access token is required" });
      }
  
      // Fetch user identity using the provided access token
      const userInfo = await this.getUserIdentity({ access_token });
  
      // Split the full name into firstName and lastName
      const [firstName = "", ...rest] = (userInfo.name || "").split(" ");
      const lastName = rest.join(" "); // Join the remaining parts as the lastName
  
      // Check if the user exists in the database
      let user = await prisma.user.findUnique({
        where: { email: userInfo.email as string },
      });
  
      if (!user) {
        const hashedPassword = await bcrypt.hash(crypto.randomBytes(16).toString("hex"), 10);
        // Create a new user if one does not exist
        user = await prisma.user.create({
          data: {
            email: userInfo.email || "",
            firstName: firstName || "",
            lastName: lastName || "",
            avatar: userInfo.picture || "",
            verified: true, // Google users are considered verified
            password: hashedPassword, // Required field (You can hash it)
            gender: "male", // Set a default gender (or get it from user input)
          },
        });
      }
  
      return res.status(200).send({
        success: true,
        message:
          `An OTP has been sent to your email "${userInfo.email}". ` +
          `Please verify your account using the OTP.`,
        data: { otp_key: -1 }, // -1 since it's not needed for Google Auth
      });
    } catch (e) {
      console.error(e);
      if (e instanceof ZodError) {
        return res.status(400).send({ success: false, message: e.message });
      }
      return res
        .status(500)
        .send({ success: false, message: "Something went wrong" });
    }
  },

  async loginWithGoogle(req: Request, res: Response) {
    try {
      const { access_token } = req.body;
  
      if (!access_token) {
        return res.status(400).json({ success: false, message: "Access token is required" });
      }
  
      // Fetch user identity using the provided access token
      const userInfo = await this.getUserIdentity({ access_token });
  
      // Check if the user exists in the database
      const user = await prisma.user.findUnique({
        where: { email: userInfo.email as string },
      });
  
      if (!user) {
        return res.status(404).json({ success: false, message: "User not found" });
      }
  
      // Generate JWT token for the authenticated user
      const token = TokenService.generateToken(user);
  
      // Respond with user data and the generated token
      return res.status(200).json({
        success: true,
        message: "Login successful",
        data: {
          user,
          token,
        },
      });
    } catch (error) {
      console.error("Login error:", error);
      return res.status(500).json({
        success: false,
        message: "Internal server error",
      });
    }
  },

  async getUserProfile(req: Request, res: Response) {
    try {
      const { access_token } = req.body;

      if (!access_token) {
        return res.status(400).json({ success: false, message: "Access token is required" });
      }

      const userInfo = await this.getUserIdentity({ access_token });
      return res.status(200).json({ success: true, data: userInfo });
    } catch (error: any) {
      console.error("Error fetching user profile:", error.message);
      return res
        .status(500)
        .json({ success: false, message: "Something went wrong", error: error.message });
    }
  },
};

// Graceful Prisma client shutdown
process.on("SIGINT", async () => {
  await prisma.$disconnect();
  process.exit(0);
});
