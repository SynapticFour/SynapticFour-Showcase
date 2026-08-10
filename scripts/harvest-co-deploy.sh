#!/usr/bin/env bash
# Soft harvest of Ferrum-GA4GH-Demo ga4gh-infra co-deploy results into Showcase artefacts.
#
# Does NOT run ./run --with-infra (heavy). Copies an existing co_deploy_results.json
# from the Demo (or a committed fixture) so Evidence Pack can include Passports proof.
#
# Modes:
#   (default)   Prefer Demo results/co_deploy_results.json when it has ran>0; else fixture; else soft-skip
#   --fixtures  Always use committed fixture
#
# Opt-in on golden path: SHOWCASE_ENABLE_CO_DEPLOY_HARVEST=1
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

DEMO_ROOT="${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
OUT_DIR="${SHOWCASE_CO_DEPLOY_OUT:-$SHOWCASE_ROOT/artifacts/ga4gh-infra}"
STRICT="${SHOWCASE_CO_DEPLOY_STRICT:-0}"
PUBLISH_EXAMPLES="${SHOWCASE_CO_DEPLOY_PUBLISH_EXAMPLES:-0}"
MODE="live"
FIXTURE="$SHOWCASE_ROOT/fixtures/ci/ga4gh-infra/co_deploy_results.json"

usage() {
  cat <<'EOF'
Usage: scripts/harvest-co-deploy.sh [--fixtures] [--publish-examples]

Environment:
  SHOWCASE_DEMO_ROOT              Sibling Ferrum-GA4GH-Demo (default ../Ferrum-GA4GH-Demo)
  SHOWCASE_CO_DEPLOY_STRICT=1     Exit non-zero on skip (default: soft-fail, exit 0)
  SHOWCASE_CO_DEPLOY_OUT          Artefact directory (default artifacts/ga4gh-infra)

Honesty: Harvest only. To produce live Passports evidence, run in the Demo:
  cd ../Ferrum-GA4GH-Demo && ./run --with-infra
Then re-run this script (or make co-deploy-harvest).
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --fixtures) MODE="fixtures"; shift ;;
    --publish-examples) PUBLISH_EXAMPLES=1; shift ;;
    *)
      echo "harvest-co-deploy: unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

mkdir -p "$OUT_DIR"

finish() {
  local status="$1"
  local detail="${2:-}"
  local code=0
  if [[ "$status" != "ok" && "$STRICT" == "1" ]]; then
    code=1
  fi
  echo "[co-deploy-harvest] status=$status${detail:+ ($detail)} → $OUT_DIR"
  exit "$code"
}

write_pointer() {
  local status="$1"
  local source="$2"
  local sha="$3"
  local ran="$4"
  local skipped="$5"
  local errors="$6"
  local all_passed="$7"
  local note="$8"
  python3 - "$OUT_DIR/co-deploy-harvest.json" "$status" "$source" "$sha" \
    "$ran" "$skipped" "$errors" "$all_passed" "$note" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path

dest, status, source, sha, ran, skipped, errors, all_passed, note = sys.argv[1:10]

def _int(v):
    try:
        return int(v)
    except ValueError:
        return None

out = {
    "schema_version": 1,
    "stage": "ga4gh_infra_co_deploy_harvest",
    "kind": "passports-co-deploy",
    "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
    "status": status,
    "source": source or None,
    "sha256": sha or None,
    "summary": {
        "ran": _int(ran),
        "skipped": _int(skipped),
        "errors": _int(errors),
        "all_passed": (all_passed == "true") if all_passed in ("true", "false") else None,
    },
    "maturity": "demo-co-deploy-not-production-idp",
    "honesty": (
        "Harvest of Ferrum-GA4GH-Demo results/co_deploy_results.json only. "
        "Does not start ga4gh-infra. Live Passports proof: Demo ./run --with-infra. "
        "Not a production IdP / AAI certificate."
    ),
    "note": note or None,
}
Path(dest).write_text(json.dumps(out, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"ok": status == "ok", "status": status, "wrote": dest}))
PY
}

sha256_file() {
  local f="$1"
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$f" | awk '{print $1}'
  else
    sha256sum "$f" | awk '{print $1}'
  fi
}

summarize_json() {
  # Prints: ran skipped errors all_passed_bool
  python3 - "$1" <<'PY'
import json, sys
from pathlib import Path
p = Path(sys.argv[1])
data = json.loads(p.read_text(encoding="utf-8"))
s = data.get("summary") if isinstance(data, dict) else {}
if not isinstance(s, dict):
    s = {}
ran = int(s.get("ran") or 0)
skipped = int(s.get("skipped") or 0)
errors = int(s.get("errors") or 0)
all_passed = "true" if s.get("all_passed", True) else "false"
print(f"{ran} {skipped} {errors} {all_passed}")
PY
}

copy_artefact() {
  local src="$1"
  local note="$2"
  cp "$src" "$OUT_DIR/co_deploy_results.json"
  local sha
  sha="$(sha256_file "$OUT_DIR/co_deploy_results.json")"
  local stats
  stats="$(summarize_json "$OUT_DIR/co_deploy_results.json")"
  # shellcheck disable=SC2086
  set -- $stats
  write_pointer "ok" "$src" "$sha" "$1" "$2" "$3" "$4" "$note"
  if [[ "$PUBLISH_EXAMPLES" == "1" ]]; then
    mkdir -p "$SHOWCASE_ROOT/demo/results"
    cp "$OUT_DIR/co_deploy_results.json" \
      "$SHOWCASE_ROOT/demo/results/co_deploy_results-example.json"
    cp "$OUT_DIR/co-deploy-harvest.json" \
      "$SHOWCASE_ROOT/demo/results/co-deploy-harvest-example.json"
  fi
  finish ok "ran=$1 skipped=$2 errors=$3"
}

if [[ "$MODE" == "fixtures" ]]; then
  [[ -f "$FIXTURE" ]] || finish skipped "fixture missing: $FIXTURE"
  copy_artefact "$FIXTURE" "Committed CI fixture (Passports co-deploy shape)"
fi

LIVE="$DEMO_ROOT/results/co_deploy_results.json"
if [[ -f "$LIVE" ]]; then
  stats="$(summarize_json "$LIVE")"
  # shellcheck disable=SC2086
  set -- $stats
  ran="$1"
  if [[ "$ran" -gt 0 ]]; then
    copy_artefact "$LIVE" "Live Demo co_deploy_results.json (ran=$ran)"
  fi
  # Present but skipped-only: still harvest with honesty that infra was not exercised.
  note="Demo co_deploy present but scenarios skipped (ran=0). Prefer ./run --with-infra for live Passports proof."
  copy_artefact "$LIVE" "$note"
fi

if [[ -f "$FIXTURE" ]]; then
  copy_artefact "$FIXTURE" "Fell back to committed fixture (no live Demo co_deploy with ran>0)"
fi

write_pointer "skipped" "" "" "" "" "" "" \
  "No Demo co_deploy_results.json and no fixture. Run: cd ../Ferrum-GA4GH-Demo && ./run --with-infra"
finish skipped "nothing to harvest"
