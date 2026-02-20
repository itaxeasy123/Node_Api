// import { NextFunction, Request, Response } from "express";
// import TokenService from "../services/token.service";

// export default function SuperadminCheck(
//   req: Request,
//   res: Response,
//   next: NextFunction
// ) {
//   const token = TokenService.getTokenFromAuthHeader(req);

//   if (!token) {
//     return res
//       .status(403)
//       .send({ success: false, message: "Authorization Token is required" });
//   }

//   const verified = TokenService.verifyToken(token);

//   if (!verified) {
//     return res.status(401).send({
//       success: false,
//       message: "Unauthorized: Access is denied due to invalid credentials",
//     });
//   }

//   const user = TokenService.decodeToken(token);
//   console.log("Decoded user:", user); // Log the entire user object to debug

//   // Check if the Usertype property exists (note the capital 'U')
//   if (!user || (typeof user === 'object' && !('Usertype' in user))) {
//     console.log("Usertype property missing in token payload");
//     return res.status(401).send({
//       success: false,
//       message: "Invalid token format: User type information missing",
//     });
//   }

//   const superuser = user.Usertype === "superadmin";
//   console.log("Usertype:", user.Usertype);
//   console.log("isSuperadmin:", superuser);

//   if (!superuser) {
//     return res.status(401).send({
//       success: false,
//       message:
//         "Unauthorized Access. You must be an Superadmin to perform this operation.",
//     });
//   }

//   req.user = user;
//   next();
// }






import { NextFunction, Request, Response } from "express";
import TokenService from "../services/token.service";

export default function SuperadminCheck(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const token = TokenService.getTokenFromAuthHeader(req);

  if (!token) {
    return res.status(403).json({
      success: false,
      message: "Authorization token required",
    });
  }

  // ✅ verify + decode ONCE
  const user = TokenService.verifyAndDecode(token);

  if (!user) {
    return res.status(401).json({
      success: false,
      message: "Invalid or expired token",
    });
  }

  console.log("Decoded user:", user);

  // ✅ ONLY correct field
  if (user.userType !== "superadmin") {
    return res.status(403).json({
      success: false,
      message: "Superadmin access required",
    });
  }

  // attach user for next middleware / controller
  (req as any).user = user;

  next();
}
