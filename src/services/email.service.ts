

import nodemailer, { Transporter, SendMailOptions } from "nodemailer";

export default class EmailService {
  private static transporter: Transporter | null = null;

  // Initialize SMTP transporter (GoDaddy - OTP Mail)
  private static async initTransporter() {
    if (this.transporter) return;

    const user = process.env.OTP_EMAIL;   // ✅ FIXED
    const pass = process.env.OTP_PASS;    // ✅ CORRECT

    if (!user || !pass) {
      throw new Error("OTP Email credentials missing in .env");
    }

    const transporter = nodemailer.createTransport({
      host: "smtpout.secureserver.net",
      port: 465,
      secure: true,
      auth: {
        user,
        pass,
      },
    });

    await transporter.verify();
    console.log("✅ OTP Email transporter verified (GoDaddy)");

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