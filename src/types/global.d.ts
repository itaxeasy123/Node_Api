import { UserData } from './user-data';

declare global {
  namespace Express {
    interface Request {
      user?: UserData;
      isAdmin?: boolean;
      isSuperAdmin?: boolean;
      companyId?: string;
      companyRole?: string;
    }
  }
}

export {};
