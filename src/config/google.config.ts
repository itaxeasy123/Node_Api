import { google } from "googleapis";
import { config } from "dotenv";
config();


const oauth2Client = new google.auth.OAuth2(
  process.env.YOUR_CLIENT_ID,
  process.env.YOUR_CLIENT_SECRET,
  process.env.YOUR_REDIRECT_URL
);

const scopes = [
  "https://www.googleapis.com/auth/blogger",
  "https://www.googleapis.com/auth/drive",
  "https://www.googleapis.com/auth/userinfo.email",
  "https://www.googleapis.com/auth/userinfo.profile"
];

const drive = google.drive(
  {
    version: "v3",
    auth: oauth2Client
  }
)


export { oauth2Client, scopes, drive };