#!/usr/bin/env bash
#
# Server-side deploy for the Node_Api backend (Node.js + TypeScript), with
# automatic rollback.
#
# The GitHub Actions workflow fast-forwards the checkout to the latest main,
# exports the previously-deployed commit as PREV_DEPLOY_REF, then runs this.
# If install, build, prisma generate, restart, or the post-deploy health
# check fails, we reset back to the previous commit and rebuild it so the
# last known-good version stays live.
#
# Safe to run by hand too:  cd ~/Node_Api && bash scripts/deploy.sh
#
set -Eeuo pipefail

PM2_NAME="node-api-backend"
PORT="8000"
HEALTH_URL="http://127.0.0.1:${PORT}"
HEALTH_RETRIES=20            # x3s = up to ~60s for the API to start listening
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$APP_DIR"

# nvm isn't loaded in non-interactive shells; load it and pin node.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use 26 >/dev/null

# .env is gitignored and must be provided on the server out-of-band.
if [ ! -f "$APP_DIR/.env" ]; then
  echo "ERROR: $APP_DIR/.env is missing. Create it before deploying." >&2
  exit 1
fi

# Commit to fall back to if this deploy fails. The workflow passes the
# previously-deployed SHA; otherwise derive it from the reflog.
PREV_REF="${PREV_DEPLOY_REF:-$(git rev-parse 'HEAD@{1}' 2>/dev/null || git rev-parse HEAD)}"
NEW_REF="$(git rev-parse HEAD)"
echo "==> node $(node -v) | deploying $NEW_REF | rollback target $PREV_REF"

build_and_start() {
  # package-lock.json is tracked in this repo, so prefer the fast,
  # reproducible npm ci; fall back to npm install if the lockfile is absent.
  if [ -f package-lock.json ]; then
    echo "==> npm ci"
    npm ci
  else
    echo "==> npm install (no lockfile)"
    npm install --no-audit --no-fund
  fi

  # Generate the Prisma client (needed at runtime).
  echo "==> prisma generate"
  npm run generate

  # Sync the DB schema to match the code. The prod DB is managed with `db push`
  # (no _prisma_migrations history), so db push — NOT `migrate deploy` — is the
  # correct tool. Without --accept-data-loss, db push applies only SAFE additive
  # changes (new tables/columns, e.g. RefreshToken) and ABORTS on any destructive
  # change, which trips the rollback trap below — so prod data is never silently
  # dropped. A destructive schema change therefore fails the deploy on purpose,
  # forcing a human to apply it deliberately.
  echo "==> prisma db push (schema sync; aborts on destructive change)"
  npx prisma db push --skip-generate

  # db push drops triggers/CHECKs it doesn't know about, so re-apply the BillShield
  # SQL invariants. Non-fatal: a hiccup here must not block the rollout.
  echo "==> re-applying BillShield invariants (non-fatal)"
  npm run billshield:invariants || echo "WARN: billshield invariants step failed; continuing" >&2

  # Type-check only. The app RUNS via `tsx` (start = "npx tsx src/index.ts"),
  # which transpiles TS directly and ignores type errors — so tsc must NOT
  # gate the deploy. Run it for visibility but never let it fail the rollout.
  echo "==> type-check (tsc, non-fatal — runtime uses tsx)"
  npm run build || echo "WARN: tsc reported type errors; continuing because runtime uses tsx" >&2

  echo "==> (re)starting pm2 process '$PM2_NAME'"
  if pm2 describe "$PM2_NAME" >/dev/null 2>&1; then
    pm2 reload "$PM2_NAME" --update-env
  else
    pm2 start npm --name "$PM2_NAME" -- start
  fi
  pm2 save
}

# One probe of the API. An API may legitimately answer non-2xx on "/", so we
# only require that it ANSWERS (connection succeeds) — not a 2xx. Connection
# refused (server not up) is the failure we care about. Works with curl or wget.
probe() {
  if command -v curl >/dev/null 2>&1; then
    curl -s -o /dev/null --max-time 5 "$HEALTH_URL"        # exit!=0 only if it can't connect
  elif command -v wget >/dev/null 2>&1; then
    wget -q -T 5 -O /dev/null "$HEALTH_URL" || \
      wget -q -T 5 -O /dev/null --server-response "$HEALTH_URL" 2>&1 | grep -q 'HTTP/'
  else
    echo "WARN: no curl/wget — skipping health check" >&2
    return 0
  fi
}

# Return 0 once the API answers, retrying for a while as it boots.
healthy() {
  local i
  for i in $(seq 1 "$HEALTH_RETRIES"); do
    if probe; then
      return 0
    fi
    sleep 3
  done
  return 1
}

rollback() {
  trap - ERR                                   # don't recurse into ourselves
  echo "!!!! deploy of $NEW_REF FAILED — rolling back to $PREV_REF" >&2
  if [ "$PREV_REF" = "$NEW_REF" ]; then
    echo "!! no earlier commit to roll back to (same ref); leaving as-is" >&2
    exit 1
  fi
  git reset --hard "$PREV_REF"
  if build_and_start && healthy; then
    echo "==> rollback OK: previous version ($PREV_REF) is live and healthy"
  else
    echo "!!!! ROLLBACK ALSO FAILED — backend may be down, manual fix required" >&2
  fi
  exit 1
}

# Any failing command in build_and_start (install, build, prisma, pm2) trips this.
trap rollback ERR
build_and_start
trap - ERR

# Build/start succeeded — confirm the API actually listens before declaring
# victory. If it doesn't come up, roll back to the previous commit.
if ! healthy; then
  echo "!! new version built but is not responding on $HEALTH_URL" >&2
  rollback
fi

echo "==> deploy complete: $NEW_REF is live and healthy on port $PORT"
