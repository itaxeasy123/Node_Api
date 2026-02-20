import { UserData } from "./src/types/user-data";

declare global {
  namespace Express {
    interface Request {
      user?: UserData;
      isAdmin?: boolean;
      isSuperAdmin?: boolean;
    }
  }
}

export {};
