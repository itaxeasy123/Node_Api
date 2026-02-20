// import { UserData } from './user-data';

// declare global {
//   namespace Express {
//     interface Request {
//       user?: UserData;
//     }
//   }
// }

// export {};
import type { UserData } from "./user-data";

declare global {
  namespace Express {
    interface Request {
      user?: UserData;
      isAdmin?: boolean;   // ✅ ADD THIS LINE
    }
  }
}

export {};
