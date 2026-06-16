import { Request, Response } from "express";
import { prisma } from "..";
import { PHONE_NUMBER_RGX, generateOTP, validateEmail, validatePhone} from "../lib/util";
import bcrypt from "bcrypt";
import EmailService from "../services/email.service";
import TokenService from "../services/token.service";
import AuthService, { REFRESH_COOKIE } from "../services/auth.service";
import { UserGender, UserType, Prisma } from "@prisma/client";
import { ZodError, z } from "zod";
import { uploadToCloudinary } from "../config/cloudinaryUploader";
import MobileService from "../services/mobile.service";

// Note: Request is globally augmented in `src/types/express/index.d.ts` to include `user?: UserData`.
// Use `Request` (from express) directly for handlers that access `req.user`.

const UserSchema = z.object({
  firstName: z
    .string({ required_error: "First name is required" })
    .min(1, "First name must be atleast 1 character long"),
  lastName: z.string().optional(),
  middleName: z.string().optional(),
  gender: z.nativeEnum(UserGender),
  email: z.string().toLowerCase().email(),
  password: z.string().min(6, "Password must be atleast 6 characters long"),
  phone: z
    .string()
    .regex(PHONE_NUMBER_RGX, "Enter a valid 10 digit phone number"),
  fatherName: z.string().optional(),
  pin: z.string().optional(),
  address: z.string().optional(),
  aadhaar: z.string().optional(),
  pan: z.string().optional(),
  type: z.nativeEnum(UserType).optional(),
});

type UserSchemaType = z.infer<typeof UserSchema>;

const LoginSchema = z.object({
  email: z.string().toLowerCase().email(),
  password: z.string({ required_error: "Please enter your password" }),
});

type LoginSchemaType = z.infer<typeof LoginSchema>;

const UserTypeSchema = z.object({
  email: z.string().toLowerCase().email(),
  type: z.enum(["admin", "normal", "superadmin"]),
});

export default class UserController {
  static SALT_ROUNDS = 10;

  static USERS_PER_PAGE = 10;

  static async hashPassword(password: string) {
    const salt = await bcrypt.genSalt(UserController.SALT_ROUNDS);
    const hash = await bcrypt.hash(password, salt);

    return hash;
  }

  /**
   * Utility function to generate, save, and send OTP via email and mobile.
   * The mobile_number is kept as a string to match the UserSchema/database type.
   * @param email - User email address
   * @param userId - User ID
   * @param mobile_number - User phone number (string)
   * @returns The ID (key) of the created OTP record.
   */
  static async sendOtp(email: string, userId: number, mobile_number?: string | null) {
    const otp = generateOTP();

    // Calculate expiry date (5 minutes from now)
    const deletedate = new Date(Date.now() + 5 * 60 * 1000);

    // Save OTP and expiry date to the database
    const { id: otp_key } = await prisma.otp.create({
      data: {
        otp,
        userId,
        deletedate: deletedate,
      },
    });

    // Prepare email content
    const email_subject = "OTP: For Email Verification";
    const email_message =
      `Dear User,\n\n` +
      `Your OTP for email verification is: ${otp}\n\n` +
      `This OTP will expire in 5 minutes.\n\n` +
      `If you did not request this, please ignore this email.\n\n` +
      `Regards,\nItaxeasy\n`;

    // Send email/SMS in the background so the HTTP response isn't blocked
    // on slow SMTP/SMS providers (the app times out after a few seconds).
    EmailService.sendMail(email, email_subject, email_message).catch((err) =>
      console.error("Failed to send OTP email:", err)
    );
    // MobileService expects a number — only send if mobile_number is present
    if (mobile_number) {
      MobileService.sendotp(Number(mobile_number), otp).catch((err) =>
        console.error("Failed to send OTP SMS:", err)
      );
    }

    // Return OTP key
    return otp_key;
  }

  static async resendOtpWithKey(req: Request, res: Response) {
    try {
      const { email, otp_key } = req.body;

      const user = await prisma.user.findFirst({ where: { email } });

      if (!user) {
        return res.status(404).send({
          success: false,
          message: "User not found",
        });
      }

      // Before sending a new one, delete all prior OTPs for this user to invalidate old codes
      await prisma.otp.deleteMany({ where: { userId: user.id } });

      const newOtpKey = await UserController.sendOtp(email, user.id, user.phone);

      return res.status(200).send({
        success: true,
        message: "OTP sent successfully to your email and phone. It expires in 5 minutes.",
        data: { otp_key: newOtpKey },
      });
    } catch (err) {
      console.error("resendOtpWithKey error:", err);
      return res.status(500).send({ success: false, message: "Something went wrong." });
    }
  }

  static async verifyOtpWithKey(req: Request, res: Response) {
    try {
      const { otp_key, otp, email } = req.body;

      // Find OTP by key, ensure it's not expired, not used, and belongs to the specified email's user
      const isOtp = await prisma.otp.findFirst({
        where: {
          id: otp_key,
          otp,
          used: false,
          deletedate: { gte: new Date() } // Check expiry
        },
        include: { user: { select: { id: true, email: true } } }
      });

      if (!isOtp || !isOtp.user || isOtp.user.email !== email) {
        return res.status(400).send({ success: false, message: "Invalid, expired, or used OTP." });
      }

      // Mark user verified
      await prisma.user.update({
        where: { id: isOtp.userId },
        data: { verified: true },
      });

      // Delete the used OTP immediately to prevent reuse and cleanup
      await prisma.otp.delete({ where: { id: isOtp.id } });

      return res.status(200).send({
        success: true,
        message: "User verified successfully.",
      });
    } catch (err) {
      console.error("verifyOtpWithKey error:", err);
      return res.status(500).send({ success: false, message: "Server error." });
    }
  }

  static async updatePasswordWithOtp(req: Request, res: Response) {
    try {
      const { email, otp_key, otp, newPassword } = req.body;

      // Find the user and the OTP record, checking that the OTP is valid (not expired, not used)
      const otpRecord = await prisma.otp.findFirst({
        where: {
          id: otp_key,
          otp,
          used: false,
          deletedate: { gte: new Date() } // Check expiry
        },
        include: { user: { select: { id: true, email: true, password: true } } }
      });

      if (!otpRecord || otpRecord.user.email !== email) {
        return res.status(400).send({ success: false, message: "Invalid, expired, or used OTP/Email combination." });
      }

      const hashedPwd = await UserController.hashPassword(newPassword);

      // 1. Update the user's password
      await prisma.user.update({
        where: { id: otpRecord.userId },
        data: { password: hashedPwd },
      });

      // 2. Mark the OTP as used (important security step)
      await prisma.otp.update({
        where: { id: otpRecord.id },
        data: { used: true },
      });

      return res.status(200).send({
        success: true,
        message: "Password updated successfully.",
      });
    } catch (err) {
      console.error("updatePasswordWithOtp error:", err);
      return res.status(500).send({ success: false, message: "Server error." });
    }
  }

  static async signUp(req: Request, res: Response) {
    try {
      const {
        firstName,
        middleName,
        lastName,
         gender,
        
        fatherName,
        aadhaar,
        pan,
        pin,
        email,
        password,
        phone,
      }: UserSchemaType = UserSchema.parse(req.body);

      // Hash password
      const hashedPassword = await UserController.hashPassword(password);

      // In non-production, auto-verify the account and skip OTP email entirely.
      // Production (NODE_ENV=production) always sends an OTP and stays unverified
      // until the user verifies. (Single source of truth: NODE_ENV.)
      const isDev = process.env.NODE_ENV !== "production";

      // Upsert user with unverified status
      const user = await prisma.user.upsert({
        where: { email },
        update: {
          firstName,
          middleName,
          lastName,
          gender,
          fatherName,
          aadhaar,
          pan,
          pin,
          phone,
          password: hashedPassword,
          verified: isDev, // dev: auto-verified; prod: stay unverified until OTP
        },
        create: {
          firstName,
          middleName,
          lastName,
          gender,
          fatherName,
          aadhaar,
          pan,
          pin,
          email,
          phone,
          password: hashedPassword,
          verified: isDev, // dev: auto-verified; prod: stay unverified until OTP
        },
      });

      // Dev mode: no OTP mail, account already verified — let the client log in directly.
      if (isDev) {
        return res.status(200).send({
          success: true,
          message: "Account created and verified (dev mode). You can log in now.",
          data: { verified: true, otp_key: null },
        });
      }

      // Generate and send OTP (passing phone as string)
      const otp_key = await UserController.sendOtp(email, user.id, user.phone);

      return res.status(200).send({
        success: true,
        message:
          `An OTP has been sent to your email "${email}". ` +
          `Please verify your account using the OTP.`,
        data: { otp_key, verified: false },
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
  }

  static async verifyOtp(req: Request, res: Response) {
    try {
      const { email, otp } = req.body;

      // Find the user by email
      const user = await prisma.user.findUnique({
        where: { email },
      });

      if (!user) {
        return res.status(404).send({
          success: false,
          message: "User not found.",
        });
      }

      if (user.verified) {
        return res.status(400).send({
          success: false,
          message: "User is already verified.",
        });
      }

      // Validate the OTP
      const otpRecord = await prisma.otp.findFirst({
        where: {
          userId: user.id,
          otp,
          deletedate: { gte: new Date() }, // Ensure OTP is not expired
        },
      });

      if (!otpRecord) {
        return res.status(400).send({
          success: false,
          message: "Invalid or expired OTP.",
        });
      }

      // Mark the user as verified
      await prisma.user.update({
        where: { id: user.id },
        data: { verified: true },
      });

      // Delete the OTP record (optional, but good for cleanup/preventing reuse)
      await prisma.otp.delete({ where: { id: otpRecord.id } });

      return res.status(200).send({
        success: true,
        message: "Account successfully verified. Your account is now active.",
      });
    } catch (e) {
      console.error(e);
      return res
        .status(500)
        .send({ success: false, message: "Something went wrong" });
    }
  }

  static async resendotp(req: Request, res: Response) {
    const email = req.body.email;
    console.log(email)
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      return res.status(401).send({
        success: false,
        message: "User with this email does not exists",
      });
    }

    // Delete any old OTPs for this user before sending a new one
    await prisma.otp.deleteMany({ where: { userId: user.id } });

    const otp_key = await UserController.sendOtp(email, user.id, user.phone);
    console.log(otp_key)

    res.status(200).send({
      success: true,
      message: "succesfully otp send to email",
      otp_key: otp_key,
    });
  }

  static async login(req: Request, res: Response) {
    try {
      const { email, password }: LoginSchemaType = LoginSchema.parse(req.body);

      // Find user by email
      const user = await prisma.user.findUnique({
        where: { email },
      });

      // Check user not exists
      if (!user) {
        return res.status(404).json({
          success: false,
          message: "User with this email does not exist",
        });
      }

      // Verify the password FIRST — only act on the account once credentials
      // are proven correct (so we never send an OTP for a wrong password).
      const authorized = await bcrypt.compare(password, user.password);
      if (!authorized) {
        return res.status(401).json({
          success: false,
          message: "Invalid credentials",
        });
      }

      // Unverified account with valid credentials → send a fresh OTP and ask
      // the client to verify, instead of a dead-end 403. The client should show
      // the OTP screen (data.otp_key), call /verify-otp, then log in again.
      if (!user.verified) {
        await prisma.otp.deleteMany({ where: { userId: user.id } });
        const otp_key = await UserController.sendOtp(email, user.id, user.phone);
        return res.status(403).json({
          success: false,
          needsVerification: true,
          message:
            "Your account is not verified. We've sent a new OTP to your email — please verify to continue.",
          data: { otp_key, email, verified: false },
        });
      }

      // Generate token with user data and role flags (isAdmin, isSuperadmin)
      const token = TokenService.generateAccessToken(user);

      // Long-lived, DB-backed refresh token stored in an httpOnly cookie.
      const refreshToken = await AuthService.issueRefreshToken(user.id);
      AuthService.setRefreshCookie(res, refreshToken);
      // Short-lived httpOnly access cookie for SSR/server routes.
      AuthService.setAccessCookie(res, token);
      // Exclude sensitive data (e.g., password) from the user object sent in the body
      const { password: _, ...userWithoutPassword } = user;

      return res.status(200).json({
        success: true,
        message: "Login successful",
        data: {
          user: userWithoutPassword,
          token // Sending token in body for API clients
        },
      });
    } catch (error) {
      console.error("Login error:", error);
      if (error instanceof Prisma.PrismaClientInitializationError) {
        return res.status(503).json({
          success: false,
          message: "Database unavailable",
        });
      }
      if (error instanceof ZodError) {
        return res.status(400).json({
          success: false,
          message: "Invalid input",
          errors: error.issues,
        });
      }
      return res.status(500).json({
        success: false,
        message: "Internal server error",
      });
    }
  }

  // Exchange a valid refresh-token cookie for a new access token.
  // Rotates the refresh token and detects reuse of an already-rotated token.
  static async refresh(req: Request, res: Response) {
    try {
      const rawToken = req.cookies?.[REFRESH_COOKIE];
      if (!rawToken) {
        return res
          .status(401)
          .json({ success: false, message: "No refresh token" });
      }

      const payload = TokenService.verifyRefreshToken(rawToken);
      if (!payload) {
        AuthService.clearRefreshCookie(res);
        return res
          .status(401)
          .json({ success: false, message: "Invalid refresh token" });
      }

      const stored = await prisma.refreshToken.findUnique({
        where: { id: payload.jti },
      });

      // Token unknown, expired, or already used → treat as invalid.
      if (!stored || stored.expiresAt < new Date()) {
        AuthService.clearRefreshCookie(res);
        return res
          .status(401)
          .json({ success: false, message: "Refresh token expired" });
      }

      // Reuse of a revoked (already-rotated) token → likely theft. Kill all sessions.
      if (stored.revoked) {
        await AuthService.revokeAllForUser(payload.id);
        AuthService.clearRefreshCookie(res);
        return res.status(401).json({
          success: false,
          message: "Refresh token reuse detected. Please log in again.",
        });
      }

      const user = await prisma.user.findUnique({ where: { id: payload.id } });
      if (!user) {
        AuthService.clearRefreshCookie(res);
        return res
          .status(401)
          .json({ success: false, message: "User not found" });
      }

      // Rotate the refresh token and issue a new access token.
      const newRefresh = await AuthService.rotateRefreshToken(
        payload.jti,
        user.id
      );
      AuthService.setRefreshCookie(res, newRefresh);

      const accessToken = TokenService.generateAccessToken(user);
      AuthService.setAccessCookie(res, accessToken);
      const { password: _pw, ...userWithoutPassword } = user;

      return res.status(200).json({
        success: true,
        data: { token: accessToken, user: userWithoutPassword },
      });
    } catch (error) {
      console.error("Refresh error:", error);
      return res
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  }

  // Revoke the current refresh token and clear the cookie.
  static async logout(req: Request, res: Response) {
    try {
      const rawToken = req.cookies?.[REFRESH_COOKIE];
      if (rawToken) {
        const payload = TokenService.verifyRefreshToken(rawToken);
        if (payload?.jti) {
          await AuthService.revokeToken(payload.jti);
        }
      }
      AuthService.clearRefreshCookie(res);
      AuthService.clearAccessCookie(res);
      return res.status(200).json({ success: true, message: "Logged out" });
    } catch (error) {
      console.error("Logout error:", error);
      AuthService.clearRefreshCookie(res);
      AuthService.clearAccessCookie(res);
      return res
        .status(200)
        .json({ success: true, message: "Logged out" });
    }
  }


  static async changeusertype(req: Request, res: Response) {
    try {
      const { email, type } = UserTypeSchema.parse(req.body);

      const user = await prisma.user.findUnique({
        where: { email },
      });

      if (!user) {
        return res.status(401).send({
          success: false,
          message: "User with this email does not exists",
        });
      }

      if (user.verified === false) {
        return res
          .status(301)
          .send({ success: false, message: "User is Not Verified" });
      }

      // The redundant/flawed check regarding userType change permissions has been removed.
      // Permissions should be enforced by middleware checking the role of the *requesting* user.

      const changeuser = await prisma.user.update({
        where: { email },
        data: {
          userType: type,
        },
      });

      return res.status(200).send({
        success: true,
        message: "user status updated succesfully",
        data: {
          changeuser,
        },
      });
    } catch (e) {
      console.error(e);
      return res
        .status(500)
        .send({ success: false, message: "Something went wrong" });
    }
  }

  static async makeadmin(req: Request, res: Response) {
    try {
      const {
        aadhaar,
        email,
        fatherName,
        firstName,
        middleName,
        address,
        gender,
        lastName,
        pan,
        password,
        phone,
        pin,
      }: UserSchemaType = UserSchema.parse(req.body);

      const { id } = req.user!; // Uses global Request augmentation (UserData)
      console.log(id);
      const found = await prisma.user.findFirst({
        where: {
          OR: [{ email }, { phone }],
        },
      });

      if (found) {
        return res.status(409).send({
          success: false,
          message:
            "User with this email address or phone number already exists.",
        });
      }

      const hash = await UserController.hashPassword(password);

      const user = await prisma.user.create({
        data: {
          firstName,
          lastName,
          email,
          gender,
          password: hash,
          phone,
          fatherName,
          middleName,
          address,
          aadhaar,
          pan,
          pin,
          verified: false,
          userType: "admin",
          superadminId: id,
        },
      });

      const otp_key = await UserController.sendOtp(email, user.id, user.phone);

      return res.status(200).send({
        success: true,
        message: `An OTP has been sent to your email.` + `Verify your account.`,
        data: {
          user: {
            id: user.id,
            firstName,
            lastName,
            email,
            phone,
          },
          otp_key,
        },
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
  }

  static async updateadmin(req: Request, res: Response) {
    try {
      const {
        aadhaar,
        pan,
        email,
        phone,
        fatherName,
        firstName,
        middleName,
        lastName,
        gender,
        password,
      } = UserSchema.extend({ password: z.string().optional() }).parse(
        req.body
      );

      const { id: superadminId } = req.user!; // Uses global Request augmentation (UserData)
      const { id } = req.params;

      const found = await prisma.user.findFirst({
        where: {
          // Note: This check uses OR, meaning it finds a user if EITHER email OR phone matches.
          // If the goal is to update the user identified by req.params.id, this block might be complex.
          // Assuming here the user ID from params is the primary identifier.
          id: parseInt(id, 10),
        },
      });

      if (!found) {
        return res.status(404).send({
          success: false,
          message: "User not found.",
        });
      }

      let newPassword = found.password; // Default to existing hash

      if (password && typeof password === 'string') {
        // Only hash and update if a password was provided AND it's different
        const isSamePassword = await bcrypt.compare(password, found.password);

        if (!isSamePassword) {
          console.log("Password is being updated");
          newPassword = await UserController.hashPassword(password);
        } else {
          console.log("Password is the same, no re-hash needed.");
        }
      }

      const user = await prisma.user.update({
        where: {
          id: parseInt(id, 10),
        },
        data: {
          firstName,
          lastName,
          gender,
          password: newPassword, // Use the new hash or the existing one
          fatherName,
          middleName,
          aadhaar,
          pan,
          userType: "admin",
          superadminId,
          // Note: Email and Phone are not updated here. If they need to be updated,
          // they should be included in data and validated for uniqueness across all other users.
        },
      });

      return res.status(200).send({
        success: true,
        message: `User is updated`,
        data: {
          user: {
            id: user.id,
            firstName,
            lastName,
            email: user.email, // Use email from DB after update
            phone: user.phone, // Use phone from DB after update
          },
        },
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
  }

  static async makeagent(req: Request, res: Response) {
    try {
      const { id } = req.user!; // Uses global Request augmentation (UserData)
      const {
        firstName,
        lastName,
        gender,
        fatherName,
        aadhaar,
        pan,
        pin,
        email,
        password,
        phone,
      }: UserSchemaType = UserSchema.parse(req.body);

      const found = await prisma.user.findFirst({
        where: {
          OR: [{ email }, { phone }],
        },
      });

      if (found) {
        return res.status(409).send({
          success: false,
          message:
            "agent with this email address or phone number already exists.",
        });
      }

      const hash = await UserController.hashPassword(password);

      const user = await prisma.user.create({
        data: {
          firstName,
          lastName,
          email,
          gender,
          password: hash,
          phone,
          fatherName,
          aadhaar,
          pan,
          pin,
          verified: false,
          userType: "agent",
          adminId: id,
        },
      });

      const otp_key = await UserController.sendOtp(email, user.id, user.phone);

      return res.status(200).send({
        success: true,
        message:
          `An OTP has been sent to your email "${email}".` +
          `Verify your account by using that OTP`,
        data: {
          user: {
            id: user.id,
            firstName,
            lastName,
            email,
            phone,
          },
          otp_key,
        },
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
  }

  static async gettoken(req: Request, res: Response) {
    const email = req.body.email;
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      return res.status(401).send({
        success: false,
        message: "User with this email does not exists",
      });
    }
    const token = TokenService.generateToken(user);

    res.status(200).send({ success: true, token: token, userId: user.id });
  }

  static async forgotPassword(req: Request, res: Response) {
    try {
      const { email } = req.body;

      if (!email || !validateEmail(email)) {
        return res
          .status(400)
          .send({ success: false, message: "A valid email is required" });
      }

      const user = await prisma.user.findUnique({
        where: { email },
      });

      if (!user) {
        return res.status(401).send({
          success: false,
          message: "User with this email does not exists",
        });
      }

      // Delete any old OTPs for this user before sending a new one
      await prisma.otp.deleteMany({ where: { userId: user.id } });

      const otp_key = await UserController.sendOtp(email, user.id, user.phone);

      return res.status(200).send({
        success: true,
        message:
          `An OTP has been sent to your email "${email}".` +
          `Verify your account by using that OTP`,
        otp_key,
      });
    } catch (e) {
      console.error(e);
      return res
        .status(500)
        .send({ success: false, message: "Something went wrong" });
    }
  }


  static async sendVerificationOtp(req: Request, res: Response) {
    try {
      const token = TokenService.getTokenFromAuthHeader(
        req
      );

      if (!token) {
        return res
          .status(403)
          .send({ success: false, message: "Authorization Token is required" });
      }

      const { id, email } = TokenService.decodeToken(token);
      const user = await prisma.user.findFirst({
        where: { id },
      });

      if (!user) {
        return res
          .status(404)
          .send({ success: false, message: "User not found" });
      }

      // Delete any old OTPs for this user before sending a new one
      await prisma.otp.deleteMany({ where: { userId: user.id } });

      const otp_key = await UserController.sendOtp(email, id, user.phone);

      return res.status(200).send({
        success: true,
        message:
          `An OTP has been sent to your email "${email}".` +
          `Verify your account by using that OTP`,
        otp_key,
      });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .send({ success: false, message: "Something went wrong" });
    }
  }

  static async changePassword(req: Request, res: Response) {
    try {
      const { id } = req.user!; // Uses global Request augmentation (UserData)

      const { newPassword } = req.body;

      if (!newPassword || newPassword.length < 8) {
        return res.status(400).send({
          success: false,
          message: "Please provide a new password of atleast 8 characters",
        });
      }

      const user = await prisma.user.findUnique({
        where: { id },
      });

      if (!user) {
        return res
          .status(401)
          .send({ success: false, message: "User does not exists" });
      }

      const hash = await UserController.hashPassword(newPassword);

      await prisma.user.update({
        where: { id },
        data: {
          password: hash,
        },
      });

      return res
        .status(200)
        .send({ success: true, message: "Password changed" });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .send({ success: false, message: "Something went wrong" });
    }
  }

  // static async updateProfile(req: Request, res: Response) {
  //   try {
  //     const { id } = req.user!; // Uses global Request augmentation (UserData)

  //     const {
  //       firstName,
  //       middleName,
  //       lastName,
  //       fatherName,
  //       pin,
  //       gender,
  //       address,
  //       aadhaar,
  //       pan,
  //       phone,
  //       inventory,
  //       ispanlinked
  //     } = req.body;
  //     let avatar: string | null = null;

  //     if (req.file) {
  //       // Upload the avatar to Cloudinary and get the URL
  //       const localFilePath = req.file.path;
  //       const cloudinaryResult = await uploadToCloudinary(localFilePath, "image", req, req.file);
  //       avatar = cloudinaryResult.secure_url; 

  //     // Helper to correctly parse boolean values from form data/JSON
  //     const parseBoolean = (val: any) => {
  //       if (typeof val === 'boolean') return val;
  //       if (typeof val === 'string') return val.toLowerCase() === 'true';
  //       return val; // Pass through null/undefined/other types
  //     };

  //     if (!firstName || !firstName.length) {
  //       return res
  //         .status(400)
  //         .send({ success: false, message: "First name cannot be empty" });
  //     }

  //     if (phone && !validatePhone(phone)) {
  //       return res.status(400).send({
  //         success: false,
  //         message: "Please enter a valid phone number",
  //       });
  //     }

  //     const user = await prisma.user.findFirst({ where: { id } });

  //     if (!user) {
  //       return res
  //         .status(404)
  //         .send({ success: false, message: "User does not exist" });
  //     }

  //     // Construct update data, using nullish coalescing (??) to allow setting fields to null/empty string if explicitly provided as null/undefined
  //     const updateData: any = {
  //       firstName: firstName,
  //       middleName: middleName,
  //       lastName: lastName,
  //       gender: gender ?? user.gender,
  //       fatherName: fatherName,
  //       pin: pin,
  //       pan: pan,
  //       aadhaar: aadhaar,
  //       address: address,
  //       phone: phone ?? user.phone,
  //       avatar: avatar ?? user.avatar,
  //     };

  //     // Only set boolean fields if they are explicitly present in the request body
  //     if (typeof ispanlinked !== 'undefined') {
  //       updateData.ispanlinked = parseBoolean(ispanlinked);
  //     }
  //     if (typeof inventory !== 'undefined') {
  //       updateData.inventory = parseBoolean(inventory);
  //     }


  //     await prisma.user.update({
  //       where: { id: user.id },
  //       data: updateData,
  //     });

  //     return res
  //       .status(200)
  //       .send({ success: true, message: "Profile Updated" });
  //   }
  // }
  //    catch (e) {
  //     console.log(e);
  //     return res
  //       .status(500)
  //       .send({ success: false, message: "Something went wrong" });
  //   }
  // } 
  
static async updateProfile(req: Request, res: Response) {
  try {
    const { id } = req.user!;

    const {
      firstName,
      middleName,
      lastName,
      fatherName,
      pin,
      gender,
      address,
      aadhaar,
      pan,
      phone,
      inventory,
      ispanlinked,
    } = req.body;

    let avatar: string | null = null;

    // ✅ helper MUST be outside
    const parseBoolean = (val: any) => {
      if (typeof val === "boolean") return val;
      if (typeof val === "string") return val.toLowerCase() === "true";
      return val;
    };

    if (!firstName || !firstName.length) {
      return res
        .status(400)
        .send({ success: false, message: "First name cannot be empty" });
    }

    if (phone && !validatePhone(phone)) {
      return res.status(400).send({
        success: false,
        message: "Please enter a valid phone number",
      });
    }

    const user = await prisma.user.findFirst({ where: { id } });

    if (!user) {
      return res
        .status(404)
        .send({ success: false, message: "User does not exist" });
    }

    // ✅ handle avatar safely
    if (req.file) {
      const cloudinaryResult = await uploadToCloudinary(
        req.file.path,
        "image",
        req,
        req.file
      );
      avatar = cloudinaryResult.secure_url;
    }

    const updateData: any = {
      firstName,
      middleName,
      lastName,
      gender: gender ?? user.gender,
      fatherName,
      pin,
      pan,
      aadhaar,
      address,
      phone: phone ?? user.phone,
      avatar: avatar ?? user.avatar,
    };

    if (typeof ispanlinked !== "undefined") {
      updateData.ispanlinked = parseBoolean(ispanlinked);
    }

    if (typeof inventory !== "undefined") {
      updateData.inventory = parseBoolean(inventory);
    }

    await prisma.user.update({
      where: { id },
      data: updateData,
    });

    return res
      .status(200)
      .send({ success: true, message: "Profile Updated" });
  } catch (e) {
    console.error("updateProfile error:", e);
    return res
      .status(500)
      .send({ success: false, message: "Something went wrong" });
  }
}

  static async deleteUser(req: Request, res: Response) {
    try {
      const { id } = req.params;
      if (!id) {
        return res
          .status(400)
          .send({ success: false, message: "User id is required" });
      }

      const token = TokenService.getTokenFromAuthHeader(
        req
      );

      if (!token) {
        return res
          .status(403)
          .send({ success: false, message: "Authorization Token is required" });
      }

      const Superadmin = TokenService.decodeToken(token);

      const foundUser = await prisma.user.findFirst({
        where: {
          id: parseInt(id, 10),
        },
      });

      if (!foundUser) {
        return res
          .status(404)
          .send({ success: false, message: "User not found" });
      }

      // Delete query is highly restrictive, requiring the requesting user (Superadmin.id)
      // to be the one who created the target user (superadminId).
      await prisma.user.delete({
        where: {
          id: parseInt(id, 10),
          superadminId: Superadmin.id,
        },
      });

      return res
        .status(200)
        .send({ success: true, message: "User deleted successfully" });
    } catch (e) {
      console.log(e);
      return res
        .status(500)
        .send({ success: false, message: "Something went wrong" });
    }
  }

  static async getProfile(req: Request, res: Response): Promise<void> {
    try {
      // Get token from header or cookies
      const token = TokenService.getTokenFromAuthHeader(req);

      if (!token) {
        res.status(401).send("Token is missing");
        return;
      }

      // Decode the token (ensure `decodeToken` handles errors appropriately)
      const { id, email } = TokenService.decodeToken(token);

      if (!id || !email) {
        res.status(401).send("Invalid token payload");
        return;
      }

      // Fetch the user from the database and EXCLUDE THE PASSWORD HASH
      const user = await prisma.user.findFirst({
        where: { id },
        select: {
          id: true,
          email: true,
          firstName: true,
          lastName: true,
          middleName: true,
          gender: true,
          phone: true,
          address: true,
          pin: true,
          aadhaar: true,
          pan: true,
          userType: true,
          verified: true,
          createdAt: true,
          avatar: true,
          ispanlinked: true,
          inventory: true,
          fatherName: true,
          // Explicitly omit: password, superadminId, adminId (sensitive/internal)
        }
      });

      if (!user) {
        res.status(403).send("ID is not valid");
        return;
      }

      // Send the user profile as response
      res.status(200).json(user);
    } catch (error) {
      console.error("Error in getProfile:", error);
      res.status(500).send("An unexpected error occurred");
    }
  }

  static async getUserById(req: Request, res: Response) {
    try {
      const { id } = req.params;

      const user = await prisma.user.findFirst({
        select: {
          id: true,
          createdAt: true,
          email: true,
          firstName: true,
          lastName: true,
          aadhaar: true,
          address: true,
          phone: true,
          pan: true,
          userType: true,
          pin: true,
          ispanlinked: true,
          inventory: true,
        },
        where: {
          id: {
            equals: parseInt(id, 10), // Added radix 10
          },
        },
      });

      if (!user) {
        return res
          .status(404)
          .send({ success: false, message: "User not found" });
      }

      return res.status(200).send({ success: true, data: { user } });
    } catch (e) {
      console.error(e);
      return res
        .status(500)
        .send({ success: false, message: "Something went wrong" });
    }
  }

  static async getAllUsers(req: Request, res: Response) {
    try {
      const { page: pageNumber, order = "desc" } = req.query;

      const page = parseInt((pageNumber as string) || "0", 10);

      const users = await prisma.user.findMany({
        select: {
          id: true,
          firstName: true,
          lastName: true,
          email: true,
          phone: true,
          aadhaar: true,
          address: true,
          pan: true,
          createdAt: true,
          userType: true,
          pin: true,
          ispanlinked: true,
        },
        orderBy: {
          createdAt: order === "asc" ? "asc" : "desc",
        },
        skip: page * UserController.USERS_PER_PAGE,
        take: UserController.USERS_PER_PAGE,
      });

      const totalusers = await prisma.user.count(); // Use count() for total count efficiently

      if (!users) {
        return res.status(404).send({ success: false, message: "No users found." });
      }

      const totalPages = Math.ceil(
        totalusers / UserController.USERS_PER_PAGE
      );

      return res.status(200).send({
        success: true,
        message: "Users fetched successfully",
        data: {
          users,
          totalusers,
          currentPage: page,
          totalPages,
        },
      });
    } catch (e) {
      console.error(e);
      return res
        .status(500)
        .send({ success: false, message: "Something went wrong" });
    }
  }
}