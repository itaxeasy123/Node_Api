// import jwt from 'jsonwebtoken';
// import { UserData } from '../types/user-data';
// import { Request } from 'express';
// export default class TokenService {

//     static getTokenFromAuthHeader(req: Request): string | undefined {
//         console.log(req.headers)
//         const authorization = req.headers["authorization"];
//         const tokenFromHeader = authorization?.split(' ').pop();
//         const tokenFromCookies = req.cookies?.token;
    
//         // Use ternary operator to return token from header or cookies
//         return tokenFromHeader ?? tokenFromCookies;
//     }

//     static generateToken(user:UserData) {
//         console.log(user.userType,"suer")
//         const tokenPayload = {
//             email: user.email,
//             id: user.id,
//             Usertype:user.userType
//         };
//         // const secretKey = process.env.JWT_KEY;
// // console.log("JWT Secret Key for Signing:", secretKey);
//         const token = jwt.sign(tokenPayload, process.env.JWT_KEY as string, {
//             issuer: "iTaxEasy",
//             expiresIn: "24h"
//         });

//         return token;
//     }

//     static decodeToken(token: string) {
//         const result: UserData = jwt.decode(token) as UserData;

//         return result;
//     }

//     static verifyToken(token: string) {
//         // const secretKey = process.env.JWT_KEY;
// // console.log("JWT Secret Key for Verification:", secretKey); 
//         const verified = jwt.verify(token, process.env.JWT_KEY as string);

//         return verified;
//     }

//     static verifyAndDecode(token: string) {
//         try {
//             const verified = jwt.verify(token, process.env.JWT_KEY as string);
//             const decoded: UserData = jwt.decode(token) as UserData;
//             return decoded ?? (verified as UserData) ?? null;
//         } catch (err) {
//             return null;
//         }
//     }

// }



// // // src/services/token.service.ts
// // import jwt from "jsonwebtoken";
// // import { Request } from "express";
// // import { UserData } from "../types/user-data";

// // export default class TokenService {

// //   static getTokenFromAuthHeader(req: Request): string | null {
// //     const authHeader = req.headers.authorization;
// //     if (authHeader?.startsWith("Bearer ")) {
// //       return authHeader.split(" ")[1];
// //     }
// //     if (req.cookies?.authToken) {
// //       return req.cookies.authToken;
// //     }
// //     return null;
// //   }

// //   static generateToken(user: UserData) {
// //     return jwt.sign(
// //       {
// //         id: user.id,
// //         email: user.email,
// //         userType: user.userType,
// //       },
// //       process.env.JWT_KEY as string,
// //       { expiresIn: "24h", issuer: "iTaxEasy" }
// //     );
// //   }

// //   static verifyAndDecode(token: string): UserData | null {
// //     try {
// //       jwt.verify(token, process.env.JWT_KEY as string);
// //       return jwt.decode(token) as UserData;
// //     } catch {
// //       return null;
// //     }
// //   }
// // }





import jwt from "jsonwebtoken";
import { UserData } from "../types/user-data";
import { Request } from "express";

// Token lifetimes (env-overridable).
const ACCESS_TTL = process.env.ACCESS_TOKEN_TTL || "15m";
const REFRESH_TTL_DAYS = Number(process.env.REFRESH_TOKEN_TTL_DAYS || 7);

const accessSecret = () => process.env.JWT_KEY as string;
const refreshSecret = () =>
  (process.env.JWT_REFRESH_KEY || process.env.JWT_KEY) as string;

export interface RefreshPayload {
  id: number;
  jti: string; // matches RefreshToken.id in the DB
}

export default class TokenService {
  static REFRESH_TTL_DAYS = REFRESH_TTL_DAYS;

  // Pull a bearer token from the Authorization header (the access token is now
  // sent in-memory via the header). Falls back to the legacy authToken cookie.
  static getTokenFromAuthHeader(req: Request): string | undefined {
    const authorization = req.headers.authorization;
    if (authorization?.startsWith("Bearer ")) {
      return authorization.split(" ")[1];
    }
    return req.cookies?.authToken;
  }

  // ---- Access token (short-lived) ----
  static generateAccessToken(
    user: UserData | { id: number; email: string; userType: any }
  ) {
    const payload = {
      id: user.id,
      email: user.email,
      userType: user.userType,
    };
    return jwt.sign(payload, accessSecret(), {
      issuer: "iTaxEasy",
      expiresIn: ACCESS_TTL,
    });
  }

  // Backwards-compatible alias.
  static generateToken(user: UserData) {
    return TokenService.generateAccessToken(user);
  }

  // ---- Refresh token (long-lived, DB-backed via jti) ----
  static generateRefreshToken(payload: RefreshPayload) {
    return jwt.sign(payload, refreshSecret(), {
      issuer: "iTaxEasy",
      expiresIn: `${REFRESH_TTL_DAYS}d`,
    });
  }

  static verifyRefreshToken(token: string): RefreshPayload | null {
    try {
      return jwt.verify(token, refreshSecret()) as RefreshPayload;
    } catch {
      return null;
    }
  }

  static decodeToken(token: string): UserData {
    return jwt.decode(token) as UserData;
  }

  static verifyToken(token: string): UserData {
    return jwt.verify(token, accessSecret()) as UserData;
  }

  // Used by the auth middleware to validate the ACCESS token.
  static verifyAndDecode(token: string): UserData | null {
    try {
      jwt.verify(token, accessSecret());
      return jwt.decode(token) as UserData;
    } catch {
      return null;
    }
  }
}
