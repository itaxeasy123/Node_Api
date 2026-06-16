#!/usr/bin/env bash
#
# dev_start.sh — one-command dev startup for the iTaxEasy Node API.
#
# It is idempotent: run it as often as you like. Each run will
#   1. Ensure the Postgres + Redis Docker containers (with named volumes) are up
#   2. Wait until Postgres actually accepts connections
#   3. Generate the Prisma client
#   4. Sync the DB schema (prisma db push) — only changes the DB when schema.prisma
#      differs, so this is the "is the migration up to date? if not, update it" step
#   5. Re-apply the BillShield SQL invariants (db push drops triggers/CHECKs it
#      doesn't know about, so they MUST be re-applied after every push)
#   6. Seed the database (non-fatal)
#   7. Start the Node API in dev mode
#
# Usage:  ./script-dev-start.sh        (from anywhere; it cd's to its own folder)

set -euo pipefail

# Always operate from the Node API root (this script's directory)
cd "$(dirname "$0")"

# ----------------------------- Config -----------------------------
PG_CONTAINER="itax-pg"
REDIS_CONTAINER="itax-redis"
PG_VOLUME="itax-pg-data"
REDIS_VOLUME="itax-redis-data"
PG_IMAGE="postgres:16"
REDIS_IMAGE="redis:7-alpine"
PG_PASSWORD="Akshat@1234"   # matches DATABASE_URL (Akshat%401234)
PG_DB="ITAX"
PG_PORT="53001"             # host:53001 -> container:5432 (5555 collides with the Android emulator's ADB port)
REDIS_PORT="6379"

log()  { printf "\n\033[1;34m▶ %s\033[0m\n" "$1"; }
ok()   { printf "\033[0;32m  ✓ %s\033[0m\n" "$1"; }

# --------------------------- Preflight ----------------------------
if ! command -v docker >/dev/null 2>&1; then
  echo "✗ docker is not installed or not on PATH" >&2
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo "✗ Docker daemon is not running. Start Docker Desktop and retry." >&2
  exit 1
fi

# ---------------- 1. Ensure containers are running ----------------
# Creates the container with a named volume if missing, starts it if stopped,
# leaves it alone if already running.
ensure_container() {
  local name="$1"; shift
  if docker ps --format '{{.Names}}' | grep -qx "$name"; then
    ok "$name already running"
  elif docker ps -a --format '{{.Names}}' | grep -qx "$name"; then
    docker start "$name" >/dev/null
    ok "$name started"
  else
    docker run -d --name "$name" "$@" >/dev/null
    ok "$name created"
  fi
}

log "Ensuring Docker services (Postgres + Redis)"
ensure_container "$PG_CONTAINER" \
  -e POSTGRES_PASSWORD="$PG_PASSWORD" \
  -e POSTGRES_DB="$PG_DB" \
  -p "${PG_PORT}:5432" \
  -v "${PG_VOLUME}:/var/lib/postgresql/data" \
  "$PG_IMAGE"
ensure_container "$REDIS_CONTAINER" \
  -p "${REDIS_PORT}:6379" \
  -v "${REDIS_VOLUME}:/data" \
  "$REDIS_IMAGE"

# -------------------- 2. Wait for Postgres ------------------------
log "Waiting for Postgres to accept connections"
tries=0
until docker exec "$PG_CONTAINER" pg_isready -U postgres >/dev/null 2>&1; do
  tries=$((tries + 1))
  if [ "$tries" -gt 60 ]; then
    echo "✗ Postgres did not become ready in time" >&2
    exit 1
  fi
  printf "."
  sleep 1
done
echo ""
ok "Postgres is ready"

# -------------------- 3. Prisma generate --------------------------
log "Generating Prisma client"
npx prisma generate

# ----- 4 & 5. Sync schema + re-apply BillShield invariants --------
# `npm run db` = prisma db push && billshield:invariants.
# db push diffs schema.prisma against the live DB and only applies what changed.
log "Syncing database schema + re-applying invariants"
npm run db

# -------------------------- 6. Seed -------------------------------
log "Seeding database"
if npm run seed; then
  ok "Seed complete"
else
  echo "  (seed skipped / already applied / not idempotent — continuing)"
fi

# ----------------------- 7. Start Node API ------------------------
log "Starting Node API (dev)"
exec npm run dev
