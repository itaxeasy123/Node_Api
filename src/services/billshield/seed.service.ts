import { Prisma, AccountNature, ReportSectionType } from "@prisma/client";

type Tx = Prisma.TransactionClient;

interface GroupSeed {
  name: string;
  parent?: string;
  nature: AccountNature;
  reportSection: ReportSectionType;
}

// The standard 28 groups: 15 primary + 13 sub-groups (Tally convention)
const GROUP_SEEDS: GroupSeed[] = [
  // Primary groups — Balance Sheet
  { name: "Capital Account", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Loans (Liability)", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Current Liabilities", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Fixed Assets", nature: "ASSET", reportSection: "BALANCE_SHEET" },
  { name: "Investments", nature: "ASSET", reportSection: "BALANCE_SHEET" },
  { name: "Current Assets", nature: "ASSET", reportSection: "BALANCE_SHEET" },
  { name: "Misc. Expenses (Asset)", nature: "ASSET", reportSection: "BALANCE_SHEET" },
  { name: "Suspense Account", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Branch / Divisions", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  // Primary groups — Trading & P&L
  { name: "Sales Accounts", nature: "INCOME", reportSection: "TRADING" },
  { name: "Purchase Accounts", nature: "EXPENSE", reportSection: "TRADING" },
  { name: "Direct Income", nature: "INCOME", reportSection: "TRADING" },
  { name: "Direct Expenses", nature: "EXPENSE", reportSection: "TRADING" },
  { name: "Indirect Income", nature: "INCOME", reportSection: "PROFIT_AND_LOSS" },
  { name: "Indirect Expenses", nature: "EXPENSE", reportSection: "PROFIT_AND_LOSS" },
  // Sub-groups
  { name: "Reserves & Surplus", parent: "Capital Account", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Secured Loans", parent: "Loans (Liability)", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Unsecured Loans", parent: "Loans (Liability)", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Bank OD/OCC Accounts", parent: "Loans (Liability)", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Sundry Creditors", parent: "Current Liabilities", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Duties & Taxes", parent: "Current Liabilities", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Provisions", parent: "Current Liabilities", nature: "LIABILITY", reportSection: "BALANCE_SHEET" },
  { name: "Cash-in-Hand", parent: "Current Assets", nature: "ASSET", reportSection: "BALANCE_SHEET" },
  { name: "Bank Accounts", parent: "Current Assets", nature: "ASSET", reportSection: "BALANCE_SHEET" },
  { name: "Sundry Debtors", parent: "Current Assets", nature: "ASSET", reportSection: "BALANCE_SHEET" },
  { name: "Stock-in-Hand", parent: "Current Assets", nature: "ASSET", reportSection: "BALANCE_SHEET" },
  { name: "Deposits (Asset)", parent: "Current Assets", nature: "ASSET", reportSection: "BALANCE_SHEET" },
  { name: "Loans & Advances (Asset)", parent: "Current Assets", nature: "ASSET", reportSection: "BALANCE_SHEET" },
];

const VOUCHER_TYPE_SEEDS = [
  { code: "PMT", name: "Payment", baseType: "PAYMENT" },
  { code: "RCT", name: "Receipt", baseType: "RECEIPT" },
  { code: "CNT", name: "Contra", baseType: "CONTRA" },
  { code: "SAL", name: "Sales", baseType: "SALES" },
  { code: "PUR", name: "Purchase", baseType: "PURCHASE" },
  { code: "DRN", name: "Debit Note", baseType: "DEBIT_NOTE" },
  { code: "CRN", name: "Credit Note", baseType: "CREDIT_NOTE" },
  { code: "JRN", name: "Journal", baseType: "JOURNAL" },
] as const;

const SYSTEM_LEDGER_SEEDS = [
  { name: "Cash A/c", group: "Cash-in-Hand" },
  { name: "Profit & Loss A/c", group: "Reserves & Surplus" },
  { name: "CGST Input A/c", group: "Duties & Taxes" },
  { name: "CGST Output A/c", group: "Duties & Taxes" },
  { name: "SGST Input A/c", group: "Duties & Taxes" },
  { name: "SGST Output A/c", group: "Duties & Taxes" },
  { name: "IGST Input A/c", group: "Duties & Taxes" },
  { name: "IGST Output A/c", group: "Duties & Taxes" },
];

/** Indian fiscal year (Apr 1 – Mar 31) containing the given date. */
export function fiscalYearBounds(date: Date) {
  const y = date.getUTCMonth() + 1 >= 4 ? date.getUTCFullYear() : date.getUTCFullYear() - 1;
  return {
    startDate: new Date(Date.UTC(y, 3, 1)),
    endDate: new Date(Date.UTC(y + 1, 2, 31, 23, 59, 59, 999)),
    label: `${y}-${String((y + 1) % 100).padStart(2, "0")}`,
  };
}

/** Seeds default groups, voucher types, system ledgers and the first
 *  fiscal year for a freshly created company. Run inside the same
 *  transaction that creates the company. */
export async function seedCompanyDefaults(tx: Tx, companyId: string, booksBeginDate: Date) {
  const groupIdByName = new Map<string, string>();

  // path is computed by the billshield_group_tree_guard DB trigger
  for (const g of GROUP_SEEDS) {
    const created = await tx.accountGroup.create({
      data: {
        companyId,
        name: g.name,
        parentGroupId: g.parent ? groupIdByName.get(g.parent)! : null,
        nature: g.nature,
        reportSection: g.reportSection,
        isSystem: true,
        path: "",
      },
    });
    groupIdByName.set(g.name, created.id);
  }

  for (const vt of VOUCHER_TYPE_SEEDS) {
    await tx.voucherType.create({
      data: { companyId, code: vt.code, name: vt.name, baseType: vt.baseType, isSystem: true },
    });
  }

  for (const l of SYSTEM_LEDGER_SEEDS) {
    await tx.ledgerAccount.create({
      data: { companyId, name: l.name, groupId: groupIdByName.get(l.group)!, isSystem: true },
    });
  }

  const fy = fiscalYearBounds(booksBeginDate);
  await tx.fiscalYear.create({ data: { companyId, ...fy } });
}
