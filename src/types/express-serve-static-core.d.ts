import { UserData } from './user-data';

declare module 'express-serve-static-core' {
  interface Request {
    user?: UserData;
    isAdmin?: boolean;
    isSuperAdmin?: boolean;
  }
}

export {};
