// import nodemailer from "nodemailer";

// export const transporter = nodemailer.createTransport({
//   host: process.env.EMAIL_HOST,
//   port: Number(process.env.EMAIL_PORT),
//   secure: true, // 465 use kar rahe ho
//   auth: {
//     user: process.env.EMAIL_USER,
//     pass: process.env.EMAIL_PASS,
//   },
// });

import nodemailer from "nodemailer";

const isGmail = process.env.EMAIL_USER?.includes("@gmail.com");

export const transporter = nodemailer.createTransport({
  host: isGmail ? "smtp.gmail.com" : process.env.EMAIL_HOST,
  port: isGmail ? 587 : Number(process.env.EMAIL_PORT),
  secure: isGmail ? false : true,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
  tls: {
    rejectUnauthorized: false,
  },
});