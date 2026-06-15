import { Request, Response } from "express";
import { prisma } from "../..";
import { BillShieldError } from "../../services/billshield/voucher.service";
import { createGroupSchema, updateGroupSchema } from "../../types/billshield";
import { handleBillShieldError, parseBody } from "./util";

export class GroupController {
  static async list(req: Request, res: Response) {
    try {
      const groups = await prisma.accountGroup.findMany({
        where: { companyId: req.companyId! },
        orderBy: { path: "asc" },
      });
      return res.json({ success: true, data: groups });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  /** Full hierarchy: groups nested under their parents, ledgers at the leaves. */
  static async tree(req: Request, res: Response) {
    try {
      const [groups, ledgers] = await Promise.all([
        prisma.accountGroup.findMany({ where: { companyId: req.companyId! }, orderBy: { path: "asc" } }),
        prisma.ledgerAccount.findMany({ where: { companyId: req.companyId! }, orderBy: { name: "asc" } }),
      ]);

      const nodes = new Map<string, any>();
      groups.forEach((g) => nodes.set(g.id, { ...g, subGroups: [], ledgers: [] }));
      ledgers.forEach((l) => nodes.get(l.groupId)?.ledgers.push(l));
      const roots: any[] = [];
      groups.forEach((g) => {
        const node = nodes.get(g.id);
        if (g.parentGroupId && nodes.has(g.parentGroupId)) nodes.get(g.parentGroupId).subGroups.push(node);
        else roots.push(node);
      });
      return res.json({ success: true, data: roots });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async create(req: Request, res: Response) {
    try {
      const input = parseBody(res, createGroupSchema, req.body);
      if (!input) return;

      let nature = input.nature;
      let reportSection = input.reportSection;
      if (input.parentGroupId) {
        const parent = await prisma.accountGroup.findFirst({
          where: { id: input.parentGroupId, companyId: req.companyId! },
        });
        if (!parent) throw new BillShieldError("Parent group not found", 404);
        nature = parent.nature; // sub-groups always inherit
        reportSection = parent.reportSection;
      } else if (!nature || !reportSection) {
        throw new BillShieldError("Primary groups need nature and reportSection");
      }

      const group = await prisma.accountGroup.create({
        data: {
          companyId: req.companyId!,
          name: input.name,
          parentGroupId: input.parentGroupId ?? null,
          nature: nature!,
          reportSection: reportSection!,
          path: "", // computed by DB trigger
        },
      });
      return res.status(201).json({ success: true, data: group });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async update(req: Request, res: Response) {
    try {
      const input = parseBody(res, updateGroupSchema, req.body);
      if (!input) return;

      const group = await prisma.accountGroup.findFirst({
        where: { id: req.params.id, companyId: req.companyId! },
      });
      if (!group) throw new BillShieldError("Group not found", 404);
      if (group.isSystem && input.parentGroupId !== undefined) {
        throw new BillShieldError("System groups cannot be re-parented");
      }
      if (group.isSystem && input.name && input.name !== group.name) {
        throw new BillShieldError("System groups cannot be renamed");
      }

      const updated = await prisma.accountGroup.update({
        where: { id: group.id },
        data: { name: input.name, parentGroupId: input.parentGroupId },
      });
      return res.json({ success: true, data: updated });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }

  static async remove(req: Request, res: Response) {
    try {
      const group = await prisma.accountGroup.findFirst({
        where: { id: req.params.id, companyId: req.companyId! },
        include: { _count: { select: { subGroups: true, ledgers: true } } },
      });
      if (!group) throw new BillShieldError("Group not found", 404);
      if (group.isSystem) throw new BillShieldError("System groups cannot be deleted");
      if (group._count.subGroups > 0 || group._count.ledgers > 0) {
        throw new BillShieldError("Group has sub-groups or ledgers — move them first");
      }
      await prisma.accountGroup.delete({ where: { id: group.id } });
      return res.json({ success: true, message: "Group deleted" });
    } catch (error) {
      return handleBillShieldError(res, error);
    }
  }
}
