import { NextFunction, Request, Response } from "express";

// Define a specific interface for the Request object with the expected role flags
interface AuthRoleRequest extends Request {
  isAdmin?: boolean;
  isSuperAdmin?: boolean;
}

/**
 * Middleware to check if the authenticated user has 'admin' or 'superadmin' privileges.
 * This assumes a previous authentication middleware has populated the role flags (isAdmin, isSuperAdmin).
 */
export default function adminCheck(
  req: AuthRoleRequest,
  res: Response,
  next: NextFunction
) {
  // Check if neither of the required roles is present (the most efficient check for denial)
  if (!req.isAdmin && !req.isSuperAdmin) {
    console.warn(`ADMIN CHECK DENIED: Attempted access with roles -> isAdmin: ${req.isAdmin}, isSuperAdmin: ${req.isSuperAdmin}`);

    return res.status(401).send({
      success: false,
      message:
        "Unauthorized Access. You must be an admin or superadmin to perform this operation.",
    });
  }

  // If authorized, proceed to the next middleware or route handler
  next();
}