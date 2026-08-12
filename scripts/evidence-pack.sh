#!/usr/bin/env bash
# W2: Build a Showcase Evidence Pack (HELIOS + DRS hashes + optional HelixTest/Solum).
#
# Fixture mode (CI / no Docker):
#   ./scripts/evidence-pack.sh --fixtures
#
# Live / post-golden-path (auto-discovers newest helios-reports + demo results):
#   ./scripts/evidence-pack.sh
#
# Optional HelixTest (never hard-fails the pack if missing unless --require-helixtest):
#   SHOWCASE_RUN_HELIXTEST=1 ./scripts/evidence-pack.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$SHOWCASE_ROOT"

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

if ! PY="$(resolve_python)"; then
  echo "evidence-pack: need python3 on PATH (or SHOWCASE_PYTHON)" >&2
  exit 1
fi

MODE="live"
REQUIRE_HELIXTEST=0
RUN_HELIXTEST="${SHOWCASE_RUN_HELIXTEST:-0}"
PACK_ID="${SHOWCASE_EVIDENCE_PACK_ID:-}"
OUT_PARENT="${SHOWCASE_EVIDENCE_PACK_PARENT:-$SHOWCASE_ROOT/artifacts}"

HELIOS_REPORT="${SHOWCASE_HELIOS_REPORT:-}"
DRS_JSON="${SHOWCASE_DRS_JSON:-}"
METRICS_JSON="${SHOWCASE_METRICS_JSON:-}"
BENCHMARK_JSON="${SHOWCASE_BENCHMARK_JSON:-}"
HELIXTEST_JSON="${SHOWCASE_HELIXTEST_JSON:-}"
SOLUM_RESULT="${SHOWCASE_SOLUM_RESULT:-}"
SOLUM_CDR="${SHOWCASE_SOLUM_CDR_JSON:-}"
SOLUM_SUBJECT_LINK="${SHOWCASE_SOLUM_SUBJECT_LINK_JSON:-}"
SOLUM_AUDIT_EXPORT="${SHOWCASE_SOLUM_AUDIT_EXPORT:-}"
CONSENT_GATE="${SHOWCASE_CONSENT_GATE_JSON:-}"
GATK_RS_SMOKE="${SHOWCASE_GATK_RS_SMOKE_JSON:-}"
GATK_RS_WES="${SHOWCASE_GATK_RS_WES_JSON:-}"
S4MP_EVIDENCE="${SHOWCASE_S4MP_EVIDENCE_JSON:-}"
S4MP_REPORT="${SHOWCASE_S4MP_REPORT:-}"
CO_DEPLOY_RESULTS="${SHOWCASE_CO_DEPLOY_RESULTS_JSON:-}"
CO_DEPLOY_HARVEST="${SHOWCASE_CO_DEPLOY_HARVEST_JSON:-}"
SHOWCASE_REPORT_JSON="${SHOWCASE_REPORT:-$SHOWCASE_ROOT/showcase-report.json}"
SHOWCASE_REPORT_MD="${SHOWCASE_REPORT_MD:-$SHOWCASE_ROOT/showcase-report.md}"
DEMO_ROOT="${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
HELIXTEST_ROOT="${SHOWCASE_HELIXTEST_ROOT:-$SHOWCASE_ROOT/../HelixTest}"
GATEWAY_BASE="${SHOWCASE_FERRUM_GATEWAY:-http://127.0.0.1:18080}"
HARVEST_CO_DEPLOY="${SHOWCASE_HARVEST_CO_DEPLOY:-0}"

usage() {
  cat <<'EOF'
Usage: scripts/evidence-pack.sh [--fixtures] [--require-helixtest] [--run-helixtest]

Environment (optional overrides):
  SHOWCASE_HELIOS_REPORT / SHOWCASE_DRS_JSON / SHOWCASE_METRICS_JSON /
  SHOWCASE_BENCHMARK_JSON / SHOWCASE_HELIXTEST_JSON / SHOWCASE_SOLUM_RESULT
  SHOWCASE_EVIDENCE_PACK_ID   Fixed pack id (default: UTC timestamp)
  SHOWCASE_RUN_HELIXTEST=1    Attempt live HelixTest scores JSON before packing
  SHOWCASE_HELIXTEST_ROOT     Sibling HelixTest checkout
  SHOWCASE_FERRUM_GATEWAY     Default http://127.0.0.1:18080 (DRS/WES service-info)

Outputs:
  artifacts/evidence-pack-<id>/MANIFEST.json
  artifacts/evidence-pack-<id>/README.md
  + copied artefact JSON files
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --fixtures) MODE="fixtures"; shift ;;
    --require-helixtest) REQUIRE_HELIXTEST=1; shift ;;
    --run-helixtest) RUN_HELIXTEST=1; shift ;;
    *)
      echo "evidence-pack: unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

resolve_helixtest_bin() {
  if command -v helixtest >/dev/null 2>&1; then
    command -v helixtest
    return 0
  fi
  local cand
  for cand in \
    "$HELIXTEST_ROOT/target/release/helixtest" \
    "$HELIXTEST_ROOT/helixtest/target/release/helixtest" \
    "$HELIXTEST_ROOT/target/debug/helixtest"
  do
    if [[ -x "$cand" ]]; then
      echo "$cand"
      return 0
    fi
  done
  return 1
}

maybe_run_helixtest() {
  [[ "$RUN_HELIXTEST" == "1" ]] || return 0
  local bin out
  if ! bin="$(resolve_helixtest_bin)"; then
    echo "[evidence-pack] HelixTest binary not found (set SHOWCASE_HELIXTEST_ROOT or PATH)" >&2
    [[ "$REQUIRE_HELIXTEST" == "1" ]] && return 1
    return 0
  fi
  mkdir -p "$SHOWCASE_ROOT/artifacts/helixtest"
  out="$SHOWCASE_ROOT/artifacts/helixtest/scores.json"
  echo "[evidence-pack] running HelixTest scores against $GATEWAY_BASE …"
  # Best-effort: DRS+WES service-info oriented smoke via --report scores when stack is up.
  # Full suite is documented in docs/for-evaluators/helixtest-gate.md — do not hard-wire --all here.
  if ! (
    cd "$(dirname "$bin")/.." 2>/dev/null || cd "$HELIXTEST_ROOT"
    DRS_URL="${DRS_URL:-$GATEWAY_BASE/ga4gh/drs/v1}" \
    WES_URL="${WES_URL:-$GATEWAY_BASE/ga4gh/wes/v1}" \
    "$bin" --service drs --service wes --mode ferrum --report scores >"$out"
  ); then
    echo "[evidence-pack] HelixTest run failed (pack continues unless --require-helixtest)" >&2
    rm -f "$out"
    [[ "$REQUIRE_HELIXTEST" == "1" ]] && return 1
    return 0
  fi
  HELIXTEST_JSON="$out"
  echo "[evidence-pack] wrote $HELIXTEST_JSON"
}

if [[ "$MODE" == "fixtures" ]]; then
  HELIOS_REPORT="${HELIOS_REPORT:-$SHOWCASE_ROOT/fixtures/ci/helios/report.json}"
  # Prefer committed example DRS link for stakeholder narrative; fall back to micro bench.
  if [[ -z "$DRS_JSON" ]]; then
    if [[ -f "$SHOWCASE_ROOT/demo/results/drs-link-example.json" ]]; then
      DRS_JSON="$SHOWCASE_ROOT/demo/results/drs-link-example.json"
    else
      DRS_JSON="$SHOWCASE_ROOT/fixtures/ci/demo/results/drs_micro.json"
    fi
  fi
  METRICS_JSON="${METRICS_JSON:-$SHOWCASE_ROOT/fixtures/ci/demo/results/metrics.json}"
  BENCHMARK_JSON="${BENCHMARK_JSON:-$SHOWCASE_ROOT/fixtures/ci/demo/results/benchmark.json}"
  HELIXTEST_JSON="${HELIXTEST_JSON:-$SHOWCASE_ROOT/fixtures/ci/helixtest/scores-example.json}"
  SOLUM_RESULT="${SOLUM_RESULT:-$SHOWCASE_ROOT/fixtures/ci/solum/solum-stage-result.json}"
  SOLUM_CDR="${SOLUM_CDR:-$SHOWCASE_ROOT/fixtures/ci/solum-cdr/cdr-composition-fixture.json}"
  SOLUM_SUBJECT_LINK="${SOLUM_SUBJECT_LINK:-$SHOWCASE_ROOT/fixtures/ci/solum-cdr/subject-link-fixture.json}"
  SOLUM_AUDIT_EXPORT="${SOLUM_AUDIT_EXPORT:-$SHOWCASE_ROOT/fixtures/ci/solum/solum-audit-helios-chain.json}"
  CONSENT_GATE="${CONSENT_GATE:-$SHOWCASE_ROOT/fixtures/ci/consent-gate/consent-gate-result.json}"
  GATK_RS_SMOKE="${GATK_RS_SMOKE:-$SHOWCASE_ROOT/fixtures/ci/gatk-rs/gatk-rs-smoke-result.json}"
  S4MP_EVIDENCE="${S4MP_EVIDENCE:-$SHOWCASE_ROOT/fixtures/ci/s4mp/s4mp-evidence.json}"
  S4MP_REPORT="${S4MP_REPORT:-$SHOWCASE_ROOT/fixtures/ci/s4mp/diff-report.md}"
  CO_DEPLOY_RESULTS="${CO_DEPLOY_RESULTS:-$SHOWCASE_ROOT/fixtures/ci/ga4gh-infra/co_deploy_results.json}"
  if [[ -z "$CO_DEPLOY_HARVEST" ]]; then
    # Ensure harvest pointer exists next to fixture results for pack summary.
    ./scripts/harvest-co-deploy.sh --fixtures >/dev/null 2>&1 || true
    if [[ -f "$SHOWCASE_ROOT/artifacts/ga4gh-infra/co-deploy-harvest.json" ]]; then
      CO_DEPLOY_HARVEST="$SHOWCASE_ROOT/artifacts/ga4gh-infra/co-deploy-harvest.json"
    fi
  fi
  if [[ -f "$SHOWCASE_ROOT/demo/results/showcase-report-example.md" ]]; then
    SHOWCASE_REPORT_MD="$SHOWCASE_ROOT/demo/results/showcase-report-example.md"
  fi
  # Fixture mode should not require a live showcase-report.json
  [[ -f "$SHOWCASE_REPORT_JSON" ]] || SHOWCASE_REPORT_JSON=""
  PACK_ID="${PACK_ID:-fixtures}"
else
  maybe_run_helixtest

  if [[ "${HARVEST_CO_DEPLOY}" == "1" || "${SHOWCASE_ENABLE_CO_DEPLOY_HARVEST:-0}" == "1" ]]; then
    echo "[evidence-pack] harvesting ga4gh-infra co-deploy (soft)…"
    ./scripts/harvest-co-deploy.sh || true
  fi

  if [[ -z "$HELIOS_REPORT" ]]; then
    HELIOS_REPORT="$(ls -t "$SHOWCASE_ROOT/helios-reports"/*.json 2>/dev/null | head -1 || true)"
  fi
  if [[ -z "$HELIOS_REPORT" && -f "$SHOWCASE_ROOT/demo/results/helios-report-example.json" ]]; then
    echo "[evidence-pack] no helios-reports/; using demo/results/helios-report-example.json"
    HELIOS_REPORT="$SHOWCASE_ROOT/demo/results/helios-report-example.json"
  fi
  if [[ -z "$DRS_JSON" ]]; then
    if [[ -f "$DEMO_ROOT/results/drs_micro.json" ]]; then
      # Prefer object link example when present in showcase demo/results
      if [[ -f "$SHOWCASE_ROOT/demo/results/drs-link-example.json" ]]; then
        DRS_JSON="$SHOWCASE_ROOT/demo/results/drs-link-example.json"
      else
        DRS_JSON="$DEMO_ROOT/results/drs_micro.json"
      fi
    elif [[ -f "$SHOWCASE_ROOT/demo/results/drs-link-example.json" ]]; then
      DRS_JSON="$SHOWCASE_ROOT/demo/results/drs-link-example.json"
    fi
  fi
  if [[ -z "$METRICS_JSON" && -f "$DEMO_ROOT/results/metrics.json" ]]; then
    METRICS_JSON="$DEMO_ROOT/results/metrics.json"
  elif [[ -z "$METRICS_JSON" && -f "$SHOWCASE_ROOT/demo/results/metrics.json" ]]; then
    METRICS_JSON="$SHOWCASE_ROOT/demo/results/metrics.json"
  fi
  if [[ -z "$BENCHMARK_JSON" && -f "$DEMO_ROOT/results/benchmark.json" ]]; then
    BENCHMARK_JSON="$DEMO_ROOT/results/benchmark.json"
  elif [[ -z "$BENCHMARK_JSON" && -f "$SHOWCASE_ROOT/demo/results/benchmark.json" ]]; then
    BENCHMARK_JSON="$SHOWCASE_ROOT/demo/results/benchmark.json"
  fi
  if [[ -z "$HELIXTEST_JSON" && -f "$SHOWCASE_ROOT/artifacts/helixtest/scores.json" ]]; then
    HELIXTEST_JSON="$SHOWCASE_ROOT/artifacts/helixtest/scores.json"
  fi
  if [[ -z "$SOLUM_RESULT" && -f "$SHOWCASE_ROOT/artifacts/solum/solum-stage-result.json" ]]; then
    SOLUM_RESULT="$SHOWCASE_ROOT/artifacts/solum/solum-stage-result.json"
  elif [[ -z "$SOLUM_RESULT" && -f "$SHOWCASE_ROOT/demo/results/solum-stage-result-example.json" ]]; then
    SOLUM_RESULT="$SHOWCASE_ROOT/demo/results/solum-stage-result-example.json"
  fi
  if [[ -z "$SOLUM_AUDIT_EXPORT" && -f "$SHOWCASE_ROOT/artifacts/solum/solum-audit-helios-chain.json" ]]; then
    SOLUM_AUDIT_EXPORT="$SHOWCASE_ROOT/artifacts/solum/solum-audit-helios-chain.json"
  fi
  if [[ -z "$SOLUM_SUBJECT_LINK" && -f "$SHOWCASE_ROOT/artifacts/solum/subject-link.json" ]]; then
    SOLUM_SUBJECT_LINK="$SHOWCASE_ROOT/artifacts/solum/subject-link.json"
  fi
  if [[ -z "$CONSENT_GATE" && -f "$SHOWCASE_ROOT/artifacts/consent-gate/consent-gate-result.json" ]]; then
    CONSENT_GATE="$SHOWCASE_ROOT/artifacts/consent-gate/consent-gate-result.json"
  elif [[ -z "$CONSENT_GATE" && -f "$SHOWCASE_ROOT/demo/results/consent-gate-allow-example.json" ]]; then
    CONSENT_GATE="$SHOWCASE_ROOT/demo/results/consent-gate-allow-example.json"
  fi
  if [[ -z "$GATK_RS_SMOKE" && -f "$SHOWCASE_ROOT/artifacts/gatk-rs/gatk-rs-smoke-result.json" ]]; then
    GATK_RS_SMOKE="$SHOWCASE_ROOT/artifacts/gatk-rs/gatk-rs-smoke-result.json"
  elif [[ -z "$GATK_RS_SMOKE" && -f "$SHOWCASE_ROOT/demo/results/gatk-rs-smoke-result-example.json" ]]; then
    GATK_RS_SMOKE="$SHOWCASE_ROOT/demo/results/gatk-rs-smoke-result-example.json"
  fi
  if [[ -z "$GATK_RS_WES" && -f "$SHOWCASE_ROOT/artifacts/gatk-rs-wes/gatk-rs-wes-result.json" ]]; then
    GATK_RS_WES="$SHOWCASE_ROOT/artifacts/gatk-rs-wes/gatk-rs-wes-result.json"
  elif [[ -z "$GATK_RS_WES" && -f "$SHOWCASE_ROOT/demo/results/gatk-rs-wes-result-example.json" ]]; then
    GATK_RS_WES="$SHOWCASE_ROOT/demo/results/gatk-rs-wes-result-example.json"
  fi
  if [[ -z "$S4MP_EVIDENCE" && -f "$SHOWCASE_ROOT/artifacts/s4mp/s4mp-evidence.json" ]]; then
    S4MP_EVIDENCE="$SHOWCASE_ROOT/artifacts/s4mp/s4mp-evidence.json"
  elif [[ -z "$S4MP_EVIDENCE" && -f "$SHOWCASE_ROOT/demo/results/s4mp-evidence-example.json" ]]; then
    S4MP_EVIDENCE="$SHOWCASE_ROOT/demo/results/s4mp-evidence-example.json"
  fi
  if [[ -z "$S4MP_REPORT" && -f "$SHOWCASE_ROOT/artifacts/s4mp/diff-report.md" ]]; then
    S4MP_REPORT="$SHOWCASE_ROOT/artifacts/s4mp/diff-report.md"
  fi
  if [[ -z "$CO_DEPLOY_RESULTS" && -f "$SHOWCASE_ROOT/artifacts/ga4gh-infra/co_deploy_results.json" ]]; then
    CO_DEPLOY_RESULTS="$SHOWCASE_ROOT/artifacts/ga4gh-infra/co_deploy_results.json"
  elif [[ -z "$CO_DEPLOY_RESULTS" && -f "$DEMO_ROOT/results/co_deploy_results.json" ]]; then
    # Only auto-include Demo artefact when scenarios actually ran (not the default skip stub).
    if "$PY" -c "
import json,sys
s=json.load(open(sys.argv[1])).get('summary') or {}
sys.exit(0 if int(s.get('ran') or 0)>0 else 1)
" "$DEMO_ROOT/results/co_deploy_results.json"; then
      CO_DEPLOY_RESULTS="$DEMO_ROOT/results/co_deploy_results.json"
    fi
  elif [[ -z "$CO_DEPLOY_RESULTS" && -f "$SHOWCASE_ROOT/demo/results/co_deploy_results-example.json" ]]; then
    CO_DEPLOY_RESULTS="$SHOWCASE_ROOT/demo/results/co_deploy_results-example.json"
  fi
  if [[ -z "$CO_DEPLOY_HARVEST" && -f "$SHOWCASE_ROOT/artifacts/ga4gh-infra/co-deploy-harvest.json" ]]; then
    CO_DEPLOY_HARVEST="$SHOWCASE_ROOT/artifacts/ga4gh-infra/co-deploy-harvest.json"
  elif [[ -z "$CO_DEPLOY_HARVEST" && -f "$SHOWCASE_ROOT/demo/results/co-deploy-harvest-example.json" ]]; then
    CO_DEPLOY_HARVEST="$SHOWCASE_ROOT/demo/results/co-deploy-harvest-example.json"
  fi
  [[ -f "$SHOWCASE_REPORT_JSON" ]] || SHOWCASE_REPORT_JSON=""
  [[ -f "$SHOWCASE_REPORT_MD" ]] || SHOWCASE_REPORT_MD=""
fi

if [[ -z "${HELIOS_REPORT:-}" || ! -f "$HELIOS_REPORT" ]]; then
  echo "evidence-pack: HELIOS report not found (run golden path or use --fixtures)" >&2
  exit 1
fi

if [[ "$REQUIRE_HELIXTEST" == "1" ]]; then
  if [[ -z "${HELIXTEST_JSON:-}" || ! -f "$HELIXTEST_JSON" ]]; then
    echo "evidence-pack: --require-helixtest but no HelixTest JSON available" >&2
    exit 1
  fi
fi

if [[ -z "$PACK_ID" ]]; then
  PACK_ID="$(date -u +%Y%m%dT%H%M%SZ)"
fi
OUT_DIR="$OUT_PARENT/evidence-pack-$PACK_ID"
mkdir -p "$OUT_PARENT"

ARGS=(
  "$PY" "$SHOWCASE_ROOT/scripts/evidence_pack.py"
  --showcase-root "$SHOWCASE_ROOT"
  --output-dir "$OUT_DIR"
  --pack-id "$PACK_ID"
  --mode "$MODE"
  --helios-report "$HELIOS_REPORT"
)
[[ -n "${DRS_JSON:-}" && -f "$DRS_JSON" ]] && ARGS+=(--drs-json "$DRS_JSON")
[[ -n "${METRICS_JSON:-}" && -f "$METRICS_JSON" ]] && ARGS+=(--metrics-json "$METRICS_JSON")
[[ -n "${BENCHMARK_JSON:-}" && -f "$BENCHMARK_JSON" ]] && ARGS+=(--benchmark-json "$BENCHMARK_JSON")
[[ -n "${HELIXTEST_JSON:-}" && -f "$HELIXTEST_JSON" ]] && ARGS+=(--helixtest-json "$HELIXTEST_JSON")
[[ -n "${SOLUM_RESULT:-}" && -f "$SOLUM_RESULT" ]] && ARGS+=(--solum-result "$SOLUM_RESULT")
[[ -n "${SOLUM_CDR:-}" && -f "$SOLUM_CDR" ]] && ARGS+=(--solum-cdr "$SOLUM_CDR")
[[ -n "${SOLUM_SUBJECT_LINK:-}" && -f "$SOLUM_SUBJECT_LINK" ]] && ARGS+=(--solum-subject-link "$SOLUM_SUBJECT_LINK")
[[ -n "${SOLUM_AUDIT_EXPORT:-}" && -f "$SOLUM_AUDIT_EXPORT" ]] && ARGS+=(--solum-audit-export "$SOLUM_AUDIT_EXPORT")
[[ -n "${CONSENT_GATE:-}" && -f "$CONSENT_GATE" ]] && ARGS+=(--consent-gate "$CONSENT_GATE")
[[ -n "${GATK_RS_SMOKE:-}" && -f "$GATK_RS_SMOKE" ]] && ARGS+=(--gatk-rs-smoke "$GATK_RS_SMOKE")
[[ -n "${GATK_RS_WES:-}" && -f "$GATK_RS_WES" ]] && ARGS+=(--gatk-rs-wes "$GATK_RS_WES")
[[ -n "${S4MP_EVIDENCE:-}" && -f "$S4MP_EVIDENCE" ]] && ARGS+=(--s4mp-evidence "$S4MP_EVIDENCE")
[[ -n "${S4MP_REPORT:-}" && -f "$S4MP_REPORT" ]] && ARGS+=(--s4mp-report "$S4MP_REPORT")
[[ -n "${CO_DEPLOY_RESULTS:-}" && -f "$CO_DEPLOY_RESULTS" ]] && ARGS+=(--co-deploy-results "$CO_DEPLOY_RESULTS")
[[ -n "${CO_DEPLOY_HARVEST:-}" && -f "$CO_DEPLOY_HARVEST" ]] && ARGS+=(--co-deploy-harvest "$CO_DEPLOY_HARVEST")
[[ -n "${SHOWCASE_REPORT_JSON:-}" && -f "$SHOWCASE_REPORT_JSON" ]] && ARGS+=(--showcase-report "$SHOWCASE_REPORT_JSON")
[[ -n "${SHOWCASE_REPORT_MD:-}" && -f "$SHOWCASE_REPORT_MD" ]] && ARGS+=(--showcase-report-md "$SHOWCASE_REPORT_MD")

"${ARGS[@]}"

# Convenience copy for latest
rm -f "$OUT_PARENT/evidence-pack-latest"
ln -s "evidence-pack-$PACK_ID" "$OUT_PARENT/evidence-pack-latest" 2>/dev/null || true

echo "[evidence-pack] done → $OUT_DIR"
echo "[evidence-pack] read $OUT_DIR/README.md"
