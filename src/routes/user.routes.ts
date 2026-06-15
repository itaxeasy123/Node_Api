import { Router } from "express";
import UserController from "../controllers/user.controller";
import verifyToken from "../middlewares/verify-token";
import adminCheck from "../middlewares/admin-check";
import SuperadminCheck from "../middlewares/super-admin";
// import { upload } from "../config/file-upload";
import { multerInstance } from "../config/cloudinaryUploader";
import { googleController } from "../controllers/google.controller";

const userRouter = Router();

// Token-based profile endpoint
userRouter.get("/profile", verifyToken, UserController.getProfile);

userRouter.get("/profile/:id", verifyToken, UserController.getUserById);

userRouter.get("/get-all-users", SuperadminCheck, UserController.getAllUsers);

userRouter.post("/sign-up", UserController.signUp);

userRouter.post("/sign-up-admin", SuperadminCheck, UserController.makeadmin);
userRouter.put(
  "/sign-up-admin/:id",
  SuperadminCheck,
  UserController.updateadmin
);

userRouter.post(
  "/sign-up-agent",
  verifyToken,
  adminCheck,
  UserController.makeagent
);

//userRouter.get("/get-all-users", SuperadminCheck, UserController.getAllUsers);

// The controller does not implement `getallagentsbyadmin`/`getalladminsforsuperadmin`.
// Reuse `getAllUsers` for now; refine endpoints if different filtering is required.
userRouter.get(
  "/get-all-agents",
  verifyToken,
  adminCheck,
  UserController.getAllUsers
);

userRouter.get(
  "/get-all-admins",
  SuperadminCheck,
  UserController.getAllUsers
);

userRouter.post("/login", UserController.login);

// Access/refresh token lifecycle
userRouter.post("/refresh", UserController.refresh);
userRouter.post("/logout", UserController.logout);

userRouter.get("/gettoken", UserController.gettoken);

userRouter.post("/changeusertype", verifyToken, UserController.changeusertype);

userRouter.get("/profile",verifyToken,UserController.getProfile)
userRouter.post("/forgot-password", UserController.forgotPassword);

userRouter.post("/verify", UserController.verifyOtp);

userRouter.post("/resendotp", UserController.resendotp);

userRouter.post("/send-otp", verifyToken, UserController.sendVerificationOtp);

userRouter.post("/change-password", verifyToken, UserController.changePassword);

// userRouter.post("/verify-otp",UserController.verifyotpbyphone);
userRouter.put(
  "/update",
  verifyToken,
  multerInstance.single("avatar"),
  UserController.updateProfile
);

userRouter.delete(
  "/delete-user/:id",
  SuperadminCheck,
  UserController.deleteUser
);
userRouter.get(
  "/isadmin",
  verifyToken,
  UserController.getProfile
)
userRouter.post("/googlesignup", googleController.signupWithGoogle);

// Route for logging in with Google
userRouter.post("/googlelogin", googleController.loginWithGoogle);

// Route for fetching user profile using access token
userRouter.post("/profile", googleController.getUserProfile);

userRouter.post("/resend-otp-key", UserController.resendOtpWithKey);

userRouter.post("/verify-otp-key", UserController.verifyOtpWithKey);

userRouter.post("/update-password-with-otp", UserController.updatePasswordWithOtp);

export default userRouter;
