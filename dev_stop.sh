#!/usr/bin/env bash
#
# dev_stop.sh — stop the iTaxEasy dev Docker services (Postgres + Redis).
#
# This only STOPS the containers; it does NOT remove them or their volumes,
# so all your data persists and `./dev_start.sh` brings them straight back.
#
# Usage:  ./dev_stop.sh

set -euo pipefail

PG_CONTAINER="itax-pg"
REDIS_CONTAINER="itax-redis"

log() { printf "\n\033[1;34m▶ %s\033[0m\n" "$1"; }
ok()  { printf "\033[0;32m  ✓ %s\033[0m\n" "$1"; }

if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
  echo "✗ Docker is not running — nothing to stop." >&2
  exit 1
fi

stop_container() {
  local name="$1"
  if docker ps --format '{{.Names}}' | grep -qx "$name"; then
    docker stop "$name" >/dev/null
    ok "$name stopped"
  elif docker ps -a --format '{{.Names}}' | grep -qx "$name"; then
    ok "$name already stopped"
  else
    echo "  $name does not exist (nothing to do)"
  fi
}

log "Stopping iTaxEasy dev services (data preserved)"
stop_container "$PG_CONTAINER"
stop_container "$REDIS_CONTAINER"

log "Done. Run ./dev_start.sh to bring them back up."
