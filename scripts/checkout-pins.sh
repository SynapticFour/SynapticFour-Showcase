#!/usr/bin/env bash
# Check sibling repos out to PINNED_VERSIONS.txt SHAs (detached HEAD).
# Use this to reproduce committed demo/verification artefacts.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PIN_FILE="${SHOWCASE_PIN_FILE:-$SHOWCASE_ROOT/PINNED_VERSIONS.txt}"
DRY=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY=1 ;;
    -h|--help)
      echo "Usage: scripts/checkout-pins.sh [--dry-run]"
      echo "  git -C <sibling> checkout <pinned SHA> for each mapped repo."
      echo "  Leaves checkouts in detached HEAD. Does not fetch."
      exit 0
      ;;
  esac
done

if [[ ! -f "$PIN_FILE" ]]; then
  echo "checkout-pins: missing $PIN_FILE" >&2
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

FAIL=0
while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%$'\r'}"
  [[ -z "$line" || "$line" == \#* ]] && continue
  [[ "$line" == *=* ]] || continue
  key="${line%%=*}"
  pin="${line#*=}"
  [[ "$key" == "Solum-tag" ]] && continue
  repo="$(map_repo "$key")"
  [[ -n "$repo" ]] || continue
  if [[ ! -d "$repo/.git" ]]; then
    echo "[checkout-pins] SKIP $key (missing $repo)"
    continue
  fi
  if [[ "$DRY" == "1" ]]; then
    echo "[checkout-pins] would checkout $key -> ${pin:0:12} in $repo"
    continue
  fi
  if git -C "$repo" checkout --detach "$pin"; then
    echo "[checkout-pins] OK $key ${pin:0:12}"
  else
    echo "[checkout-pins] FAIL $key ${pin:0:12} (fetch the SHA in $repo first)" >&2
    FAIL=1
  fi
done <"$PIN_FILE"

exit "$FAIL"
