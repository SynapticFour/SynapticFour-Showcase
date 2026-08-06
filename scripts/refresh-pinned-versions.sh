#!/usr/bin/env bash
# Write PINNED_VERSIONS.txt with current git HEAD for sibling repos (best-effort).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT="${SHOWCASE_PINNED_OUT:-$SHOWCASE_ROOT/PINNED_VERSIONS.txt}"

DEMO="${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
HELI="${SHOWCASE_HELIOS_ROOT:-$SHOWCASE_ROOT/../HELIOS}"
BRA="${SHOWCASE_BRA_ROOT:-$SHOWCASE_ROOT/../bioresearch-assistant}"
SOLUM_DEMO="${SHOWCASE_SOLUM_DEMO_ROOT:-$SHOWCASE_ROOT/../Solum-Demo}"
HELIXTEST="${SHOWCASE_HELIXTEST_ROOT:-$SHOWCASE_ROOT/../HelixTest}"
# Product tag consumed by Solum-Demo Dockerfile/compose (not a git HEAD).
SOLUM_TAG="${SHOWCASE_SOLUM_TAG:-stage1-baseline-sidecar-custody-2026-08-01}"

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
  echo "#"
  echo "# Solum-tag is the Solum product git tag Solum-Demo builds against"
  echo "# (see Solum-Demo Dockerfile ARG SOLUM_TAG) — not a local checkout SHA."
  echo "# HelixTest is optional (Evidence Pack / conformance gate)."
  echo ""
  echo "Ferrum-GA4GH-Demo=$(rev_or_unknown "$DEMO")"
  echo "HELIOS=$(rev_or_unknown "$HELI")"
  echo "bioresearch-assistant=$(rev_or_unknown "$BRA")"
  echo "Solum-Demo=$(rev_or_unknown "$SOLUM_DEMO")"
  echo "Solum-tag=$SOLUM_TAG"
  echo "HelixTest=$(rev_or_unknown "$HELIXTEST")"
} >"$OUT"

echo "{\"ok\":true,\"wrote\":\"$OUT\"}"
cat "$OUT"
