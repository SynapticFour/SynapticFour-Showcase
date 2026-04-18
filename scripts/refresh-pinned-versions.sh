#!/usr/bin/env bash
# Write PINNED_VERSIONS.txt with current git HEAD for sibling repos (best-effort).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT="${SHOWCASE_PINNED_OUT:-$SHOWCASE_ROOT/PINNED_VERSIONS.txt}"

DEMO="${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
HELI="${SHOWCASE_HELIOS_ROOT:-$SHOWCASE_ROOT/../HELIOS}"
BRA="${SHOWCASE_BRA_ROOT:-$SHOWCASE_ROOT/../bioresearch-assistant}"

rev_or_unknown() {
  local dir="$1"
  if [[ -d "$dir/.git" ]] && command -v git >/dev/null 2>&1; then
    git -C "$dir" rev-parse HEAD 2>/dev/null || echo "unknown"
  else
    echo "not-a-git-checkout"
  fi
}

{
  echo "# Pinned sibling revisions for reproducible demos (auto-generated)."
  echo "# Regenerate: ./scripts/refresh-pinned-versions.sh"
  echo "# Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo ""
  echo "Ferrum-GA4GH-Demo=$(rev_or_unknown "$DEMO")"
  echo "HELIOS=$(rev_or_unknown "$HELI")"
  echo "bioresearch-assistant=$(rev_or_unknown "$BRA")"
} >"$OUT"

echo "{\"ok\":true,\"wrote\":\"$OUT\"}"
cat "$OUT"
