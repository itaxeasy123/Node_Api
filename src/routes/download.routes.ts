import express, { Router } from "express";
import FinanceDataController from "../controllers/download.controller"; // Assuming the controller file is in the same directory

const downloadrouter = Router();

// Routes for all API endpoints
downloadrouter.get("/status-wise-income-tax-code", FinanceDataController.getStatusWiseIncomeTaxCode);
downloadrouter.get("/pan-code", FinanceDataController.getPanCode);
downloadrouter.get("/gold-silver-rate", FinanceDataController.getGoldSilverRate);
downloadrouter.get("/interest-nsc", FinanceDataController.getInterestNSC);
downloadrouter.get("/interest-ivp", FinanceDataController.getInterestIVP);
downloadrouter.get("/interest-nsc-ix", FinanceDataController.getInterestNSCIX);
downloadrouter.get("/depreciation-table", FinanceDataController.getDepreciationTable);
downloadrouter.get("/interest-kvp", FinanceDataController.getInterestKVP);
downloadrouter.get("/cost-inflation-index", FinanceDataController.getAll);
downloadrouter.get("/cost-list-index", FinanceDataController.getcostlistindex);
downloadrouter.get("/country-code-list", FinanceDataController.getcountrycodelist);
export default downloadrouter;
