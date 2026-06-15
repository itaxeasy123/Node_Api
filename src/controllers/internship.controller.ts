import { Request, Response } from "express";
import { transporter } from "../utils/mailer";

export const submitInternship = async (req: Request, res: Response) => {
  try {
    const {
      name,
      email,
      phone,
      education,
      role,
      skills,
      portfolio,
      address,
    } = req.body;

    if (!name || !email || !phone || !role) {
      return res.status(400).json({
        success: false,
        message: "Missing required fields",
      });
    }

    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: "Resume PDF required",
      });
    }

    if (req.file.mimetype !== "application/pdf") {
      return res.status(400).json({
        success: false,
        message: "Only PDF allowed",
      });
    }

    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: process.env.EMAIL_USER,
      subject: `Internship Application - ${name}`,
      html: `
        <h2>New Internship Application</h2>
        <p><b>Name:</b> ${name}</p>
        <p><b>Email:</b> ${email}</p>
        <p><b>Phone:</b> ${phone}</p>
        <p><b>Education:</b> ${education}</p>
        <p><b>Role:</b> ${role}</p>
        <p><b>Skills:</b> ${skills}</p>
        <p><b>Portfolio:</b> ${portfolio}</p>
        <p><b>Address:</b> ${address}</p>
      `,
      attachments: [
        {
          filename: req.file.originalname,
          content: req.file.buffer,
        },
      ],
    });

    return res.json({ success: true });
  } catch (error) {
    console.error("Internship error:", error);
    return res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};