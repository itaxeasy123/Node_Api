import { Response } from "express";
import { randomUUID } from "crypto";
import { prisma } from "../index";
import TokenService from "./token.service";

export const REFRESH_COOKIE = "refreshToken";
export const ACCESS_COOKIE = "authToken";

// Cookie scoped to the user routes so it's only sent to /refresh and /logout.
const REFRESH_COOKIE_PATH = "/api/user";

// Parse a JWT-style TTL ("6h", "15m", "20d", "30s") to milliseconds.
function ttlToMs(ttl: string, fallbackMs: number): number {
  const match = /^(\d+)\s*([smhd])$/.exec((ttl || "").trim());
  if (!match) return fallbackMs;
  const value = Number(match[1]);
  const unitMs: Record<string, number> = {
    s: 1000,
    m: 60 * 1000,
    h: 60 * 60 * 1000,
    d: 24 * 60 * 60 * 1000,
  };
  return value * unitMs[match[2]];
}

// httpOnly mirror of the access token for SSR / Next API routes. Its lifetime is
// derived from ACCESS_TOKEN_TTL so the cookie and JWT always expire together.
const ACCESS_COOKIE_MAX_AGE = ttlToMs(
  process.env.ACCESS_TOKEN_TTL || "15m",
  15 * 60 * 1000
);

function refreshCookieOptions() {
  const isProd = process.env.NODE_ENV === "production";
  return {
    httpOnly: true,
    secure: isProd, // HTTPS-only in production
    sameSite: "lax" as const, // same-site (localhost / *.itaxeasy.com); use "none" if truly cross-site
    path: REFRESH_COOKIE_PATH,
    maxAge: TokenService.REFRESH_TTL_DAYS * 24 * 60 * 60 * 1000,
  };
}

export default class AuthService {
  // Create a DB-backed refresh-token row + signed refresh JWT for a user.
  static async issueRefreshToken(userId: number): Promise<string> {
    const expiresAt = new Date(
      Date.now() + TokenService.REFRESH_TTL_DAYS * 24 * 60 * 60 * 1000
    );
    const row = await prisma.refreshToken.create({
      data: { id: randomUUID(), userId, expiresAt },
    });
    return TokenService.generateRefreshToken({ id: userId, jti: row.id });
  }

  // Rotate: revoke the used token, issue a fresh one.
  static async rotateRefreshToken(
    oldJti: string,
    userId: number
  ): Promise<string> {
    await prisma.refreshToken.update({
      where: { id: oldJti },
      data: { revoked: true },
    });
    return AuthService.issueRefreshToken(userId);
  }

  static async revokeToken(jti: string): Promise<void> {
    await prisma.refreshToken
      .update({ where: { id: jti }, data: { revoked: true } })
      .catch(() => undefined);
  }

  // Breach response: kill every active session for a user.
  static async revokeAllForUser(userId: number): Promise<void> {
    await prisma.refreshToken.updateMany({
      where: { userId, revoked: false },
      data: { revoked: true },
    });
  }

  static setRefreshCookie(res: Response, token: string) {
    res.cookie(REFRESH_COOKIE, token, refreshCookieOptions());
  }

  static clearRefreshCookie(res: Response) {
    res.clearCookie(REFRESH_COOKIE, { path: REFRESH_COOKIE_PATH });
  }

  static setAccessCookie(res: Response, token: string) {
    res.cookie(ACCESS_COOKIE, token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      path: "/",
      maxAge: ACCESS_COOKIE_MAX_AGE,
    });
  }

  static clearAccessCookie(res: Response) {
    res.clearCookie(ACCESS_COOKIE, { path: "/" });
  }
}
