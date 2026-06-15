import { Request, Response } from "express";
import { validateGSTIN } from "../../lib/util";
import { redisClient } from "../../middlewares/redis-adder";

/**
 * ============================================================
 * GSTR-1 MOCK SANDBOX CONTROLLER (Industrial Testing)
 * - Works only after OTP verify (token in Redis)
 * - Returns consistent API shape
 * - Supports common GSTR-1 sections
 * ============================================================
 */

type GstSectionQuery = {
  gstin?: string;
  year?: string;
  month?: string;
  from?: string;
  ctin?: string;
  state_code?: string;
  action_required?: string;
};

function ok(res: Response, payload: any, message?: string) {
  return res.status(200).json({ success: true, message: message || "OK", data: payload });
}

function bad(res: Response, message: string) {
  return res.status(400).json({ success: false, message });
}

function unauth(res: Response, message: string) {
  return res.status(401).json({ success: false, message });
}

async function requireGstSession(gstin: string) {
  const token = await redisClient.get(`gst-token:${gstin}`);
  return token;
}

function requireCommonParams(q: GstSectionQuery, res: Response) {
  const gstin = String(q.gstin || "").trim();
  const year = String(q.year || "").trim();
  const month = String(q.month || "").trim();

  if (!gstin) return { error: bad(res, "gstin is required in query") };
  if (!validateGSTIN(gstin)) return { error: bad(res, "Invalid GSTIN") };
  if (!year) return { error: bad(res, "year is required in query") };
  if (!month) return { error: bad(res, "month is required in query") };

  // month basic validation: "01".."12"
  const m = Number(month);
  if (Number.isNaN(m) || m < 1 || m > 12) return { error: bad(res, "month must be between 01 and 12") };

  return { gstin, year, month };
}

export default class GSTR1MockController {
  // ============================================================
  // GSTR-1 SUMMARY
  // GET /api/sandbox/gst/gstr1/summary?gstin=..&year=..&month=..
  // ============================================================
  static async summary(req: Request, res: Response) {
    const params = requireCommonParams(req.query as any, res);
   
    if (params.error) return; // response already sent
 
    const { gstin, year, month } = params;

    const sessionToken = await requireGstSession(gstin);
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    return ok(
      res,
      {
        gstin,
        period: `${month}-${year}`,
        totals: {
          b2b_count: 2,
          b2cs_count: 2,
          b2cl_count: 1,
          cdnr_count: 1,
          hsn_items: 2,
          nil_supplies: 1,
          taxable_value: 250000,
          igst: 18000,
          cgst: 13500,
          sgst: 13500,
          cess: 0,
        },
        sections_available: ["b2b", "b2cs", "b2cl", "cdnr", "hsn", "nil", "doc-issue", "at", "ata"],
      },
      "GSTR-1 summary fetched (mock sandbox)"
    );
  }

  // ============================================================
  // B2B
  // GET /api/sandbox/gst/gstr1/b2b?gstin=..&year=..&month=..&ctin=.. (optional)
  // ============================================================
  static async b2b(req: Request, res: Response) {
    const params = requireCommonParams(req.query as any, res);
 
    if (params.error) return;
   
    const { gstin, year, month } = params;

    const sessionToken = await requireGstSession(gstin);
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    const q = req.query as any as GstSectionQuery;
    const ctin = q.ctin ? String(q.ctin).trim() : undefined;

    const data = {
      gstin,
      period: `${month}-${year}`,
      b2b: [
        {
          ctin: ctin || "29ABCDE1234F1Z5",
          inv: [
            {
              inum: "INV-001",
              idt: `${year}-${month}-05`,
              val: 118000,
              pos: "29",
              rchrg: "N",
              etin: null,
              inv_typ: "R",
              itms: [
                { num: 1, itm_det: { txval: 100000, rt: 18, igst: 0, cgst: 9000, sgst: 9000, cess: 0 } },
              ],
            },
            {
              inum: "INV-002",
              idt: `${year}-${month}-10`,
              val: 59000,
              pos: "29",
              rchrg: "N",
              etin: null,
              inv_typ: "R",
              itms: [{ num: 1, itm_det: { txval: 50000, rt: 18, igst: 0, cgst: 4500, sgst: 4500, cess: 0 } }],
            },
          ],
        },
      ],
    };

    return ok(res, data, "GSTR-1 B2B fetched (mock)");
  }

  // ============================================================
  // B2CS
  // GET /api/sandbox/gst/gstr1/b2cs?gstin=..&year=..&month=..
  // ============================================================
  static async b2cs(req: Request, res: Response) {
    const params = requireCommonParams(req.query as any, res);
  
    if (params.error) return;
   
    const { gstin, year, month } = params;

    const sessionToken = await requireGstSession(gstin);
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    return ok(
      res,
      {
        gstin,
        period: `${month}-${year}`,
        b2cs: [
          { sply_ty: "INTRA", pos: "23", typ: "OE", rt: 18, txval: 25000, igst: 0, cgst: 2250, sgst: 2250, cess: 0 },
          { sply_ty: "INTER", pos: "07", typ: "OE", rt: 12, txval: 40000, igst: 4800, cgst: 0, sgst: 0, cess: 0 },
        ],
      },
      "GSTR-1 B2CS fetched (mock)"
    );
  }

  // ============================================================
  // B2CL (Large B2C)
  // GET /api/sandbox/gst/gstr1/b2cl?gstin=..&year=..&month=..&state_code=..
  // ============================================================
  static async b2cl(req: Request, res: Response) {
    const params = requireCommonParams(req.query as any, res);
    
    if (params.error) return;

    const { gstin, year, month } = params;

    const sessionToken = await requireGstSession(gstin);
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    const q = req.query as any as GstSectionQuery;
    const state_code = q.state_code ? String(q.state_code).trim() : "09";

    return ok(
      res,
      {
        gstin,
        period: `${month}-${year}`,
        b2cl: [
          {
            pos: state_code,
            inv: [
              {
                inum: "B2CL-001",
                idt: `${year}-${month}-15`,
                val: 265000,
                etin: null,
                itms: [{ num: 1, itm_det: { txval: 250000, rt: 18, igst: 45000, cgst: 0, sgst: 0, cess: 0 } }],
              },
            ],
          },
        ],
      },
      "GSTR-1 B2CL fetched (mock)"
    );
  }

  // ============================================================
  // CDNR
  // GET /api/sandbox/gst/gstr1/cdnr?gstin=..&year=..&month=..&ctin=.. (optional)
  // ============================================================
  static async cdnr(req: Request, res: Response) {
    const params = requireCommonParams(req.query as any, res);
    
    if (params.error) return;
   
    const { gstin, year, month } = params;

    const sessionToken = await requireGstSession(gstin);
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    const q = req.query as any as GstSectionQuery;
    const ctin = q.ctin ? String(q.ctin).trim() : "29ABCDE1234F1Z5";

    return ok(
      res,
      {
        gstin,
        period: `${month}-${year}`,
        cdnr: [
          {
            ctin,
            nt: [
              {
                ntty: "C",
                nt_num: "CN-001",
                nt_dt: `${year}-${month}-18`,
                val: 11800,
                rsn: "Post-sale discount",
                p_gst: "N",
                itms: [{ num: 1, itm_det: { txval: 10000, rt: 18, igst: 0, cgst: 900, sgst: 900, cess: 0 } }],
              },
            ],
          },
        ],
      },
      "GSTR-1 CDNR fetched (mock)"
    );
  }

  // ============================================================
  // HSN SUMMARY
  // GET /api/sandbox/gst/gstr1/hsn?gstin=..&year=..&month=..
  // ============================================================
  static async hsn(req: Request, res: Response) {
    const params = requireCommonParams(req.query as any, res);
    
    if (params.error) return;
   
    const { gstin, year, month } = params;

    const sessionToken = await requireGstSession(gstin);
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    return ok(
      res,
      {
        gstin,
        period: `${month}-${year}`,
        hsn: [
          { hsn_sc: "8471", desc: "Computers", uqc: "NOS", qty: 10, val: 200000, txval: 200000, igst: 0, cgst: 18000, sgst: 18000, cess: 0 },
          { hsn_sc: "9983", desc: "IT Services", uqc: "NA", qty: 1, val: 50000, txval: 50000, igst: 9000, cgst: 0, sgst: 0, cess: 0 },
        ],
      },
      "GSTR-1 HSN fetched (mock)"
    );
  }

  // ============================================================
  // NIL SUPPLIES
  // GET /api/sandbox/gst/gstr1/nil?gstin=..&year=..&month=..
  // ============================================================
  static async nil(req: Request, res: Response) {
    const params = requireCommonParams(req.query as any, res);
   
    if (params.error) return;
   
    const { gstin, year, month } = params;

    const sessionToken = await requireGstSession(gstin);
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    return ok(
      res,
      {
        gstin,
        period: `${month}-${year}`,
        nil: {
          inter: { nil_amt: 10000, expt_amt: 0, ngsup_amt: 0 },
          intra: { nil_amt: 5000, expt_amt: 0, ngsup_amt: 0 },
        },
      },
      "GSTR-1 NIL supplies fetched (mock)"
    );
  }

  // ============================================================
  // DOC ISSUE
  // GET /api/sandbox/gst/gstr1/doc-issue?gstin=..&year=..&month=..
  // ============================================================
  static async docIssue(req: Request, res: Response) {
    const params = requireCommonParams(req.query as any, res);
    
    if (params.error) return;
   
    const { gstin, year, month } = params;

    const sessionToken = await requireGstSession(gstin);
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    return ok(
      res,
      {
        gstin,
        period: `${month}-${year}`,
        doc_issue: [
          { doc_num: 1, doc_typ: "Invoices for outward supply", from: 1, to: 50, totnum: 50, cancel: 2, net_issue: 48 },
          { doc_num: 2, doc_typ: "Credit Notes", from: 1, to: 5, totnum: 5, cancel: 0, net_issue: 5 },
        ],
      },
      "GSTR-1 Document Issue fetched (mock)"
    );
  }

  // ============================================================
  // AT / ATA (Advance Tax)
  // GET /api/sandbox/gst/gstr1/at?gstin=..&year=..&month=..
  // GET /api/sandbox/gst/gstr1/ata?gstin=..&year=..&month=..
  // ============================================================
  static async at(req: Request, res: Response) {
    const params = requireCommonParams(req.query as any, res);
   
    if (params.error) return;
   
    const { gstin, year, month } = params;

    const sessionToken = await requireGstSession(gstin);
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    return ok(
      res,
      {
        gstin,
        period: `${month}-${year}`,
        at: [{ pos: "23", sply_ty: "INTRA", rt: 18, ad_amt: 50000, igst: 0, cgst: 4500, sgst: 4500, cess: 0 }],
      },
      "GSTR-1 AT fetched (mock)"
    );
  }

  static async ata(req: Request, res: Response) {
    const params = requireCommonParams(req.query as any, res);
   
    if (params.error) return;
   
    const { gstin, year, month } = params;

    const sessionToken = await requireGstSession(gstin);
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    return ok(
      res,
      {
        gstin,
        period: `${month}-${year}`,
        ata: [{ pos: "23", sply_ty: "INTRA", rt: 18, ad_amt: 10000, igst: 0, cgst: 900, sgst: 900, cess: 0 }],
      },
      "GSTR-1 ATA fetched (mock)"
    );
  }

  // ============================================================
  // SAVE GSTR-1
  // POST /api/sandbox/gst/gstr1/save
  // body: { gstin, gt, cur_gt }
  // ============================================================
  static async save(req: Request, res: Response) {
    const { gstin, gt, cur_gt } = req.body || {};

    if (!gstin) return bad(res, "gstin is required in body");
    if (!validateGSTIN(String(gstin))) return bad(res, "Invalid GSTIN");

    const sessionToken = await requireGstSession(String(gstin));
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    if (typeof gt !== "number" || typeof cur_gt !== "number") {
      return bad(res, "gt and cur_gt must be numbers");
    }

    return ok(
      res,
      {
        gstin,
        reference_id: `MOCK_GSTR1_SAVE_${Date.now()}`,
        gt,
        cur_gt,
      },
      "GSTR-1 saved successfully (mock)"
    );
  }

  // ============================================================
  // FILE GSTR-1
  // POST /api/sandbox/gst/gstr1/file
  // body: { gstin }
  // ============================================================
  static async file(req: Request, res: Response) {
    const { gstin } = req.body || {};
    if (!gstin) return bad(res, "gstin is required in body");
    if (!validateGSTIN(String(gstin))) return bad(res, "Invalid GSTIN");

    const sessionToken = await requireGstSession(String(gstin));
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    return ok(
      res,
      {
        gstin,
        ack_no: `MOCK_ACK_${Math.floor(100000 + Math.random() * 900000)}`,
        filed_at: new Date().toISOString(),
      },
      "GSTR-1 filed successfully (mock)"
    );
  }

  // ============================================================
  // RESET GSTR-1 (Optional but useful for testing)
  // POST /api/sandbox/gst/gstr1/reset
  // body: { gstin }
  // ============================================================
  static async reset(req: Request, res: Response) {
    const { gstin } = req.body || {};
    if (!gstin) return bad(res, "gstin is required in body");
    if (!validateGSTIN(String(gstin))) return bad(res, "Invalid GSTIN");

    const sessionToken = await requireGstSession(String(gstin));
    if (!sessionToken) return unauth(res, "GST session not found. Please verify OTP first.");

    return ok(res, { gstin, status: "RESET_OK" }, "GSTR-1 reset done (mock)");
  }
}
