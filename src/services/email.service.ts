

import nodemailer, { Transporter, SendMailOptions } from "nodemailer";

export default class EmailService {
  private static transporter: Transporter | null = null;

  // Initialize SMTP transporter (GoDaddy - OTP Mail)
  private static async initTransporter() {
    if (this.transporter) return;

    const user = process.env.OTP_EMAIL;
    const pass = process.env.OTP_PASS;

    if (!user || !pass) {
      throw new Error("OTP Email credentials missing in .env");
    }

    // Transport is env-configurable so prod can repoint to a reachable relay
    // (e.g. if the host blocks GoDaddy's outbound SMTP and we need Gmail on 587)
    // WITHOUT a code change. Defaults keep the existing GoDaddy 465/SSL setup.
    const host = process.env.OTP_SMTP_HOST || "smtpout.secureserver.net";
    const port = Number(process.env.OTP_SMTP_PORT) || 465;
    // 465 = implicit TLS (secure:true); 587/25 = STARTTLS (secure:false).
    const secure = process.env.OTP_SMTP_SECURE
      ? process.env.OTP_SMTP_SECURE === "true"
      : port === 465;

    const transporter = nodemailer.createTransport({
      host,
      port,
      secure,
      auth: { user, pass },
      requireTLS: !secure, // enforce STARTTLS on 587/25
      // Fail fast instead of letting a blocked/hung connection sit there. The
      // OTP send is fire-and-forget, so a long hang just wastes a socket.
      connectionTimeout: 10_000,
      greetingTimeout: 10_000,
      socketTimeout: 15_000,
      tls: { servername: host },
    });

    await transporter.verify();
    console.log(`✅ OTP Email transporter verified (${host}:${port})`);

    this.transporter = transporter;
  }

  // Send OTP Mail
  public static async sendMail(
    to: string,
    subject: string,
    body: string
  ): Promise<{ success: boolean; message: string }> {
    try {
      await this.initTransporter();

      const mailOptions: SendMailOptions = {
        from: process.env.OTP_EMAIL, // ✅ FIXED
        to,
        subject,
        text: body,
      };

      await this.transporter!.sendMail(mailOptions);

      console.log("✅ OTP Email Sent Successfully");

      return { success: true, message: "Email sent successfully" };

    } catch (error) {
      console.error("❌ OTP Email sending failed:", error);
      return { success: false, message: "Email sending failed" };
    }
  }
}