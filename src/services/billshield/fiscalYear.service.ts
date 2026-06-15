import { prisma } from "../..";
import { BillShieldError } from "./voucher.service";
import { fiscalYearBounds } from "./seed.service";

export class FiscalYearService {
  static list(companyId: string) {
    return prisma.fiscalYear.findMany({ where: { companyId }, orderBy: { startDate: "asc" } });
  }

  static async create(companyId: string, anyDateInYear: Date) {
    const bounds = fiscalYearBounds(anyDateInYear);
    const existing = await prisma.fiscalYear.findFirst({
      where: { companyId, startDate: bounds.startDate },
    });
    if (existing) throw new BillShieldError(`Fiscal year ${bounds.label} already exists`);
    return prisma.fiscalYear.create({ data: { companyId, ...bounds } });
  }

  /**
   * Year close. Closing balances need no posting: every report computes
   * balances continuously from opening + all journal lines, so the next
   * year's opening figures are automatic. Closing just locks the year
   * (the DB trigger then rejects any posting into it) and makes sure the
   * next fiscal year exists.
   */
  static async close(companyId: string, fiscalYearId: string) {
    const fy = await prisma.fiscalYear.findFirst({ where: { id: fiscalYearId, companyId } });
    if (!fy) throw new BillShieldError("Fiscal year not found", 404);
    if (fy.isClosed) throw new BillShieldError(`Fiscal year ${fy.label} is already closed`);

    const drafts = await prisma.voucher.count({
      where: { companyId, fiscalYearId, status: "DRAFT" },
    });
    if (drafts > 0)
      throw new BillShieldError(
        `Cannot close ${fy.label}: ${drafts} draft voucher(s) pending — post or delete them first`,
      );

    const nextStart = fiscalYearBounds(new Date(fy.endDate.getTime() + 24 * 60 * 60 * 1000));
    return prisma.$transaction(async (tx) => {
      const nextExists = await tx.fiscalYear.findFirst({
        where: { companyId, startDate: nextStart.startDate },
      });
      if (!nextExists) await tx.fiscalYear.create({ data: { companyId, ...nextStart } });
      return tx.fiscalYear.update({ where: { id: fiscalYearId }, data: { isClosed: true } });
    });
  }
}
