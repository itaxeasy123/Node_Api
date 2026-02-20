<!-- .github/copilot-instructions.md - guidance for AI coding agents -->
# Copilot Instructions — Node_API_V-master

Purpose: Help AI coding agents be immediately productive in this codebase by documenting the architecture, developer workflows, conventions, and concrete examples.

- **Project type:** Node.js + TypeScript REST API using Express and Prisma (`@prisma/client`). Main entry: `src/index.ts`.
- **Build / Run:**
  - Development: `npm run dev` (uses `nodemon --exec ts-node --files src/index.ts`).
  - Build: `npm run build` (runs `tsc --build` → outputs to `dist`).
  - Start (prod-like): `npm start` (runs `npx tsx src/index.ts`).
  - Prisma: `npm run generate` and `npm run db` for pushing/generating client.
  - Note: Sharp installation (native deps) requires special handling documented in `README.md` — install dependencies using Node 16, run `npm install`, then `npm install --include=optional sharp`.

- **Environment:** `.env` file expected at repository root. `src/index.ts` uses `path.resolve(__dirname, "../.env")` to load it.

- **Architecture (Big Picture):**
  - `src/index.ts`: app bootstrap — Express, middlewares (CORS, helmet, cookie parser, rate limiter), global logging, and router mount.
  - `src/routes/`: central routing composition (`src/routes/index.ts`) — loads per-resource routers (`*.routes.ts`) and applies middleware like `verify-token` and `strictLimiter` for specific routes.
  - `src/controllers/`: handler functions for HTTP endpoints (one controller per domain/resource, e.g. `invoice.controller.ts`, `user.controller.ts`). Controllers call into services or directly use `prisma`.
  - `src/services/`: business logic helpers (where present) — prefer adding reusable logic here rather than in controllers.
  - `src/lib/`: shared utilities and config (e.g. `cloudinary.ts`, `config.ts`, `util.ts`).
  - `src/middlewares/`: auth, validation, file upload and rate-limiting helpers (e.g. `verify-token.ts`, `redis-adder.ts`, `multer.middleware.ts`).
  - `prisma/`: schema and migrations. Use Prisma CLI commands from `package.json`.

- **Key Conventions & Patterns:**
  - Filenames: `*.routes.ts`, `*.controller.ts`, middleware files in `src/middlewares/`.
  - Route registration: Add new router under `src/routes/` and register it in `src/routes/index.ts` (see existing examples such as `/invoice`, `/gst`, `/pan`).
  - Auth: protect endpoints by using `verify-token` middleware when registering route (e.g. `router.use('/pan', verifyToken, panRouter)`).
  - Rate limiting: some sandbox or costly routes use `strictLimiter` (backed by Redis via `src/middlewares/redis-adder`). If adding expensive or public endpoints, consider applying `strictLimiter`.
  - Database: Use Prisma client. The application creates `prisma` in `src/index.ts` (`export const prisma = new PrismaClient();`) — prefer importing the existing client where practical to avoid multiple instances.
  - Logging: index has a small request-timing logger middleware; preserve this pattern when adding or refactoring middleware.

- **Platform / Node notes:**
  - `package.json` uses an `engines` constraint: `node >=18.17 <=22`. However, the `README.md` documents installing dependencies with Node 16 first (sharp native modules). Follow README steps for local environment setup.
  - `scripts.build:linux` uses `rm -rf` (POSIX). On Windows use Git Bash, WSL, or adapt command to PowerShell.

- **Quick, concrete examples:**
  - Add a new resource `foo`:
    1. Create `src/controllers/foo.controller.ts` exporting handlers: `getFoo`, `createFoo`.
    2. Create `src/routes/foo.routes.ts` that exports an Express `Router` wired to the controller.
    3. Register route in `src/routes/index.ts`: `import fooRouter from './foo.routes';` then `router.use('/foo', fooRouter);`.
    4. If the endpoints need authentication, add `verifyToken` to the route registration.

  - Use Prisma client: import from `src/index.ts` (if appropriate) or create a separate Prisma client instance only when necessary. Example usage in a controller:
    ```ts
    import { prisma } from '../index';

    export const getItems = async (req, res) => {
      const items = await prisma.item.findMany();
      return res.json(items);
    };
    ```

- **Common developer workflows:**
  - Install: use Node 16 for initial `npm install` (sharp), then switch to Node 18+ as per `engines`.
  - Run locally: `npm run dev` for live TypeScript development.
  - Build for production: `npm run build` then run the compiled code (or use `npm start` which runs TypeScript via `tsx`).
  - Database changes: modify `prisma/schema.prisma`, then run `npm run generate` and `npm run db` (or use Prisma Migrate flows in CI if applicable).

- **Files to consult when coding:**
  - `src/index.ts` (app bootstrap and middleware ordering)
  - `src/routes/index.ts` (route composition and protected endpoints)
  - `src/middlewares/` (auth, redis limiter, validation)
  - `src/controllers/` (existing patterns for controllers)
  - `src/lib/config.ts` (app-level configuration patterns)
  - `prisma/schema.prisma` and `prisma/migrations/` (data model and migration history)

- **What *not* to change without asking:**
  - Global `prisma` instantiation pattern in `src/index.ts` (changing how Prisma is created affects many controllers).
  - CORS origin list in `src/index.ts` — changes can break clients.
  - Sharp-related install steps or Node-version handling — follow README guidance.

If anything here is unclear or you want more examples (e.g. a sample controller + route PR), tell me which part to expand or which files you want me to analyze next.
