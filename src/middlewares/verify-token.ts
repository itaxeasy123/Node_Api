// import { Request, Response, NextFunction } from "express";
// import TokenService from "../services/token.service";
// import { UserType } from "@prisma/client";

// // Extend Express Request type
// interface AuthRequest extends Request {
//   user?: any;
//   isAdmin?: boolean;
//   isSuperAdmin?: boolean;
// }

// export default function verifyToken(
//   req: AuthRequest,
//   res: Response,
//   next: NextFunction
// ) {
//   const token = req.headers.authorization?.startsWith("Bearer")
//     ? req.headers.authorization.split(" ")[1]
//     : null;

//   if (!token) {
//     return res.status(403).json({
//       success: false,
//       message: "Authorization Token is required",
//     });
//   }

//   const verified = TokenService.verifyToken(token);

//   if (!verified) {
//     return res.status(401).json({
//       success: false,
//       message: "Unauthorized: Access is denied due to invalid credentials",
//     });
//   }
  
  
//   const user = TokenService.decodeToken(token) as any;
  
//   // 🔥 HOTFIX: Map `Usertype` to `userType`
//   user.userType = user.Usertype;
  
  
//   req.user = user;

//   console.log("🚀 ~ verifyToken ~ user:", user);

//   req.isAdmin = user.userType === UserType.admin;
//   req.isSuperAdmin = user.userType === UserType.superadmin;
  
//   console.log("🚀 ~ verifyToken ~ req.isAdmin:", req.isAdmin);
//   console.log("🚀 ~ verifyToken ~ req.isSuperAdmin:", req.isSuperAdmin);
//   console.log(user.userType);
//   console.log(user.Usertype);

//   next();
// }



import { Request, Response, NextFunction } from "express";
import TokenService from "../services/token.service";
import { UserType } from "@prisma/client";

export interface AuthRequest extends Request {
  user?: any;
  isAdmin?: boolean;
  isSuperAdmin?: boolean;
}

export default function verifyToken(
  req: AuthRequest,
  res: Response,
  next: NextFunction
) {
  try {
    // ✅ token from header OR cookie
    const token = TokenService.getTokenFromAuthHeader(req);

    if (!token) {
      return res.status(401).json({
        success: false,
        message: "Authorization token missing",
      });
    }

    // ✅ verify + decode
    const decoded = TokenService.verifyAndDecode(token);

    if (!decoded) {
      return res.status(401).json({
        success: false,
        message: "Invalid or expired token",
      });
    }

    // ✅ normalize userType (new + legacy tokens)
    const userType =
      decoded.userType ??
      (decoded as any).Usertype ??
      (decoded as any).usertype ??
      (decoded as any)["user_type"];

    if (!userType) {
      return res.status(401).json({
        success: false,
        message: "User type missing in token",
      });
    }

    // ✅ attach FULL decoded user
    req.user = {
      ...decoded,
      userType, // overwrite normalized value
    };

    // ✅ role flags
    req.isAdmin = userType === UserType.admin;
    req.isSuperAdmin = userType === UserType.superadmin;

    return next();
  } catch (error) {
    console.error("verifyToken error:", error);
    return res.status(401).json({
      success: false,
      message: "Authentication failed",
    });
  }
}
