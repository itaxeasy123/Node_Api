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

export default class TokenService {

  // ✅ FIX 1: Header + Cookie (authToken) support
  static getTokenFromAuthHeader(req: Request): string | undefined {
    const authorization = req.headers.authorization;


    if (authorization?.startsWith("Bearer ")) {
      return authorization.split(" ")[1];
    }

    // 🔥 FIX: correct cookie name
    return req.cookies?.authToken;
  }

  // ✅ FIX 2: payload key name (userType)
  static generateToken(user: UserData) {
    const tokenPayload = {
      email: user.email,
      id: user.id,
      userType: user.userType, // 🔥 FIXED (was Usertype)
    };

    return jwt.sign(tokenPayload, process.env.JWT_KEY as string, {
      issuer: "iTaxEasy",
      expiresIn: "24h",
    });
  }

  static decodeToken(token: string): UserData {
    return jwt.decode(token) as UserData;
  }

  // ✅ FIX 3: keep verifyToken SAFE
  static verifyToken(token: string): UserData {
    return jwt.verify(token, process.env.JWT_KEY as string) as UserData;
  }

  // ✅ FIX 4: stable method for middleware
  static verifyAndDecode(token: string): UserData | null {
    try {
      jwt.verify(token, process.env.JWT_KEY as string);
      return jwt.decode(token) as UserData;
    } catch {
      return null;
    }
  }
}
