#!/usr/bin/env bash
# SynapticFour Showcase — customer-runnable integration / claim-verification suite.
#
# Modes:
#   --fixtures   (default) No Docker required. Hard-fail on CI spine; publishable evidence.
#   --live       Opt-in live stages (Docker / siblings). Soft-fail unstable gatk-rs/S4MP.
#   --publish-verification  Copy fixture Evidence Pack + suite MANIFEST → demo/verification/
#
# Honesty: this suite tests technical integrations and claims as documented —
# not legal compliance, clinical validity, or production equivalence.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$SHOWCASE_ROOT"

MODE="fixtures"
PUBLISH=0
LIVE_STAGES=()
SUITE_OUT="${SHOWCASE_SUITE_OUT:-$SHOWCASE_ROOT/artifacts/integration-suite}"
STRICT_LIVE="${SHOWCASE_SUITE_STRICT:-0}"

usage() {
  cat <<'EOF'
Usage: scripts/run-integration-suite.sh [--fixtures|--live [stages...]] [--publish-verification]

  --fixtures     CI / customer default: no Docker. Runs ci-check spine + Evidence Pack fixtures.
  --live         Run opt-in live stages after fixtures (or alone if --skip-fixtures).
                 Stages: smoke | solum | consent | consent-deny | gatk-rs | gatk-rs-wes | s4mp | pack | golden-path
                 Default --live stages: smoke gatk-rs s4mp solum consent pack
  --skip-fixtures  With --live, do not re-run fixture spine first.
  --publish-verification  Write demo/verification/ from fixture pack (transparent repo evidence).

Examples:
  ./scripts/run-integration-suite.sh --fixtures --publish-verification
  ./scripts/run-integration-suite.sh --live
  ./scripts/run-integration-suite.sh --live golden-path
  make integration-suite

Exit: non-zero if a hard stage fails. Soft stages (gatk-rs / S4MP / gatk-rs-wes) never fail the suite unless SHOWCASE_SUITE_STRICT=1.
EOF
}

SKIP_FIXTURES=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --fixtures) MODE="fixtures"; shift ;;
    --live)
      MODE="live"
      shift
      while [[ $# -gt 0 && "$1" != --* ]]; do
        LIVE_STAGES+=("$1")
        shift
      done
      ;;
    --skip-fixtures) SKIP_FIXTURES=1; shift ;;
    --publish-verification) PUBLISH=1; shift ;;
    *)
      echo "run-integration-suite: unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

if [[ "$MODE" == "live" && ${#LIVE_STAGES[@]} -eq 0 ]]; then
  LIVE_STAGES=(smoke gatk-rs s4mp solum consent pack)
fi

mkdir -p "$SUITE_OUT"
STAGE_LOG="$SUITE_OUT/stages.jsonl"
: >"$STAGE_LOG"

resolve_python() {
  if [[ -n "${SHOWCASE_PYTHON:-}" ]]; then
    echo "${SHOWCASE_PYTHON}"
    return 0
  fi
  for c in python3.13 python3.12 python3.11 python3; do
    command -v "$c" >/dev/null 2>&1 || continue
    echo "$c"
    return 0
  done
  return 1
}

PY="$(resolve_python)" || { echo "need python3" >&2; exit 1; }

record_stage() {
  local id="$1" status="$2" hard="$3" detail="${4:-}"
  "$PY" - "$STAGE_LOG" "$id" "$status" "$hard" "$detail" <<'PY'
import json, sys
from datetime import datetime, timezone
path, sid, status, hard, detail = sys.argv[1:6]
rec = {
  "id": sid,
  "status": status,
  "hard": hard == "1",
  "detail": detail or None,
  "at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
}
with open(path, "a", encoding="utf-8") as f:
    f.write(json.dumps(rec) + "\n")
print(f"[suite] {sid}: {status}" + (f" ({detail})" if detail else ""))
PY
}

run_hard() {
  local id="$1"
  shift
  if "$@"; then
    record_stage "$id" "ok" "1" ""
    return 0
  fi
  record_stage "$id" "failed" "1" "command failed"
  return 1
}

run_soft() {
  local id="$1"
  shift
  set +e
  "$@"
  local rc=$?
  set -e
  if [[ $rc -eq 0 ]]; then
    record_stage "$id" "ok" "0" ""
    return 0
  fi
  if [[ "$STRICT_LIVE" == "1" ]]; then
    record_stage "$id" "failed" "1" "soft stage failed under STRICT"
    return 1
  fi
  record_stage "$id" "soft_fail" "0" "exit=$rc"
  return 0
}

HARD_FAIL=0

if [[ "$SKIP_FIXTURES" != "1" ]]; then
  echo "[suite] === fixture spine (customer / CI default) ==="
  if ! run_hard "ci_check" ./scripts/ci-check.sh; then
    HARD_FAIL=1
  fi
fi

run_live_stage() {
  local stage="$1"
  case "$stage" in
    smoke)
      run_soft "gatk_rs_smoke_live" ./scripts/run-gatk-rs-smoke.sh
      ;;
    gatk-rs)
      run_soft "gatk_rs_smoke_live" ./scripts/run-gatk-rs-smoke.sh
      ;;
    gatk-rs-wes)
      run_soft "gatk_rs_wes" ./scripts/run-gatk-rs-wes.sh
      ;;
    s4mp)
      run_soft "s4mp_evidence" ./scripts/attach-s4mp-evidence.sh
      ;;
    solum)
      run_soft "solum_stage" ./scripts/run-solum-stage.sh
      ;;
    consent)
      run_soft "consent_gate_allow" ./scripts/run-consent-gate.sh --allow
      ;;
    consent-deny)
      run_soft "consent_gate_deny" ./scripts/run-consent-gate.sh --deny
      ;;
    pack)
      run_soft "evidence_pack_live" ./scripts/evidence-pack.sh
      ;;
    golden-path)
      echo "[suite] golden-path is long (Docker, 10–20+ min first run)…"
      run_hard "golden_path" ./scripts/run-golden-path.sh || HARD_FAIL=1
      ;;
    *)
      record_stage "$stage" "unknown" "0" "unknown live stage"
      ;;
  esac
}

if [[ "$MODE" == "live" ]]; then
  echo "[suite] === live stages: ${LIVE_STAGES[*]} ==="
  for s in "${LIVE_STAGES[@]}"; do
    run_live_stage "$s"
  done
fi

# Always ensure a fixture evidence pack exists for publish / MANIFEST.
if [[ ! -f "$SHOWCASE_ROOT/artifacts/evidence-pack-fixtures/MANIFEST.json" ]]; then
  ./scripts/evidence-pack.sh --fixtures || true
fi

write_suite_manifest() {
  local dest="$1"
  local mode_label="$2"
  "$PY" - "$dest" "$mode_label" "$STAGE_LOG" "$SHOWCASE_ROOT" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path

dest, mode, stage_log, root = Path(sys.argv[1]), sys.argv[2], Path(sys.argv[3]), Path(sys.argv[4])
stages = []
if stage_log.is_file():
    for line in stage_log.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line:
            stages.append(json.loads(line))

pins = {}
pin_path = root / "PINNED_VERSIONS.txt"
if pin_path.is_file():
    for line in pin_path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        pins[k.strip()] = v.strip()

hard_failed = [s for s in stages if s.get("hard") and s.get("status") == "failed"]
soft = [s for s in stages if not s.get("hard") and s.get("status") in ("soft_fail", "skipped")]

manifest = {
    "schema_version": 1,
    "suite_kind": "synapticfour-showcase-integration-suite",
    "mode": mode,
    "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
    "pins": pins,
    "stages": stages,
    "summary": {
        "stages_total": len(stages),
        "hard_failed": len(hard_failed),
        "soft_issues": len(soft),
        "ok": len(hard_failed) == 0,
    },
    "honesty": {
        "proves": [
            "Fixture spine scripts compile and produce expected Evidence Pack roles",
            "Documented opt-in integrations can be re-run locally by customers",
            "Soft stages record skip/fail honestly when Alpha products are unavailable",
        ],
        "does_not_prove": [
            "Formal certification, EHDS/DSGVO compliance, or legal consent validity",
            "gatk-rs clinical/GIAB equivalence to Broad GATK",
            "S4MP port certification (heuristic map; certify stub)",
            "That a customer production deployment matches this demo environment",
        ],
        "docs": [
            "docs/for-customers/overview.md",
            "docs/for-customers/integration-verification.md",
            "docs/for-customers/evidence-pack.md",
            "docs/for-customers/gatk-rs-s4mp.md",
        ],
    },
}
dest.parent.mkdir(parents=True, exist_ok=True)
dest.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"ok": manifest["summary"]["ok"], "wrote": str(dest), "stages": len(stages)}))
PY
}

write_suite_manifest "$SUITE_OUT/SUITE-MANIFEST.json" "$MODE"

if [[ "$PUBLISH" == "1" ]]; then
  echo "[suite] publishing demo/verification/ (fixture Evidence Pack + suite MANIFEST)…"
  VER="$SHOWCASE_ROOT/demo/verification"
  KEEP_LIVE=""
  if [[ -f "$VER/LIVE-RUN.md" ]]; then
    KEEP_LIVE="$(mktemp)"
    cp "$VER/LIVE-RUN.md" "$KEEP_LIVE"
  fi
  rm -rf "$VER"
  mkdir -p "$VER"
  PACK="$SHOWCASE_ROOT/artifacts/evidence-pack-fixtures"
  if [[ ! -d "$PACK" ]]; then
    ./scripts/evidence-pack.sh --fixtures
  fi
  # Copy pack files; rewrite absolute source paths in MANIFEST for portability.
  cp -R "$PACK"/. "$VER"/
  cp "$SUITE_OUT/SUITE-MANIFEST.json" "$VER/SUITE-MANIFEST.json"
  if [[ -n "$KEEP_LIVE" && -f "$KEEP_LIVE" ]]; then
    cp "$KEEP_LIVE" "$VER/LIVE-RUN.md"
    rm -f "$KEEP_LIVE"
  fi
  "$PY" - "$VER/MANIFEST.json" <<'PY'
import json, sys
from pathlib import Path
p = Path(sys.argv[1])
m = json.loads(p.read_text(encoding="utf-8"))
m["mode"] = "fixtures-published"
m["showcase_root"] = "(portable; see repo SynapticFour-Showcase)"
for f in m.get("files") or []:
    src = str(f.get("source") or "")
    if "fixtures/ci/" in src:
        f["source"] = "fixtures/ci/" + src.split("fixtures/ci/", 1)[-1]
    elif "demo/results/" in src:
        f["source"] = "demo/results/" + src.split("demo/results/", 1)[-1]
    else:
        f["source"] = Path(src).name
p.write_text(json.dumps(m, indent=2) + "\n", encoding="utf-8")
PY
  cat >"$VER/README.md" <<'EOF'
# Published verification evidence

This directory is a **frozen fixture Evidence Pack** plus `SUITE-MANIFEST.json` from
`./scripts/run-integration-suite.sh --fixtures --publish-verification`.

It is committed so anyone can inspect SynapticFour Showcase claims **without running Docker**.

## Re-run locally

```bash
./scripts/run-integration-suite.sh --fixtures --publish-verification
# Opt-in live (Docker / siblings):
./scripts/run-integration-suite.sh --live
```

See `docs/for-customers/integration-verification.md` and `docs/for-customers/overview.md`.

## Honesty

This is **not** a certificate. Soft stages (gatk-rs / S4MP) may skip or soft-fail when Alpha
binaries/images are missing. Default genomic evidence remains Ferrum Nextflow + Broad GATK + HELIOS.
EOF
  echo "[suite] published → $VER"
fi

if [[ "$HARD_FAIL" == "1" ]]; then
  echo "[suite] FAILED (hard stage)" >&2
  exit 1
fi

echo "[suite] OK → $SUITE_OUT/SUITE-MANIFEST.json"
exit 0
