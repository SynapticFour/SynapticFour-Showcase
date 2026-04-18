#!/usr/bin/env bash
# Stop all local demo stacks used by SynapticFour-Showcase.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=lib/bra-compose.sh
source "$SCRIPT_DIR/lib/bra-compose.sh"

DEMO_ROOT="${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
BRA_ROOT="${SHOWCASE_BRA_ROOT:-$SHOWCASE_ROOT/../bioresearch-assistant}"
if [[ -d "$BRA_ROOT" ]]; then
  BRA_ROOT="$(cd "$BRA_ROOT" && pwd)"
fi
REMOVE_VOLUMES=0
HARD=0

usage() {
  cat <<'EOF'
Usage: scripts/stop-showcase.sh [--volumes] [--hard]

Stops local docker compose stacks used by the showcase flow:
  - Ferrum-GA4GH-Demo stack (project: ferrum-ga4gh-demo)
  - bioresearch-assistant stack (if present)

Options:
  --volumes   Also remove volumes (`down -v --remove-orphans`)
  --hard      Implies --volumes, then force-stops/removes any leftover containers whose
              names match ferrum-ga4gh-demo or bioresearch-assistant (orphans, manual runs)

Environment:
  SHOWCASE_DEMO_ROOT   Path to Ferrum-GA4GH-Demo (default: ../Ferrum-GA4GH-Demo)
  SHOWCASE_BRA_ROOT    Path to bioresearch-assistant (default: ../bioresearch-assistant)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --volumes)
      REMOVE_VOLUMES=1
      shift
      ;;
    --hard)
      HARD=1
      REMOVE_VOLUMES=1
      shift
      ;;
    *)
      echo "stop-showcase: unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

DOWN_ARGS=(down)
if [[ "$REMOVE_VOLUMES" == "1" ]]; then
  DOWN_ARGS=(down -v --remove-orphans)
fi

stop_demo() {
  local root="$1"
  local ferrum_src
  ferrum_src="${FERUM_SRC:-$root/.cache/ferrum}"
  local base_compose="$ferrum_src/deploy/docker-compose.yml"
  local overlay_compose="$root/demo/docker-compose.ga4gh.yml"

  if [[ ! -f "$base_compose" || ! -f "$overlay_compose" ]]; then
    echo "[stop] Ferrum-GA4GH-Demo compose files not found, skipping: $root"
    return 0
  fi

  echo "[stop] stopping Ferrum-GA4GH-Demo stack..."
  docker compose -p ferrum-ga4gh-demo \
    -f "$base_compose" \
    -f "$overlay_compose" \
    "${DOWN_ARGS[@]}" || true
}

stop_bra() {
  local root="$1"
  local compose_file="$root/docker-compose.yml"
  if [[ ! -f "$compose_file" ]]; then
    echo "[stop] bioresearch-assistant compose not found, skipping: $root"
    return 0
  fi
  echo "[stop] stopping bioresearch-assistant stack..."
  bra_docker_compose "$root" "$SHOWCASE_ROOT" "${DOWN_ARGS[@]}" || true
}

stop_demo "$DEMO_ROOT"
stop_bra "$BRA_ROOT"

hard_cleanup_leftovers() {
  echo "[stop] hard: removing leftover containers matching showcase project names..."
  local pattern id
  for pattern in ferrum-ga4gh-demo bioresearch-assistant; do
    while IFS= read -r id; do
      [[ -z "$id" ]] && continue
      echo "[stop] hard: stopping/removing $id"
      docker stop "$id" 2>/dev/null || true
      docker rm "$id" 2>/dev/null || true
    done < <(docker ps -aq --filter "name=$pattern" 2>/dev/null || true)
  done
}

if [[ "$HARD" == "1" ]]; then
  hard_cleanup_leftovers
fi

echo "[stop] done."
