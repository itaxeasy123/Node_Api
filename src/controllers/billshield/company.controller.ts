import { Request, Response } from "express";
import { prisma } from "../..";
import { seedCompanyDefaults } from "../../services/billshield/seed.service";
import { createCompanySchema, updateCompanySchema, addMemberSchema } from "../../types/billshield";
import { handleBillShieldError, parseBody } from "./util";

export class CompanyController {
  /** Creates a company and seeds the 28 default groups, 8 voucher
   *  types, system ledgers and the first fiscal year — atomically. */
  static async create(req: Request, res: Response) {
    try {
      const input = parseBody(res, createCompanySchema, req.body);
      if (!input) return;
      const userId = req.user!.id;

      const company = await prisma.$transaction(async (tx) => {
        const company = await tx.company.create({
          data: {
            name: input.name,
            gstin: input.gstin,
            pan: input.pan,
            stateCode: input.stateCode,
            booksBeginDate: input.booksBeginDate,
            members: { create: { userId, role: "OWNER" } },
          },
        });
        await seedCompanyDefaults(tx, company.id, input.booksBeginDate);
        return company;
      });

      return res.status(201).json({ success: true, data: company });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async list(req: Request, res: Response) {
    try {
      const companies = await prisma.company.findMany({
        where: { members: { some: { userId: req.user!.id } } },
        include: { members: { where: { userId: req.user!.id }, select: { role: true } } },
      });
      return res.json({
        success: true,
        data: companies.map(({ members, ...c }) => ({ ...c, role: members[0]?.role })),
      });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async get(req: Request, res: Response) {
    try {
      const company = await prisma.company.findUnique({
        where: { id: req.companyId! },
        include: { members: { include: { user: { select: { id: true, email: true, firstName: true, lastName: true } } } } },
      });
      return res.json({ success: true, data: company });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async update(req: Request, res: Response) {
    try {
      const input = parseBody(res, updateCompanySchema, req.body);
      if (!input) return;
      const company = await prisma.company.update({ where: { id: req.companyId! }, data: input });
      return res.json({ success: true, data: company });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async addMember(req: Request, res: Response) {
    try {
      if (req.companyRole !== "OWNER" && req.companyRole !== "ADMIN") {
        return res.status(403).json({ success: false, message: "Only owners/admins can manage members" });
      }
      const input = parseBody(res, addMemberSchema, req.body);
      if (!input) return;

      const user = await prisma.user.findUnique({ where: { email: input.email } });
      if (!user) return res.status(404).json({ success: false, message: "No user with that email" });

      const member = await prisma.companyUser.upsert({
        where: { companyId_userId: { companyId: req.companyId!, userId: user.id } },
        create: { companyId: req.companyId!, userId: user.id, role: input.role },
        update: { role: input.role },
      });
      return res.json({ success: true, data: member });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async removeMember(req: Request, res: Response) {
    try {
      if (req.companyRole !== "OWNER" && req.companyRole !== "ADMIN") {
        return res.status(403).json({ success: false, message: "Only owners/admins can manage members" });
      }
      const userId = parseInt(req.params.userId, 10);
      const target = await prisma.companyUser.findFirst({ where: { companyId: req.companyId!, userId } });
      if (!target) return res.status(404).json({ success: false, message: "Member not found" });
      if (target.role === "OWNER") {
        return res.status(400).json({ success: false, message: "The owner cannot be removed" });
      }
      await prisma.companyUser.delete({ where: { id: target.id } });
      return res.json({ success: true, message: "Member removed" });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }
}
