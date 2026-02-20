
import nodemailer, { Transporter, SendMailOptions } from "nodemailer";

export default class EmailService {
  private static transporter: Transporter | null = null;

  // Initialize SMTP transporter (GoDaddy)
  private static async initTransporter() {
    if (this.transporter) return;

    const user = process.env.OPT_EMAIL;
    const pass = process.env.OTP_PASS;

    if (!user || !pass) {
      throw new Error("Email credentials missing in .env");
    }

    const transporter = nodemailer.createTransport({
      host: "smtpout.secureserver.net",
      port: 465,          // ✅ GoDaddy SSL port
      secure: true,       // ✅ SSL enabled
      auth: {
        user,             // info@itaxeasy.com
        pass,             // NEW password
      },
    });

    // Verify SMTP login
    await transporter.verify();
    console.log("✅ Email transporter verified (GoDaddy SMTP)");

    this.transporter = transporter;
  }

  // Send email (OTP)
  public static async sendMail(
    to: string,
    subject: string,
    body: string
  ): Promise<{ success: boolean; message: string }> {
    try {
      await this.initTransporter();

      const mailOptions: SendMailOptions = {
        from: process.env.OPT_EMAIL, // ✅ MUST be same as SMTP user
        to,
        subject,
        text: body,
      };

      await this.transporter!.sendMail(mailOptions);

      return { success: true, message: "Email sent successfully" };
    } catch (error) {
      console.error("❌ Email sending failed:", error);
      return { success: false, message: "Email sending failed" };
    }
  }
}
