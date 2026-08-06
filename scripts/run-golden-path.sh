#!/usr/bin/env bash
# M1: Run Ferrum-GA4GH-Demo (Nextflow path), then HELIOS post-run audit, then write showcase-report.json.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$SHOWCASE_ROOT"

# HELIOS requires Python >= 3.11 (see HELIOS/pyproject.toml).
resolve_python() {
  if [[ -n "${SHOWCASE_PYTHON:-}" ]]; then
    if "${SHOWCASE_PYTHON}" -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 11) else 1)' 2>/dev/null; then
      echo "${SHOWCASE_PYTHON}"
      return 0
    fi
    echo "run-golden-path: SHOWCASE_PYTHON=$SHOWCASE_PYTHON is not Python 3.11+." >&2
    return 1
  fi
  for c in python3.13 python3.12 python3.11 python3; do
    command -v "$c" >/dev/null 2>&1 || continue
    if "$c" -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 11) else 1)' 2>/dev/null; then
      echo "$c"
      return 0
    fi
  done
  return 1
}

if ! PY="$(resolve_python)"; then
  echo "run-golden-path: need Python 3.11+ on PATH (HELIOS), or set SHOWCASE_PYTHON." >&2
  exit 1
fi

DEMO_ROOT="${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
HELIOS_ROOT="${SHOWCASE_HELIOS_ROOT:-$SHOWCASE_ROOT/../HELIOS}"
REPORT_OUT="${SHOWCASE_REPORT:-$SHOWCASE_ROOT/showcase-report.json}"
SKIP_DEMO="${SHOWCASE_SKIP_DEMO:-0}"
HEARTBEAT_SECONDS="${SHOWCASE_HEARTBEAT_SECONDS:-30}"
ENABLE_M2="${SHOWCASE_ENABLE_M2:-0}"
ENABLE_M2_START_BRA="${SHOWCASE_ENABLE_M2_START_BRA:-1}"
# handoff = copy VCF + m2-handoff.json only; full = handoff + DRS import + phenopacket link (M2.2)
M2_PIPELINE="${SHOWCASE_M2_PIPELINE:-handoff}"
ENABLE_SOLUM="${SHOWCASE_ENABLE_SOLUM:-0}"
ENABLE_EVIDENCE_PACK="${SHOWCASE_ENABLE_EVIDENCE_PACK:-0}"
ENABLE_CONSENT_GATE="${SHOWCASE_ENABLE_CONSENT_GATE:-0}"
ENABLE_GATK_RS="${SHOWCASE_ENABLE_GATK_RS:-0}"
ENABLE_GATK_RS_WES="${SHOWCASE_ENABLE_GATK_RS_WES:-0}"
ENABLE_S4MP="${SHOWCASE_ENABLE_S4MP:-0}"
CONSENT_GATE_MODE="${SHOWCASE_CONSENT_GATE_MODE:-allow}"
# Default: Nextflow only (aligns with HELIOS Nextflow parser). Extra flags: e.g. --macro
DEMO_FLAGS=(--nextflow)
if [[ -n "${SHOWCASE_DEMO_EXTRA:-}" ]]; then
  # shellcheck disable=SC2206
  DEMO_FLAGS+=($SHOWCASE_DEMO_EXTRA)
fi

usage() {
  cat <<'EOF'
Usage: scripts/run-golden-path.sh [--skip-demo] [--] [extra demo args...]

Environment:
  SHOWCASE_DEMO_ROOT     Path to Ferrum-GA4GH-Demo (default: ../Ferrum-GA4GH-Demo from showcase)
  SHOWCASE_HELIOS_ROOT   Path to HELIOS source for python -m helios.cli fallback
  SHOWCASE_REPORT        Output JSON path (default: ./showcase-report.json)
  SHOWCASE_SKIP_DEMO     If 1, skip ./run (use existing demo results/metrics.json)
  SHOWCASE_DEMO_EXTRA    Extra words appended to ./run --nextflow (e.g. "--macro")
  SHOWCASE_PYTHON        Python 3.11+ binary if python3 on PATH is too old
  SHOWCASE_HEARTBEAT_SECONDS  Heartbeat interval for long steps (default: 30, 0 disables)
  SHOWCASE_ENABLE_M2     If 1, run M2 handoff prep (bioresearch-assistant) after HELIOS
  SHOWCASE_ENABLE_M2_START_BRA  If 1, start bioresearch-assistant during M2 handoff
  SHOWCASE_M2_PIPELINE   handoff (default) or full (handoff + DRS import + phenopacket+VCF link)
  SHOWCASE_ENABLE_SOLUM  If 1, run Solum-Demo Stage-1 proofs after HELIOS/M2 (see run-solum-stage.sh)
  SHOWCASE_ENABLE_EVIDENCE_PACK  If 1, build Evidence Pack after stages (see evidence-pack.sh)
  SHOWCASE_ENABLE_CONSENT_GATE  If 1, PhenoFlow-purpose → Solum consent before WES (see run-consent-gate.sh)
  SHOWCASE_CONSENT_GATE_MODE    allow (default) or deny (blocks WES; writes blocked artefacts)
  SHOWCASE_ENABLE_GATK_RS  If 1, optional gatk-rs HC smoke after HELIOS (soft-fail; see run-gatk-rs-smoke.sh)
  SHOWCASE_ENABLE_GATK_RS_WES  If 1, optional Ferrum ./run --gatk-rs after default path (soft-fail; separate from Broad WES)
  SHOWCASE_ENABLE_S4MP     If 1, optional S4MP port-diff sidecar after HELIOS (see attach-s4mp-evidence.sh)

Requires: docker, bash, Python 3.11+ (demo scripts + HELIOS). HELIOS: helios on PATH, or HELIOS_ROOT for PYTHONPATH.
EOF
}

EXTRA_DEMO=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --skip-demo)
      SKIP_DEMO=1
      shift
      ;;
    --)
      shift
      EXTRA_DEMO+=("$@")
      break
      ;;
    *)
      EXTRA_DEMO+=("$1")
      shift
      ;;
  esac
done

run_helios() {
  if command -v helios >/dev/null 2>&1; then
    helios "$@"
  elif [[ -d "$HELIOS_ROOT/src/helios" ]]; then
    if ! PYTHONPATH="$HELIOS_ROOT/src${PYTHONPATH:+:$PYTHONPATH}" "$PY" -c "import typer" >/dev/null 2>&1; then
      echo "run-golden-path: HELIOS source fallback selected, but Python dependencies are missing (e.g. 'typer')." >&2
      echo "Install them once, for the same Python binary:" >&2
      echo "  \"$PY\" -m pip install -e \"$HELIOS_ROOT\"" >&2
      echo "Then rerun this script." >&2
      exit 1
    fi
    PYTHONPATH="$HELIOS_ROOT/src${PYTHONPATH:+:$PYTHONPATH}" "$PY" -m helios.cli "$@"
  else
    echo "run-golden-path: neither 'helios' on PATH nor HELIOS_ROOT=$HELIOS_ROOT/src/helios found." >&2
    exit 1
  fi
}

run_with_heartbeat() {
  local label="$1"
  shift
  local start_ts
  start_ts="$(date +%s)"
  "$@" &
  local cmd_pid=$!
  if [[ "$HEARTBEAT_SECONDS" -le 0 ]]; then
    wait "$cmd_pid"
    return $?
  fi
  while kill -0 "$cmd_pid" 2>/dev/null; do
    sleep "$HEARTBEAT_SECONDS"
    if kill -0 "$cmd_pid" 2>/dev/null; then
      local now elapsed
      now="$(date +%s)"
      elapsed=$((now - start_ts))
      echo "[showcase] heartbeat: ${label} still running (${elapsed}s elapsed)"
    fi
  done
  wait "$cmd_pid"
}

run_demo_command() {
  local demo_root="$1"
  shift
  cd "$demo_root"
  "$@"
}

DEMO_ROOT="$(cd "$DEMO_ROOT" && pwd)"

if [[ ! -x "$DEMO_ROOT/run" ]]; then
  echo "run-golden-path: demo not found or not executable: $DEMO_ROOT/run" >&2
  exit 1
fi

mkdir -p "$SHOWCASE_ROOT/.cache/helios/keys" "$SHOWCASE_ROOT/helios-reports"

export HELIOS_KEY_DIR="$SHOWCASE_ROOT/.cache/helios/keys"

if [[ ! -f "$SHOWCASE_ROOT/.cache/helios/keys/helios.key" ]]; then
  echo "[showcase] generating HELIOS signing key in $HELIOS_KEY_DIR ..."
  run_helios key generate
fi

# W3: optional consent gate before WES (PhenoFlow purpose → Solum status)
if [[ "$ENABLE_CONSENT_GATE" == "1" ]]; then
  echo "[showcase] consent gate mode=$CONSENT_GATE_MODE (technical purpose-binding — not legal consent)"
  GATE_ARGS=(--allow)
  if [[ "$CONSENT_GATE_MODE" == "deny" ]]; then
    GATE_ARGS=(--deny)
  fi
  run_with_heartbeat "Consent gate" "$SHOWCASE_ROOT/scripts/run-consent-gate.sh" "${GATE_ARGS[@]}"
  GATE_JSON="$SHOWCASE_ROOT/artifacts/consent-gate/consent-gate-result.json"
  if [[ ! -f "$GATE_JSON" ]]; then
    echo "run-golden-path: consent gate did not write $GATE_JSON" >&2
    exit 1
  fi
  WES_OK="$("$PY" -c 'import json,sys; d=json.load(open(sys.argv[1])); print("1" if d.get("wes_may_proceed") else "0")' "$GATE_JSON")"
  if [[ "$WES_OK" != "1" ]]; then
    echo "[showcase] consent gate blocked WES (wes_may_proceed=false) — skipping Ferrum demo + HELIOS"
    export SHOWCASE_ROOT REPORT_OUT
    "$PY" - <<'PY'
import json
import os
from datetime import datetime, timezone
from pathlib import Path
root = Path(os.environ["SHOWCASE_ROOT"])
report_out = Path(os.environ["REPORT_OUT"])
gate = json.loads((root / "artifacts/consent-gate/consent-gate-result.json").read_text())
report = {
  "schema_version": 1,
  "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
  "demo": {"wes_run_id": None, "wes_engine": None, "skipped": True, "reason": "consent_gate_blocked"},
  "helios": {},
  "consent_gate": {
    "decision": gate.get("decision"),
    "blocked": gate.get("blocked"),
    "wes_may_proceed": gate.get("wes_may_proceed"),
    "consent_status": gate.get("consent_status"),
    "purpose": gate.get("purpose"),
    "subject": gate.get("subject"),
    "honesty": gate.get("honesty"),
    "result_path": str(root / "artifacts/consent-gate/consent-gate-result.json"),
  },
  "steps": [{"name": "consent_gate", "status": "blocked", "decision": gate.get("decision")}],
}
report_out.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
md = report_out.with_suffix(".md")
lines = [
  "# Showcase Report (consent gate blocked)",
  "",
  f"- Decision: `{gate.get('decision')}`",
  f"- Consent status: `{gate.get('consent_status')}`",
  f"- Subject: `{gate.get('subject')}`",
  f"- Purpose: `{gate.get('purpose')}`",
  f"- WES skipped: `true`",
  "",
  "## Honesty",
  "",
  str(gate.get("honesty") or ""),
  "",
]
md.write_text("\n".join(lines), encoding="utf-8")
print(json.dumps({"ok": True, "blocked": True, "wrote": str(report_out), "wrote_markdown": str(md)}))
PY
    if [[ "$ENABLE_EVIDENCE_PACK" == "1" ]]; then
      "$SHOWCASE_ROOT/scripts/evidence-pack.sh" || true
    fi
    echo "[showcase] blocked path complete — see $REPORT_OUT and artifacts/consent-gate/"
    exit 0
  fi
fi

DEMO_SEC=""
if [[ "$SKIP_DEMO" != "1" ]]; then
  RUN_CMD=(bash ./run "${DEMO_FLAGS[@]}")
  if ((${#EXTRA_DEMO[@]} > 0)); then
    RUN_CMD+=("${EXTRA_DEMO[@]}")
  fi
  echo "[showcase] running Ferrum GA4GH demo: $DEMO_ROOT/run ${DEMO_FLAGS[*]} ${EXTRA_DEMO[*]-}"
  T0="$(date +%s)"
  run_with_heartbeat "Ferrum-GA4GH-Demo ./run" run_demo_command "$DEMO_ROOT" "${RUN_CMD[@]}"
  T1="$(date +%s)"
  DEMO_SEC=$((T1 - T0))
else
  echo "[showcase] skipping demo (SHOWCASE_SKIP_DEMO=1); using existing $DEMO_ROOT/results/"
fi

METRICS="$DEMO_ROOT/results/metrics.json"
if [[ ! -f "$METRICS" ]]; then
  echo "run-golden-path: missing $METRICS (demo did not produce metrics?)" >&2
  exit 1
fi

WES_RUN_ID="$("$PY" -c "import json,sys; print(json.load(open(sys.argv[1]))['wes_run_id'])" "$METRICS")"
WES_WORK_HOST="${FERRUM_GA4GH_WES_HOST_OVERRIDE:-$DEMO_ROOT/results/wes-work}"
WORK_DIR="$WES_WORK_HOST/$WES_RUN_ID"
OUTPUT_DIR="$DEMO_ROOT/results"

if [[ ! -d "$WORK_DIR" ]]; then
  echo "run-golden-path: WES work dir not found: $WORK_DIR" >&2
  exit 1
fi

echo "[showcase] HELIOS audit (nextflow) work_dir=$WORK_DIR output_dir=$OUTPUT_DIR"

HELIOS_SEC=""
T0="$(date +%s)"
(
  cd "$SHOWCASE_ROOT"
  run_with_heartbeat "HELIOS audit" run_helios run --pipeline nextflow \
    --work-dir "$WORK_DIR" \
    --output-dir "$OUTPUT_DIR" \
    --config "$SHOWCASE_ROOT/helios.toml" \
    --export json
)
T1="$(date +%s)"
HELIOS_SEC=$((T1 - T0))

# Newest HELIOS JSON export in this repo's helios-reports/
HELIOS_JSON="$(ls -t "$SHOWCASE_ROOT/helios-reports"/*.json 2>/dev/null | head -1 || true)"
if [[ -z "$HELIOS_JSON" ]]; then
  echo "run-golden-path: no JSON report under $SHOWCASE_ROOT/helios-reports" >&2
  exit 1
fi

DEMO_SEC_ARG=()
[[ -n "$DEMO_SEC" ]] && DEMO_SEC_ARG=(--demo-seconds "$DEMO_SEC")
HELIOS_SEC_ARG=(--helios-seconds "$HELIOS_SEC")
ASSEMBLE_CMD=(
  "$PY" "$SHOWCASE_ROOT/scripts/assemble_showcase_report.py"
  --showcase-root "$SHOWCASE_ROOT"
  --demo-root "$DEMO_ROOT"
  --output "$REPORT_OUT"
  --helios-report "$HELIOS_JSON"
  "${HELIOS_SEC_ARG[@]}"
)
if ((${#DEMO_SEC_ARG[@]} > 0)); then
  ASSEMBLE_CMD+=("${DEMO_SEC_ARG[@]}")
fi

"${ASSEMBLE_CMD[@]}"

if [[ "$ENABLE_M2" == "1" ]]; then
  if [[ "$M2_PIPELINE" == "full" ]]; then
    echo "[showcase] running M2 full downstream (handoff + DRS import + phenopacket link)..."
    SHOWCASE_M2_START_BRA="$ENABLE_M2_START_BRA" \
      run_with_heartbeat "M2 downstream" "$SHOWCASE_ROOT/scripts/run-m2-bioresearch-downstream.sh"
  else
    echo "[showcase] running M2 handoff preparation..."
    SHOWCASE_M2_START_BRA="$ENABLE_M2_START_BRA" \
      run_with_heartbeat "M2 handoff" "$SHOWCASE_ROOT/scripts/run-m2-bioresearch.sh"
  fi
  "${ASSEMBLE_CMD[@]}"
fi

if [[ "$ENABLE_SOLUM" == "1" ]]; then
  echo "[showcase] running Solum stage (Solum-Demo Stage-1 proofs)..."
  run_with_heartbeat "Solum stage" "$SHOWCASE_ROOT/scripts/run-solum-stage.sh"
  "${ASSEMBLE_CMD[@]}"
fi

# W4 optional path: soft-fail (products unstable). Never replaces default Nextflow WES.
if [[ "$ENABLE_GATK_RS" == "1" ]]; then
  echo "[showcase] optional gatk-rs smoke (soft-fail; does not replace Ferrum WES)..."
  "$SHOWCASE_ROOT/scripts/run-gatk-rs-smoke.sh" || true
  "${ASSEMBLE_CMD[@]}"
fi

if [[ "$ENABLE_GATK_RS_WES" == "1" ]]; then
  echo "[showcase] optional Ferrum --gatk-rs WES (soft-fail; separate from Broad path above)..."
  "$SHOWCASE_ROOT/scripts/run-gatk-rs-wes.sh" || true
  "${ASSEMBLE_CMD[@]}"
fi

if [[ "$ENABLE_S4MP" == "1" ]]; then
  echo "[showcase] optional S4MP port-evidence sidecar (soft-fail; not a WES executor)..."
  "$SHOWCASE_ROOT/scripts/attach-s4mp-evidence.sh" || true
  "${ASSEMBLE_CMD[@]}"
fi

if [[ "$ENABLE_EVIDENCE_PACK" == "1" ]]; then
  echo "[showcase] building Evidence Pack..."
  run_with_heartbeat "Evidence Pack" "$SHOWCASE_ROOT/scripts/evidence-pack.sh"
fi

echo "[showcase] wrote $REPORT_OUT"
cat "$REPORT_OUT"
