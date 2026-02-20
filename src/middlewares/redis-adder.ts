import { Request, Response, NextFunction } from 'express';
import { createClient } from 'redis';
import { config } from 'dotenv';
import path from 'path';


// Load environment variables from .env file
config({
  path: path.resolve(__dirname, "../../.env"),
});

// Create Redis client only when enabled and configured. If Redis is disabled or not configured,
// provide a noop client to avoid throwing errors and to keep the rest of the code working.
const REDIS_ENABLED = process.env.REDIS_ENABLED !== 'false';
let redisAvailable = false;
// Minimal Redis-like interface used by this project
type RedisLike = {
  isOpen: boolean;
  exists: (key: string) => Promise<number>;
  set: (key: string, value: string, opts?: { EX?: number }) => Promise<string | null>;
  get: (key: string) => Promise<string | null>;
};

let client: RedisLike;

if (REDIS_ENABLED && process.env.REDIS_HOST) {
  // createClient returns a redis client compatible with the methods below
  // we keep `client` typed as RedisLike for callers in this codebase
  // Build client options carefully: omit `username` when not provided
  // because some Redis servers expect `AUTH <password>` (single-arg).
  // use a loose options type; keep it typed as Record to avoid `any` lint
  const clientOptions: Record<string, unknown> = {};
  if (process.env.REDIS_URL) {
    clientOptions.url = process.env.REDIS_URL;
  } else {
    clientOptions.socket = {
      host: process.env.REDIS_HOST,
      port: Number(process.env.REDIS_PORT),
    };
    if (process.env.REDIS_PASSWORD) clientOptions.password = process.env.REDIS_PASSWORD;
    if (process.env.REDIS_USERNAME) clientOptions.username = process.env.REDIS_USERNAME;
  }

  client = createClient(clientOptions) as unknown as RedisLike;

  // Log only the first error to avoid flooding the terminal
  let redisErrorLogged = false;
  let redisConnectedLogged = false;
  // The real redis client exposes `on` and `connect` — we access them
  // via the underlying object but keep the external type as RedisLike.
  // @ts-expect-error - runtime client has these methods
  client.on('error', (err: Error) => {
    const msg = String(((err as Error) && (err as Error).message) || '').toLowerCase();
    const name = String(((err as Error) && (err as Error).name) || '').toLowerCase();
    const isTimeout = msg.includes('connection timeout') || name.includes('connectiontimeouterror') || msg.includes('timed out');
    if (isTimeout) {
      console.warn('Redis connection timeout (will retry)');
      return; // don't mark as a logged fatal error — retries may succeed
    }
    if (!redisErrorLogged) {
      console.error('Redis Client Error:', err);
      redisErrorLogged = true;
    }
  });
  // @ts-expect-error - redis client has 'on' event at runtime
  client.on('connect', () => {
    if (!redisConnectedLogged) {
      console.log('Redis connected successfully');
      redisConnectedLogged = true;
    }
    redisAvailable = true;
  });

  // Attempt connection; if it fails, mark unavailable but don't exit
  // @ts-expect-error - redis client has 'connect' method at runtime
  client.connect().catch((err: Error) => {
    const msg = String(((err as Error) && (err as Error).message) || '').toLowerCase();
    const name = String(((err as Error) && (err as Error).name) || '').toLowerCase();
    const isTimeout = msg.includes('connection timeout') || name.includes('connectiontimeouterror') || msg.includes('timed out');
    if (isTimeout) {
      console.warn('Redis connect attempt timed out; will retry in background');
      // leave redisErrorLogged as-is so we can still log other errors later
    } else {
      if (!redisErrorLogged) {
        console.error('Failed to connect to Redis:', err);
        redisErrorLogged = true;
      }
    }
    // don't override a successful connect if it happened concurrently
    if (!redisConnectedLogged) redisAvailable = false;
  });
} else {
  // No Redis configured or explicitly disabled — provide a noop client
  redisAvailable = false;
  client = {
    isOpen: false,
    exists: async () => 0,
    set: async () => 'OK',
    get: async () => null,
  } as RedisLike;
}

// Rate-limiting middleware
const strictLimiter = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = req.user; // Assumes authentication middleware populates `req.user`
const payload = Object.keys(req.body || {}).length ? req.body : req.query;
const {
  pan, aadhaar, tan, gstin, ifsc, gst, aadhar, gstn, gstr
} = payload;

console.log("🚀 ~ strictLimiter ~ payload:", payload);

    if (!req.url) {
      return res.status(400).json({ message: 'URL is missing.' });
    }

    if (!user) {
      return res.status(400).json({ message: 'User is missing.' });
    }

    // Determine the identifier type and value
    let identifierType: string | null = null;
    let identifierValue: string | null = null;

    if (pan) {
      identifierType = 'PAN';
      identifierValue = pan;
    } 
    else if(gstr){
      identifierType = 'GSTR';
      identifierValue = gstr;
    }else if (aadhaar) {
      identifierType = 'AADHAAR';
      identifierValue = aadhaar;
    }
    else if(aadhar){
      identifierType = 'AADHAR';
      identifierValue = aadhar;
    } else if (tan) {
      identifierType = 'TAN';
      identifierValue = tan;
    } else if (gstin) {
      identifierType = 'GSTIN';
      identifierValue = gstin;
    }
    else if(gstn){
      identifierType = 'GSTN';
      identifierValue = gstn;
    } else if (ifsc){
      identifierType = 'IFSC';
      identifierValue = ifsc;
    }
    else if(gst){
      identifierType = 'GST';
      identifierValue  = gst;
    }
    else {
      return res.status(400).json({ message: 'No valid identifier provided.' });
    }

    // Get the URL and replace slashes with dashes
    const formattedUrl = req.url.replace(/\//g, '-');

    // Create a Redis key using user ID, identifier type, value, and formatted URL
    const redisKey = `${user.id}:${identifierType}:${identifierValue}:${formattedUrl}`;

    // If Redis is unavailable, skip rate-limiting and continue
    if (!redisAvailable || !client.isOpen) {
      console.warn('Redis not available; skipping strictLimiter checks');
      return next();
    }

    // Check if the identifier already exists in Redis
    const exists = await client.exists(redisKey);

    // If the key exists, return a 429 status code
    if (exists) {
      return res.status(429).json({
        message: `You can only check this ${identifierType} number (${identifierValue}) for ${formattedUrl} again after 3 minutes.`,
      });
    }

    // Store the identifier in Redis with a TTL of 3 minutes
    await client.set(redisKey, 'checked', {
      EX: 180, // Expiration time in seconds
    });

    next(); // Proceed to the next middleware or route handler
  } catch (error) {
    console.error('Redis Error:', error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};
// Export a typed, non-nullable redisClient wrapper so consumers don't need
// to guard against `null` at every call site. We expose the minimal methods
// used across the codebase (`get`, `set`, `exists`, and `isOpen`).
export const redisClient: RedisLike = client;
export default strictLimiter;
