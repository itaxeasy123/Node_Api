import { NextFunction, Request, Response } from "express";
import { prisma } from "..";

const WRITE_ROLES = ["OWNER", "ADMIN", "ACCOUNTANT"];

/**
 * Verifies the authenticated user is a member of the :companyId in the
 * route, attaches req.companyId / req.companyRole. Mutating methods
 * require a write role; GET is allowed for every member incl. VIEWER.
 */
export default async function companyAccess(req: Request, res: Response, next: NextFunction) {
  try {
    if (!req.user) {
      return res.status(401).json({ success: false, message: "Unauthorized" });
    }
    const { companyId } = req.params;
    if (!companyId) {
      return res.status(400).json({ success: false, message: "companyId missing in route" });
    }

    const membership = await prisma.companyUser.findFirst({
      where: { companyId, userId: req.user.id },
    });
    if (!membership) {
      return res.status(403).json({ success: false, message: "You are not a member of this company" });
    }
    if (req.method !== "GET" && !WRITE_ROLES.includes(membership.role)) {
      return res.status(403).json({ success: false, message: "Your role does not allow changes in this company" });
    }

    req.companyId = companyId;
    req.companyRole = membership.role;
    return next();
  } catch (error) {
    console.error("companyAccess error:", error);
    return res.status(500).json({ success: false, message: "Internal server error" });
  }
}
