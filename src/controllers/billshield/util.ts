import { Response } from "express";
import { z, ZodTypeAny } from "zod";
import { BillShieldError } from "../../services/billshield/voucher.service";

/** Maps service/DB errors to HTTP responses. DB trigger violations
 *  (raised with a 'BillShield:' prefix) come back as clean 400s. */
export function handleBillShieldError(res: Response, error: unknown) {
  if (error instanceof BillShieldError) {
    return res.status(error.status).json({ success: false, message: error.message });
  }
  const message = error instanceof Error ? error.message : String(error);
  const dbMatch = message.match(/BillShield: ([^\n]*)/);
  if (dbMatch) {
    return res.status(400).json({ success: false, message: dbMatch[1].trim() });
  }
  if (message.includes("Unique constraint")) {
    return res.status(409).json({ success: false, message: "A record with the same unique value already exists" });
  }
  console.error("BillShield error:", error);
  return res.status(500).json({ success: false, message: "Internal server error" });
}

export function parseBody<S extends ZodTypeAny>(res: Response, schema: S, body: unknown): z.infer<S> | null {
  const result = schema.safeParse(body);
  if (!result.success) {
    res.status(400).json({
      success: false,
      message: "Validation failed",
      errors: result.error.issues.map((i) => ({ path: i.path.join("."), message: i.message })),
    });
    return null;
  }
  return result.data;
}

export function parseDateRange(query: any): { from?: Date; to?: Date } {
  const from = query.from ? new Date(query.from as string) : undefined;
  const to = query.to ? new Date(query.to as string) : undefined;
  if ((from && isNaN(+from)) || (to && isNaN(+to))) {
    throw new BillShieldError("Invalid from/to date");
  }
  return { from, to };
}
