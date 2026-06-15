import { z } from "zod";

export const createCompanySchema = z.object({
  name: z.string().min(1),
  gstin: z.string().optional(),
  pan: z.string().optional(),
  stateCode: z.string().optional(),
  booksBeginDate: z.coerce.date(),
});

export const updateCompanySchema = createCompanySchema.partial();

export const addMemberSchema = z.object({
  email: z.string().email(),
  role: z.enum(["OWNER", "ADMIN", "ACCOUNTANT", "VIEWER"]),
});

export const createGroupSchema = z.object({
  name: z.string().min(1),
  parentGroupId: z.string().uuid().nullable().optional(),
  nature: z.enum(["ASSET", "LIABILITY", "INCOME", "EXPENSE"]).optional(),
  reportSection: z.enum(["TRADING", "PROFIT_AND_LOSS", "BALANCE_SHEET"]).optional(),
});

export const updateGroupSchema = z.object({
  name: z.string().min(1).optional(),
  parentGroupId: z.string().uuid().nullable().optional(),
});

export const createLedgerSchema = z.object({
  name: z.string().min(1),
  groupId: z.string().uuid(),
  openingBalance: z.coerce.number().min(0).default(0),
  openingBalanceType: z.enum(["DR", "CR"]).default("DR"),
  partyId: z.string().uuid().nullable().optional(),
  bankName: z.string().optional(),
  bankAccountNo: z.string().optional(),
  bankIfsc: z.string().optional(),
  description: z.string().optional(),
});

export const updateLedgerSchema = createLedgerSchema.partial();

export const voucherLineSchema = z
  .object({
    ledgerId: z.string().uuid(),
    debit: z.coerce.number().min(0).default(0),
    credit: z.coerce.number().min(0).default(0),
    narration: z.string().optional(),
  })
  .refine((l) => (l.debit > 0 && l.credit === 0) || (l.credit > 0 && l.debit === 0), {
    message: "Each line must have either a debit or a credit amount, not both",
  });

export const voucherGstLineSchema = z.object({
  description: z.string().optional(),
  hsnSac: z.string().optional(),
  taxableValue: z.coerce.number().min(0).default(0),
  cgst: z.coerce.number().min(0).default(0),
  sgst: z.coerce.number().min(0).default(0),
  igst: z.coerce.number().min(0).default(0),
  cess: z.coerce.number().min(0).default(0),
});

export const createVoucherSchema = z.object({
  voucherTypeCode: z.enum(["PMT", "RCT", "CNT", "SAL", "PUR", "DRN", "CRN", "JRN"]),
  voucherDate: z.coerce.date(),
  narration: z.string().optional(),
  partyId: z.string().uuid().nullable().optional(),
  lines: z.array(voucherLineSchema).min(2),
  gstLines: z.array(voucherGstLineSchema).optional(),
  post: z.boolean().default(false),
});

export const updateVoucherSchema = createVoucherSchema
  .omit({ post: true })
  .partial()
  .extend({ lines: z.array(voucherLineSchema).min(2).optional() });

export const createFiscalYearSchema = z.object({
  startDate: z.coerce.date(),
});

export const reconcileLineSchema = z.object({
  instrumentNo: z.string().optional(),
  instrumentDate: z.coerce.date().optional(),
  clearedOn: z.coerce.date().nullable().optional(),
  statementRef: z.string().optional(),
});

export const reverseVoucherSchema = z.object({
  voucherDate: z.coerce.date().optional(),
  narration: z.string().optional(),
});

export type CreateVoucherInput = z.infer<typeof createVoucherSchema>;
export type VoucherLineInput = z.infer<typeof voucherLineSchema>;
