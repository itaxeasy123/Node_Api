import { Router } from "express";
import verifyToken from "../middlewares/verify-token";
import companyAccess from "../middlewares/company-access";
import { CompanyController } from "../controllers/billshield/company.controller";
import { GroupController } from "../controllers/billshield/group.controller";
import { LedgerController } from "../controllers/billshield/ledger.controller";
import { VoucherController } from "../controllers/billshield/voucher.controller";
import { ReportController } from "../controllers/billshield/report.controller";
import { FiscalYearController } from "../controllers/billshield/fiscalYear.controller";

const billshieldRouter = Router();
billshieldRouter.use(verifyToken);

// ---- Companies ----
billshieldRouter.post("/companies", CompanyController.create);
billshieldRouter.get("/companies", CompanyController.list);

// Everything below is scoped to one company and gated by membership/role
const company = Router({ mergeParams: true });
billshieldRouter.use("/companies/:companyId", companyAccess, company);

company.get("/", CompanyController.get);
company.put("/", CompanyController.update);
company.post("/members", CompanyController.addMember);
company.delete("/members/:userId", CompanyController.removeMember);

// ---- Chart of accounts: groups (primary + sub-groups) ----
company.get("/groups", GroupController.list);
company.get("/groups/tree", GroupController.tree);
company.post("/groups", GroupController.create);
company.put("/groups/:id", GroupController.update);
company.delete("/groups/:id", GroupController.remove);

// ---- Ledgers (the postable leaves) ----
company.get("/ledgers", LedgerController.list);
company.get("/ledgers/:id", LedgerController.get);
company.get("/ledgers/:id/statement", LedgerController.statement);
company.post("/ledgers", LedgerController.create);
company.put("/ledgers/:id", LedgerController.update);
company.delete("/ledgers/:id", LedgerController.remove);

// ---- Fiscal years ----
company.get("/fiscal-years", FiscalYearController.list);
company.post("/fiscal-years", FiscalYearController.create);
company.post("/fiscal-years/:id/close", FiscalYearController.close);

// ---- Vouchers ----
company.post("/vouchers", VoucherController.create);
company.get("/vouchers", VoucherController.list);
company.get("/vouchers/:id", VoucherController.get);
company.put("/vouchers/:id", VoucherController.update); // drafts only
company.delete("/vouchers/:id", VoucherController.remove); // drafts only
company.post("/vouchers/:id/post", VoucherController.post);
company.post("/vouchers/:id/reverse", VoucherController.reverse);
company.put("/voucher-lines/:lineId/reconcile", VoucherController.reconcileLine);

// ---- Reports (all derived from the journal) ----
company.get("/reports/cashbook", ReportController.cashbook);
company.get("/reports/bankbook", ReportController.bankbook);
company.get("/reports/daybook", ReportController.dayBook);
company.get("/reports/trial-balance", ReportController.trialBalance);
company.get("/reports/profit-loss", ReportController.profitAndLoss);
company.get("/reports/balance-sheet", ReportController.balanceSheet);

export default billshieldRouter;
