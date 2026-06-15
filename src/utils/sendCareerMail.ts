// import nodemailer from "nodemailer";
// import { Express } from "express";

// export const sendCareerMail = async (
//   careerData: any,
//   file: Express.Multer.File
// ) => {
//   const transporter = nodemailer.createTransport({
//     host: process.env.EMAIL_HOST,
//     port: Number(process.env.EMAIL_PORT),
//     secure: true,
//     auth: {
//       user: process.env.EMAIL_USER,
//       pass: process.env.EMAIL_PASS,
//     },
//   });

//   await transporter.sendMail({
//     from: `"iTaxEasy Career" <${process.env.EMAIL_USER}>`,
//     to: "info@itaxeasy.com",
//     subject: `New Career Application - ${careerData.name}`,
//     html: `
//       <h2>New Career Application</h2>
//       <p><strong>Name:</strong> ${careerData.name}</p>
//       <p><strong>Email:</strong> ${careerData.email}</p>
//       <p><strong>Mobile:</strong> ${careerData.mobile}</p>
//       <p><strong>Gender:</strong> ${careerData.gender}</p>
//       <p><strong>Skills:</strong> ${careerData.skills}</p>
//       <p><strong>Address:</strong> ${careerData.address}</p>
//       <p><strong>PIN:</strong> ${careerData.pin}</p>
//     `,
//     attachments: [
//       {
//         filename: file.originalname,
//         content: file.buffer,
//         contentType: file.mimetype,
//       },
//     ],
//   });
// };
import { transporter } from "./mailer";
import { Express } from "express";

export const sendCareerMail = async (
  careerData: any,
  file: Express.Multer.File
) => {
  try {

    // SMTP verify (optional but safe)
    await transporter.verify();

    await transporter.sendMail({
      from: `"iTaxEasy Career" <${process.env.EMAIL_USER}>`,
      to: process.env.EMAIL_USER, // Gmail receive mail here
      subject: `New Career Application - ${careerData.name}`,
      html: `
        <h2>New Career Application</h2>
        <p><strong>Name:</strong> ${careerData.name}</p>
        <p><strong>Email:</strong> ${careerData.email}</p>
        <p><strong>Mobile:</strong> ${careerData.mobile}</p>
        <p><strong>Gender:</strong> ${careerData.gender}</p>
        <p><strong>Skills:</strong> ${careerData.skills}</p>
        <p><strong>Address:</strong> ${careerData.address}</p>
        <p><strong>PIN:</strong> ${careerData.pin}</p>
      `,
      attachments: file
        ? [
            {
              filename: file.originalname,
              content: file.buffer,
              contentType: file.mimetype,
            },
          ]
        : [],
    });

    console.log("✅ Career Email Sent Successfully");

  } catch (error) {
    console.error("❌ Career Email Error:", error);
    throw error;
  }
};