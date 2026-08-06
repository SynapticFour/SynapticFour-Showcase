#!/usr/bin/env bash
# W4 Phase B: optional Ferrum-GA4GH-Demo --gatk-rs WES path (soft-fail).
# Does NOT replace the default Showcase golden path (Broad GATK Nextflow).
#
# Writes artifacts/gatk-rs-wes/gatk-rs-wes-result.json
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

DEMO_ROOT="${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
OUT_DIR="${SHOWCASE_GATK_RS_WES_OUT:-$SHOWCASE_ROOT/artifacts/gatk-rs-wes}"
STRICT="${SHOWCASE_GATK_RS_WES_STRICT:-0}"
SOFT_DEMO="${FERRUM_GA4GH_GATK_RS_SOFT:-1}"

mkdir -p "$OUT_DIR"

finish() {
  local status="$1"
  local code=0
  [[ "$status" != "ok" && "$status" != "skipped" && "$STRICT" == "1" ]] && code=1
  echo "[gatk-rs-wes] status=$status → $OUT_DIR"
  exit "$code"
}

write_result() {
  local status="$1" reason="$2" note="$3"
  python3 - "$OUT_DIR/gatk-rs-wes-result.json" "$status" "$reason" "$note" "$DEMO_ROOT" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path
dest, status, reason, note, demo = sys.argv[1:6]
demo_skip = Path(demo) / "results" / "gatk_rs_wes_result.json"
payload = {
  "schema_version": 1,
  "stage": "gatk_rs_wes",
  "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
  "status": status,
  "reason": reason or None,
  "demo_root": demo,
  "wes_integration": "optional_ferrum_ga4gh_demo",
  "honesty": (
    "Optional Ferrum-GA4GH-Demo ./run --gatk-rs path (Alpha). "
    "Default Showcase golden path remains --nextflow + Broad GATK. "
    "Soft-skip/fail is expected when the gatk-rs image is missing or the caller is unstable."
  ),
  "note": note or None,
}
if demo_skip.is_file():
    try:
        payload["demo_result"] = json.loads(demo_skip.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        payload["demo_result"] = None
metrics = Path(demo) / "results" / "metrics.json"
if metrics.is_file() and status == "ok":
    try:
        m = json.loads(metrics.read_text(encoding="utf-8"))
        payload["wes_run_id"] = m.get("wes_run_id")
        payload["wes_engine"] = m.get("wes_engine")
    except json.JSONDecodeError:
        pass
Path(dest).write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"ok": status in ("ok", "skipped"), "status": status, "wrote": dest}))
PY
}

if [[ ! -x "$DEMO_ROOT/run" && ! -f "$DEMO_ROOT/run" ]]; then
  write_result "skipped" "demo_missing" "Ferrum-GA4GH-Demo not found at $DEMO_ROOT"
  finish "skipped"
fi

echo "[gatk-rs-wes] running: $DEMO_ROOT/run --gatk-rs (soft=$SOFT_DEMO)"
set +e
(
  cd "$DEMO_ROOT"
  FERRUM_GA4GH_GATK_RS_SOFT="$SOFT_DEMO" bash ./run --gatk-rs
)
rc=$?
set -e

if [[ $rc -eq 0 ]]; then
  if [[ -f "$DEMO_ROOT/results/gatk_rs_wes_result.json" ]]; then
    # Soft-skip from Demo (e.g. image missing) still exit 0
    st="$(python3 -c "import json; print(json.load(open('$DEMO_ROOT/results/gatk_rs_wes_result.json')).get('status',''))" 2>/dev/null || true)"
    if [[ "$st" == "skipped" ]]; then
      write_result "skipped" "demo_soft_skip" "Demo soft-skipped gatk-rs path"
      finish "skipped"
    fi
  fi
  if [[ -f "$DEMO_ROOT/results/metrics.json" ]]; then
    write_result "ok" "completed" "Demo --gatk-rs completed with metrics.json"
    finish "ok"
  fi
  write_result "skipped" "no_metrics" "Demo exited 0 but no metrics (likely soft-skip without stack)"
  finish "skipped"
fi

write_result "failed" "demo_exit_$rc" "Demo --gatk-rs failed (Alpha soft-fail unless STRICT)"
finish "failed"
