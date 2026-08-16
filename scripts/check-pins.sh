#!/usr/bin/env bash
# Compare PINNED_VERSIONS.txt to sibling git HEADs. Does not checkout.
#
# Exit 0: file parses; drift is reported (warn) unless --strict.
# Exit 1: unreadable pin file, or --strict and at least one present sibling drifted.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PIN_FILE="${SHOWCASE_PIN_FILE:-$SHOWCASE_ROOT/PINNED_VERSIONS.txt}"
STRICT=0
STRICT_ALL=0
for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=1 ;;
    --strict-all) STRICT=1; STRICT_ALL=1 ;;
    -h|--help)
      echo "Usage: scripts/check-pins.sh [--strict|--strict-all]"
      echo "  Reports sibling HEAD vs PINNED_VERSIONS.txt."
      echo "  make golden-path runs --strict (Ferrum-GA4GH-Demo + HELIOS must match)"
      echo "  unless SHOWCASE_ALLOW_PIN_DRIFT=1. Reproduce: scripts/checkout-pins.sh."
      exit 0
      ;;
  esac
done

if [[ ! -f "$PIN_FILE" ]]; then
  echo "check-pins: missing $PIN_FILE" >&2
  exit 1
fi

map_repo() {
  case "$1" in
    Ferrum-GA4GH-Demo) echo "${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}" ;;
    HELIOS) echo "${SHOWCASE_HELIOS_ROOT:-$SHOWCASE_ROOT/../HELIOS}" ;;
    ga4gh-infra) echo "${SHOWCASE_GA4GH_INFRA_ROOT:-$SHOWCASE_ROOT/../ga4gh-infra}" ;;
    bioresearch-assistant) echo "${SHOWCASE_BRA_ROOT:-$SHOWCASE_ROOT/../bioresearch-assistant}" ;;
    Solum-Demo) echo "${SHOWCASE_SOLUM_DEMO_ROOT:-$SHOWCASE_ROOT/../Solum-Demo}" ;;
    HelixTest) echo "${SHOWCASE_HELIXTEST_ROOT:-$SHOWCASE_ROOT/../HelixTest}" ;;
    gatk-rs) echo "${SHOWCASE_GATK_RS_ROOT:-$SHOWCASE_ROOT/../gatk-rs}" ;;
    S4MP) echo "${SHOWCASE_S4MP_ROOT:-$SHOWCASE_ROOT/../S4MP}" ;;
    *) echo "" ;;
  esac
}

echo "[check-pins] These SHAs identify the last committed demo/verification artefacts."
echo "[check-pins] make golden-path requires Ferrum-GA4GH-Demo + HELIOS to match unless SHOWCASE_ALLOW_PIN_DRIFT=1."

DRIFT=0
REQUIRED_DRIFT=0
MISSING=0
MATCH=0
FOUND_REQUIRED=0
required_seen=""

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%$'\r'}"
  [[ -z "$line" || "$line" == \#* ]] && continue
  [[ "$line" == *=* ]] || continue
  key="${line%%=*}"
  pin="${line#*=}"
  case "$key" in
    Ferrum-GA4GH-Demo|HELIOS|Solum-Demo|Solum-tag) FOUND_REQUIRED=$((FOUND_REQUIRED + 1)) ;;
  esac
  if [[ -z "$pin" ]]; then
    echo "check-pins: empty value for $key" >&2
    exit 1
  fi
  is_required=0
  case "$key" in
    Ferrum-GA4GH-Demo|HELIOS) is_required=1 ;;
    Solum-Demo)
      if [[ "${SHOWCASE_ENABLE_SOLUM:-0}" == "1" ]]; then
        is_required=1
      fi
      ;;
  esac
  if [[ "$key" == "Solum-tag" ]]; then
    echo "[check-pins] OK   $key=$pin (product tag, not a sibling HEAD)"
    continue
  fi
  repo="$(map_repo "$key")"
  if [[ -z "$repo" ]]; then
    echo "[check-pins] SKIP $key=$pin (no sibling mapping)"
    continue
  fi
  if [[ ! -d "$repo/.git" ]]; then
    echo "[check-pins] SKIP $key pin=${pin:0:12} (no git checkout at $repo)"
    MISSING=$((MISSING + 1))
    continue
  fi
  head="$(git -C "$repo" rev-parse HEAD 2>/dev/null || true)"
  if [[ -z "$head" ]]; then
    echo "[check-pins] SKIP $key (rev-parse failed)"
    MISSING=$((MISSING + 1))
    continue
  fi
  pin_sha="$(git -C "$repo" rev-parse "${pin}^{commit}" 2>/dev/null || true)"
  compare="${pin_sha:-$pin}"
  if [[ "$head" == "$compare" ]]; then
    echo "[check-pins] OK   $key $pin matches HEAD ${head:0:12}"
    MATCH=$((MATCH + 1))
    continue
  fi
  ahead="$(git -C "$repo" rev-list --count "${compare}..HEAD" 2>/dev/null || echo "?")"
  echo "[check-pins] DRIFT $key pin=$pin (${compare:0:12}) HEAD=${head:0:12} (+${ahead} commits)"
  DRIFT=$((DRIFT + 1))
  if [[ "$is_required" == "1" ]]; then
    REQUIRED_DRIFT=$((REQUIRED_DRIFT + 1))
  fi
done <"$PIN_FILE"

if [[ "$FOUND_REQUIRED" -lt 4 ]]; then
  echo "check-pins: PINNED_VERSIONS.txt missing required keys (Ferrum-GA4GH-Demo, HELIOS, Solum-Demo, Solum-tag)" >&2
  exit 1
fi

echo "[check-pins] summary: match=$MATCH drift=$DRIFT required_drift=$REQUIRED_DRIFT missing_checkout=$MISSING"
if [[ "$STRICT" == "1" ]]; then
  if [[ "$STRICT_ALL" == "1" && "$DRIFT" -gt 0 ]]; then
    echo "check-pins: --strict-all — run scripts/checkout-pins.sh or refresh PINNED_VERSIONS.txt" >&2
    exit 1
  fi
  if [[ "$REQUIRED_DRIFT" -gt 0 ]]; then
    echo "check-pins: required siblings drifted (Ferrum-GA4GH-Demo / HELIOS). checkout-pins.sh or SHOWCASE_ALLOW_PIN_DRIFT=1" >&2
    exit 1
  fi
fi
exit 0
