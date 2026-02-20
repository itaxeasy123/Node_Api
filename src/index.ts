
import express, {Request, Response } from "express";
import { rateLimit } from "express-rate-limit";
import { PrismaClient } from "@prisma/client";
import cors from "cors";
import helmet from "helmet";
import cookieParser from "cookie-parser";
import { config } from "dotenv";
import path from "path";
// import router from "./routes";
import debugRoutes from "./routes/debug.routes";
import routes from "./routes";


/* =======================
   ENV CONFIG
======================= */
config({
  path: path.resolve(__dirname, "../.env"),
});

const PORT = Number(process.env.PORT) || 8000;

/* =======================
   APP + DB
======================= */
export const prisma = new PrismaClient();
const app = express();

/* =======================
   TRUST PROXY
======================= */
    // app.set("trust proxy", true);
app.set("trust proxy", false);

/* =======================
   BODY PARSERS
======================= */
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/* =======================
   CORS (FIXED)
======================= */
const allowedOrigins = [
  process.env.CLIENT_URL,
  "http://localhost:3000",
  "http://localhost:3001",
  "https://itaxeasy.com",
  "https://itaxeasy-chi.vercel.app",
  "https://itax-ssr.vercel.app",
].filter(Boolean);
app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin) return callback(null, true);

      if (allowedOrigins.includes(origin)) {
        return callback(null, true);
      }

      return callback(
        new Error(`CORS blocked for origin: ${origin}`)
      );
    },
    credentials: true,
  })
);

app.use(cookieParser());
app.options("*", cors());

/* =======================
   SECURITY
======================= */
app.use(helmet());
app.use(cookieParser());

/* =======================
   RATE LIMIT
======================= */
app.use(
  rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 600,
    standardHeaders: true,
    legacyHeaders: false,
  })
);

/* =======================
   STATIC FILES
======================= */
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

/* =======================
   REQUEST LOGGER
======================= */
app.use((req, res, next) => {
  const start = Date.now();
  res.on("finish", () => {
    console.log(
      `[${req.method}] ${req.url} → ${res.statusCode} (${Date.now() - start}ms)`
    );
  });
  next();
});

/* =======================
   GST MODE LOG (IMPORTANT)
======================= */
app.use("/debug", debugRoutes);

console.log("✅ GST_MODE:", process.env.GST_MODE);


// Health
app.get("/health", (_req, res) => {
  res.json({ status: "OK" });
});

/* =======================
   ROUTES (FIXED)
======================= */
// app.use("/", router);
// app.use("/api", router);
app.use("/api", routes);
/* =======================
   HEALTH CHECK
======================= */
app.get("/", (_req, res) => {
  res.json({ message: "Up and running" });
});

/* =======================
   GLOBAL ERROR HANDLER
======================= */
/* =======================
   GLOBAL ERROR HANDLER (FIXED)
======================= */
app.use(
  (err: Error, _req: Request, res: Response, _next: Function) => {
    console.error("❌ ERROR:", err.message);
    return res.status(500).json({
      success: false,
      message: err.message || "Internal Server Error",
    });
  }
);


/* =======================
   SERVER START
======================= */
app.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
});


