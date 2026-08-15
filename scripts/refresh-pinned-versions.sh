#!/usr/bin/env bash
# Write PINNED_VERSIONS.txt with current git HEAD for sibling repos (best-effort).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT="${SHOWCASE_PINNED_OUT:-$SHOWCASE_ROOT/PINNED_VERSIONS.txt}"

DEMO="${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
HELI="${SHOWCASE_HELIOS_ROOT:-$SHOWCASE_ROOT/../HELIOS}"
INFRA="${SHOWCASE_GA4GH_INFRA_ROOT:-$SHOWCASE_ROOT/../ga4gh-infra}"
BRA="${SHOWCASE_BRA_ROOT:-$SHOWCASE_ROOT/../bioresearch-assistant}"
SOLUM_DEMO="${SHOWCASE_SOLUM_DEMO_ROOT:-$SHOWCASE_ROOT/../Solum-Demo}"
HELIXTEST="${SHOWCASE_HELIXTEST_ROOT:-$SHOWCASE_ROOT/../HelixTest}"
GATK_RS="${SHOWCASE_GATK_RS_ROOT:-$SHOWCASE_ROOT/../gatk-rs}"
S4MP="${SHOWCASE_S4MP_ROOT:-$SHOWCASE_ROOT/../S4MP}"
# Solum product ref Solum-Demo builds (Dockerfile ARG SOLUM_REF), not a local checkout SHA.
# Default is the Solum-Demo verified baseline, not the retired stage1 git tag.
SOLUM_TAG="${SHOWCASE_SOLUM_TAG:-6b4519c98f5c1e905ab5cf3f517787021d1e2604}"

rev_or_unknown() {
  local dir="$1"
  if [[ -d "$dir/.git" ]] && command -v git >/dev/null 2>&1; then
    git -C "$dir" rev-parse HEAD 2>/dev/null || echo "unknown"
  else
    echo "not-a-git-checkout"
  fi
}

{
  echo "# Pinned sibling revisions for the last published demo/verification artefacts."
  echo "# make up requires Ferrum-GA4GH-Demo + HELIOS to match unless SHOWCASE_ALLOW_PIN_DRIFT=1."
  echo "# Reproduce: ./scripts/checkout-pins.sh   Drift: ./scripts/check-pins.sh"
  echo "# Regenerate: ./scripts/refresh-pinned-versions.sh"
  echo "# Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "#"
  echo "# Solum-tag is the Solum git ref Solum-Demo builds (Dockerfile ARG SOLUM_REF),"
  echo "# not a local checkout SHA. Default: Solum-Demo verified baseline."
  echo "# HelixTest is optional (Evidence Pack / conformance gate)."
  echo "# ga4gh-infra is optional (Passports co-deploy via Ferrum-GA4GH-Demo --with-infra)."
  echo "# gatk-rs / S4MP are optional W4 (Alpha smoke + port-diff sidecar; soft-fail)."
  echo ""
  echo "Ferrum-GA4GH-Demo=$(rev_or_unknown "$DEMO")"
  echo "HELIOS=$(rev_or_unknown "$HELI")"
  echo "ga4gh-infra=$(rev_or_unknown "$INFRA")"
  echo "bioresearch-assistant=$(rev_or_unknown "$BRA")"
  echo "Solum-Demo=$(rev_or_unknown "$SOLUM_DEMO")"
  echo "Solum-tag=$SOLUM_TAG"
  echo "HelixTest=$(rev_or_unknown "$HELIXTEST")"
  echo "gatk-rs=$(rev_or_unknown "$GATK_RS")"
  echo "S4MP=$(rev_or_unknown "$S4MP")"
} >"$OUT"

echo "{\"ok\":true,\"wrote\":\"$OUT\"}"
cat "$OUT"
