#!/usr/bin/env bash
#
# dev_stop.sh — counterpart to dev_start.sh. Cleanly tears down the local
# dev environment for the iTaxEasy Node API.
#
# By default it:
#   1. Stops the running Node API dev process (nodemon / ts-node) for THIS repo
#   2. Stops the Postgres + Redis Docker containers (data is kept in the named
#      volumes, so `./dev_start.sh` brings everything back exactly as it was)
#
# Flags:
#   --rm        Also remove the stopped containers (named volumes are KEPT, so
#               no data is lost — dev_start.sh recreates the containers).
#   --wipe      Remove the containers AND delete the named data volumes.
#               DESTRUCTIVE: wipes the local Postgres DB. Asks for confirmation.
#   --keep-node Leave the Node dev process running; only touch the containers.
#   -h, --help  Show this help.
#
# Usage:  ./dev_stop.sh            (from anywhere; it cd's to its own folder)

set -euo pipefail

# Always operate from the Node API root (this script's directory)
cd "$(dirname "$0")"

# ----------------------------- Config -----------------------------
# Keep these in sync with dev_start.sh.
PG_CONTAINER="itax-pg"
REDIS_CONTAINER="itax-redis"
PG_VOLUME="itax-pg-data"
REDIS_VOLUME="itax-redis-data"

# Pattern that uniquely identifies this repo's dev server process.
NODE_MATCH="ts-node/register/transpile-only src/index.ts"

log()  { printf "\n\033[1;34m▶ %s\033[0m\n" "$1"; }
ok()   { printf "\033[0;32m  ✓ %s\033[0m\n" "$1"; }
info() { printf "\033[0;90m  · %s\033[0m\n" "$1"; }

# --------------------------- Arg parse ----------------------------
DO_RM=false
DO_WIPE=false
STOP_NODE=true
for arg in "$@"; do
  case "$arg" in
    --rm)        DO_RM=true ;;
    --wipe)      DO_RM=true; DO_WIPE=true ;;
    --keep-node) STOP_NODE=false ;;
    -h|--help)
      sed -n '3,19p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *)
      echo "✗ Unknown option: $arg (try --help)" >&2
      exit 1 ;;
  esac
done

# --------------------------- Preflight ----------------------------
DOCKER_OK=true
if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
  DOCKER_OK=false
  info "Docker not running — skipping the container teardown."
fi

# ------------------ 1. Stop the Node dev server -------------------
if $STOP_NODE; then
  log "Stopping Node API dev process"
  # pgrep -f matches the full command line; the pattern is repo-specific so this
  # won't touch other projects' node processes. Best-effort.
  if pgrep -f "$NODE_MATCH" >/dev/null 2>&1; then
    pkill -f "$NODE_MATCH" || true
    sleep 1
    # Force-kill any survivors.
    if pgrep -f "$NODE_MATCH" >/dev/null 2>&1; then
      pkill -9 -f "$NODE_MATCH" || true
    fi
    ok "Node dev process stopped"
  else
    info "No running Node dev process found"
  fi
fi

# ----------------- 2. Stop / remove containers --------------------
stop_container() {
  local name="$1"
  if docker ps --format '{{.Names}}' | grep -qx "$name"; then
    docker stop "$name" >/dev/null
    ok "$name stopped"
  elif docker ps -a --format '{{.Names}}' | grep -qx "$name"; then
    info "$name already stopped"
  else
    info "$name does not exist"
    return
  fi
  if $DO_RM; then
    docker rm "$name" >/dev/null 2>&1 || true
    ok "$name removed"
  fi
}

if $DOCKER_OK; then
  log "Stopping Docker services (Postgres + Redis)"
  stop_container "$PG_CONTAINER"
  stop_container "$REDIS_CONTAINER"

  # ----------------------- 3. Wipe volumes ------------------------
  if $DO_WIPE; then
    log "Deleting data volumes (DESTRUCTIVE)"
    printf "\033[0;31m  ! This permanently deletes the local Postgres DB (%s) and Redis data (%s).\033[0m\n" "$PG_VOLUME" "$REDIS_VOLUME"
    read -r -p "  Type 'wipe' to confirm: " confirm
    if [ "$confirm" = "wipe" ]; then
      docker volume rm "$PG_VOLUME" "$REDIS_VOLUME" >/dev/null 2>&1 || true
      ok "Volumes deleted"
    else
      info "Aborted — volumes kept"
    fi
  fi
fi

log "Done. Run ./dev_start.sh to bring everything back up."
