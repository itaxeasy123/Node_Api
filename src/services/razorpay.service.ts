import Razorpay from "razorpay";

export function getRazorpayInstance() {
  const key_id = process.env.RZP_KEY_ID;
  const key_secret = process.env.RZP_KEY_SECRET;

  if (!key_id || !key_secret) {
    throw new Error("Razorpay keys missing in .env");
  }

  return new Razorpay({
    key_id,
    key_secret,
  });
}