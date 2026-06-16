
// import express, { Request, Response } from "express";
// import { rateLimit } from "express-rate-limit";
// import { PrismaClient } from "@prisma/client";
// import cors from "cors";
// import helmet from "helmet";
// import cookieParser from "cookie-parser";
// import { config } from "dotenv";
// import path from "path";
// import routes from "./routes";
// import debugRoutes from "./routes/debug.routes";

// /* =======================
//    ENV CONFIG
// ======================= */
// config({
//   path: path.resolve(__dirname, "../.env"),
// });

// const PORT = Number(process.env.PORT) || 8000;

// /* =======================
//    APP + DB
// ======================= */
// export const prisma = new PrismaClient();
// const app = express();

// /* =======================
//    TRUST PROXY
// ======================= */
// app.set("trust proxy", false);

// /* =======================
//    BODY PARSERS
// ======================= */
// app.use(express.json());
// app.use(express.urlencoded({ extended: true }));

// /* =======================
//    🔥 FINAL CORS (NO ERROR)
// ======================= */

// const allowedOrigins = [
//   "http://localhost:3001",
//   "http://localhost:3000",
//   "http://localhost:5173",
// ];

// app.use(
//   cors({
//     origin: (origin, callback) => {
//       if (!origin) return callback(null, true); // Postman / server

//       if (allowedOrigins.includes(origin)) {
//         return callback(null, true);
//       }

//       console.warn("❌ Blocked by CORS:", origin);
//       return callback(null, false);
//     },
//     credentials: true,
//     methods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
//     allowedHeaders: ["Content-Type", "Authorization"],
//   })
// );

// // ✅ IMPORTANT (preflight fix)
// app.options("*", cors());

// /* =======================
//    SECURITY (FIXED)
// ======================= */
// app.use(
//   helmet({
//     crossOriginResourcePolicy: false,
//   })
// );

// app.use(cookieParser());

// /* =======================
//    RATE LIMIT
// ======================= */
// app.use(
//   rateLimit({
//     windowMs: 15 * 60 * 1000,
//     max: 600,
//     standardHeaders: true,
//     legacyHeaders: false,
//   })
// );

// /* =======================
//    STATIC FILES
// ======================= */
// app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// /* =======================
//    REQUEST LOGGER
// ======================= */
// app.use((req, res, next) => {
//   const start = Date.now();
//   res.on("finish", () => {
//     console.log(
//       `[${req.method}] ${req.url} → ${res.statusCode} (${Date.now() - start}ms)`
//     );
//   });
//   next();
// });

// /* =======================
//    DEBUG ROUTES
// ======================= */
// app.use("/debug", debugRoutes);

// /* =======================
//    HEALTH CHECK
// ======================= */
// app.get("/health", (_req, res) => {
//   res.json({ status: "OK" });
// });

// app.get("/", (_req, res) => {
//   res.json({ message: "Up and running" });
// });

// /* =======================
//    API ROUTES
// ======================= */
// app.use("/api", routes);

// /* =======================
//    GLOBAL ERROR HANDLER
// ======================= */
// app.use(
//   (err: Error, _req: Request, res: Response, _next: Function) => {
//     console.error("❌ ERROR:", err.message);

//     return res.status(500).json({
//       success: false,
//       message: err.message || "Internal Server Error",
//     });
//   }
// );

// /* =======================
//    SERVER START
// ======================= */
// app.listen(PORT, () => {
//   console.log(`🚀 Server running at http://localhost:${PORT}`);
// });

import express, { Request, Response } from "express";
import { rateLimit } from "express-rate-limit";
import { PrismaClient } from "@prisma/client";
import cors from "cors";
import helmet from "helmet";
import cookieParser from "cookie-parser";
import { config } from "dotenv";
import path from "path";
import routes from "./routes";
import debugRoutes from "./routes/debug.routes";

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
app.set("trust proxy", false);

/* =======================
   BODY PARSERS
======================= */
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/* =======================
   CORS
======================= */
const allowedOrigins = [
  // Production web
  "https://itaxeasy.com",
  "https://www.itaxeasy.com",
  // Local dev
  "http://localhost:3001",
  "http://localhost:3000",
  "http://localhost:5173",
  // Expo (Metro web + dev client)
  "http://localhost:8081",
  "http://192.168.7.15:8081",
  // Extra origins via env (comma-separated), e.g. CORS_ORIGINS="https://staging.itaxeasy.com"
  ...(process.env.CORS_ORIGINS
    ? process.env.CORS_ORIGINS.split(",").map((o) => o.trim()).filter(Boolean)
    : []),
];

// Shared options so the global middleware AND the preflight handler behave
// identically. With credentials:true the response must echo the specific
// origin and set Access-Control-Allow-Credentials: true (never "*").
const corsOptions: import("cors").CorsOptions = {
  origin: (origin, callback) => {
    if (!origin) return callback(null, true); // non-browser clients (Postman, native app, SSR)

    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }

    console.warn("❌ Blocked by CORS:", origin);
    return callback(null, false);
  },
  credentials: true,
  methods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
};

app.use(cors(corsOptions));
app.options("*", cors(corsOptions));

/* =======================
   SECURITY
======================= */
app.use(
  helmet({
    crossOriginResourcePolicy: false,
  })
);

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
   STATIC FILES (FINAL FIX)
======================= */

app.use("/uploads", express.static(path.join(process.cwd(), "uploads")));

app.use(
  "/images",
  express.static(path.join(process.cwd(), "public/images"))
);
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
   DEBUG ROUTES
======================= */
app.use("/debug", debugRoutes);

/* =======================
   HEALTH CHECK
======================= */
app.get("/health", (_req, res) => {
  res.json({ status: "OK" });
});

app.get("/", (_req, res) => {
  res.json({ message: "Up and running" });
});

/* =======================
   API ROUTES
======================= */
app.use("/api", routes);

/* =======================
   GLOBAL ERROR HANDLER
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