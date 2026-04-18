#!/usr/bin/env bash
# Preflight checks before running the showcase golden path (local demo).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

STRICT="${SHOWCASE_PREFLIGHT_STRICT:-0}"
for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=1 ;;
    -h|--help)
      echo "Usage: scripts/preflight.sh [--strict]"
      echo "  --strict  Exit non-zero if a required check fails (default: warn only)."
      exit 0
      ;;
  esac
done

WARN=0
FAIL=0

note_ok() { echo "[preflight] OK  $*"; }
note_warn() { echo "[preflight] WARN $*"; WARN=1; }
note_fail() { echo "[preflight] FAIL $*"; FAIL=1; }

# Skip Docker checks in typical CI runners without Docker socket (still useful for Python check).
SKIP_DOCKER=0
if [[ -n "${GITHUB_ACTIONS:-}" ]]; then
  SKIP_DOCKER=1
fi

if [[ "$SKIP_DOCKER" == "1" ]]; then
  note_ok "skip Docker checks (GITHUB_ACTIONS)"
else
  if ! command -v docker >/dev/null 2>&1; then
    note_fail "docker not on PATH"
  elif ! docker info >/dev/null 2>&1; then
    note_fail "docker daemon not reachable (is Docker Desktop running?)"
  else
    note_ok "docker daemon reachable"
  fi
fi

resolve_python() {
  for c in "${SHOWCASE_PYTHON:-}" python3.13 python3.12 python3.11 python3; do
    [[ -z "$c" ]] && continue
    command -v "$c" >/dev/null 2>&1 || continue
    if "$c" -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 11) else 1)' 2>/dev/null; then
      echo "$c"
      return 0
    fi
  done
  return 1
}

if PY="$(resolve_python)"; then
  note_ok "Python for HELIOS/report: $PY ($("$PY" -c 'import sys; print("%d.%d"%sys.version_info[:2])'))"
else
  note_fail "need Python 3.11+ on PATH (set SHOWCASE_PYTHON if needed)"
fi

check_dir() {
  local label="$1"
  local path="$2"
  if [[ -d "$path" ]]; then
    note_ok "$label present: $path"
  else
    note_warn "$label missing: $path"
  fi
}

check_dir "Ferrum-GA4GH-Demo" "${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
check_dir "HELIOS" "${SHOWCASE_HELIOS_ROOT:-$SHOWCASE_ROOT/../HELIOS}"
check_dir "bioresearch-assistant (optional M2)" "${SHOWCASE_BRA_ROOT:-$SHOWCASE_ROOT/../bioresearch-assistant}"

if command -v df >/dev/null 2>&1; then
  free_kb="$(df -k "$SHOWCASE_ROOT" 2>/dev/null | awk 'NR==2 {print $4}')"
  if [[ -n "${free_kb:-}" ]] && [[ "$free_kb" -lt 1048576 ]]; then
    note_warn "less than ~1 GiB free on showcase filesystem (df)"
  else
    note_ok "disk space looks sufficient (rough check)"
  fi
fi

port_busy() {
  local port="$1"
  if command -v lsof >/dev/null 2>&1; then
    lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1
    return $?
  fi
  if command -v nc >/dev/null 2>&1; then
    nc -z localhost "$port" >/dev/null 2>&1
    return $?
  fi
  return 2
}

if [[ "$SKIP_DOCKER" != "1" ]]; then
  for p in 5432 8000 15432 18080; do
    if port_busy "$p"; then
      note_warn "something is listening on port $p (may conflict with Ferrum/BRA/gateway)"
    fi
  done
fi

if [[ "$FAIL" == "1" ]]; then
  echo "[preflight] summary: failed (see FAIL above)"
  [[ "$STRICT" == "1" ]] && exit 1
  exit 0
fi

if [[ "$WARN" == "1" ]]; then
  echo "[preflight] summary: passed with warnings"
  [[ "$STRICT" == "1" ]] && exit 1
  exit 0
fi

echo "[preflight] summary: all checks passed"
exit 0
