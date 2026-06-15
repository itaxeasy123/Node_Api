// import { Request, Response } from "express";
// import { prisma } from "../index";
// import { ContactUs } from "@prisma/client";

// export class ContactUsController {
//   static async contactUs(req: Request, res: Response): Promise<void> {
//     try {
//       const { name, email, message } = req.body;

//       // Validation: Name should only contain characters
//       if (!/^[A-Za-z\s]+$/.test(name)) {
//         res.status(400).json({ error: "Invalid name format" });
//         return;
//       }

//       // Validation: Phone number should be numeric and have a maximum length of 10
//       // if (!/^\d{10}$/.test(phoneNumber)) {
//       //   res.status(400).json({ error: "Invalid phone number format" });
//       //   return;
//       // }

//       // Validation: Email format
//       if (!/^\S+@\S+\.\S+$/.test(email)) {
//         res.status(400).json({ error: "Invalid email format" });
//         return;
//       }

//       const newContactUs: ContactUs = await prisma.contactUs.create({
//         data: {
//           name,
//           email,
//           message,
//         },
//       });
//       res.status(201).json({
//         result: newContactUs,
//         message: "Sucessfull Contact us registerd",
//       });
//     } catch (error) {
//       res.status(500).json({
//         success: false,
//         message: "Internal server error",
//         errors: error,
//       });
//     }
//   }

//   static async findAllContactUs(req: Request, res: Response): Promise<void> {
//     try {
//       const allContactUs = await prisma.contactUs.findMany({});

//       res.status(200).json({ success: true, allContactUs });
//     } catch (error) {
//       res.status(500).json({
//         success: false,
//         message: "Internal server error",
//         errors: error,
//       });
//     }
//   }

//   static async getById(req: Request, res: Response): Promise<void> {
//     try {
//       const { id } = req.params;

//       // Get the invoice by ID
//       const Contact: ContactUs | null = await prisma.contactUs.findUnique({
//         where: { id: parseInt(id) },
//       });

//       if (!Contact) {
//         res
//           .status(404)
//           .json({ sucess: false, message: "Contact us not found" });
//         return;
//       }

//       res.status(200).json(Contact);
//     } catch (error) {
//       res.status(500).json({ sucess: false, message: "Internal server error" });
//     }
//   }

//   static async delete(req: Request, res: Response): Promise<void> {
//     try {
//       const { id } = req.params;
//       const deletedContactUs = await prisma.contactUs.delete({
//         where: { id: parseInt(id) },
//       });
//       res.status(200).json({
//         success: true,
//         deletedContactUs,
//         message: "Contact us deleted sucessfully",
//       });
//     } catch (error) {
//       console.log(error);
//       res
//         .status(500)
//         .json({ success: false, message: "Internal server error" });
//     }
//   }
// }

import { Request, Response } from "express";
import { prisma } from "../index";
import { ContactUs } from "@prisma/client";
import nodemailer from "nodemailer";

export class ContactUsController {
  static async contactUs(req: Request, res: Response): Promise<void> {
    try {
      // ✅ form-data parsing fix
      const name = req.body.name?.trim();
      const email = req.body.email?.trim();
      const message = req.body.message?.trim();
      const subject = req.body.subject?.trim();
      const file = req.file;

      // ✅ validation
      if (!name || !/^[A-Za-z\s]+$/.test(name)) {
        res.status(400).json({ error: "Invalid name format" });
        return;
      }

      if (!email || !/^\S+@\S+\.\S+$/.test(email)) {
        res.status(400).json({ error: "Invalid email format" });
        return;
      }

      if (!message) {
        res.status(400).json({ error: "Message is required" });
        return;
      }

      // ✅ DB save
      const newContactUs: ContactUs = await prisma.contactUs.create({
        data: {
          name,
          email,
          message,
        },
      });

      // ✅ EMAIL SETUP
      const transporter = nodemailer.createTransport({
        host: process.env.EMAIL_HOST,
        port: Number(process.env.EMAIL_PORT),
        secure: false,
        auth: {
          user: process.env.EMAIL_USER,
          pass: process.env.EMAIL_PASS,
        },
      });

      // ✅ SEND MAIL
      await transporter.sendMail({
        from: process.env.EMAIL_USER,
        to: process.env.EMAIL_USER,
        subject: `📩 New Contact Form: ${subject || "No Subject"}`,
        html: `
          <h2>New Contact Submission</h2>
          <p><b>Name:</b> ${name}</p>
          <p><b>Email:</b> ${email}</p>
          <p><b>Subject:</b> ${subject}</p>
          <p><b>Message:</b> ${message}</p>
        `,
        attachments: file
          ? [
              {
                filename: file.originalname,
                content: file.buffer,
              },
            ]
          : [],
      });

      res.status(201).json({
        message: "✅ Message sent & email received successfully",
        data: newContactUs,
      });
    } catch (error) {
      console.error("CONTACT ERROR:", error);
      res.status(500).json({
        success: false,
        message: "Internal server error",
      });
    }
  }

  static async findAllContactUs(req: Request, res: Response) {
    const data = await prisma.contactUs.findMany();
    res.json(data);
  }

  static async getById(req: Request, res: Response) {
    const data = await prisma.contactUs.findUnique({
      where: { id: Number(req.params.id) },
    });
    res.json(data);
  }

  static async delete(req: Request, res: Response) {
    await prisma.contactUs.delete({
      where: { id: Number(req.params.id) },
    });
    res.json({ message: "Deleted" });
  }
}