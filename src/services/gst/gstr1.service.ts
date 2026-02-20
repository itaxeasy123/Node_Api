export const fileGSTR1 = async (payload: {
  gstin: string;
  returnPeriod: string;
  data: any;
}) => {
  if (process.env.GST_MODE === "MOCK_SANDBOX") {
    return {
      status_cd: "1",
      status: "SUCCESS",
      ack_no: "SBXGSTR1ACK123456",
      ret_period: payload.returnPeriod,
      gstin: payload.gstin,
      message: "GSTR-1 filed successfully (sandbox simulation)",
    };
  }

  // 🔒 REAL SANDBOX (future)
  throw new Error("Sandbox not enabled");
};
