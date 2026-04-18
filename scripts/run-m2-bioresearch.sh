#!/usr/bin/env bash
# M2 skeleton: prepare handoff from Ferrum-GA4GH-Demo output to bioresearch-assistant.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=lib/bra-compose.sh
source "$SCRIPT_DIR/lib/bra-compose.sh"

DEMO_ROOT="${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
BRA_ROOT="${SHOWCASE_BRA_ROOT:-$SHOWCASE_ROOT/../bioresearch-assistant}"
M2_DIR="${SHOWCASE_M2_DIR:-$SHOWCASE_ROOT/artifacts/m2}"
START_BRA="${SHOWCASE_M2_START_BRA:-0}"

usage() {
  cat <<'EOF'
Usage: scripts/run-m2-bioresearch.sh [--start-bra]

Environment:
  SHOWCASE_DEMO_ROOT      Path to Ferrum-GA4GH-Demo (default: ../Ferrum-GA4GH-Demo)
  SHOWCASE_BRA_ROOT       Path to bioresearch-assistant (default: ../bioresearch-assistant)
  SHOWCASE_M2_DIR         Output directory for M2 handoff artifacts (default: ./artifacts/m2)
  SHOWCASE_M2_START_BRA   If 1, run docker compose up -d in SHOWCASE_BRA_ROOT
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --start-bra)
      START_BRA=1
      shift
      ;;
    *)
      echo "run-m2-bioresearch: unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

DEMO_ROOT="$(cd "$DEMO_ROOT" && pwd)"
BRA_ROOT="$(cd "$BRA_ROOT" && pwd)"
M2_DIR="$(mkdir -p "$M2_DIR" && cd "$M2_DIR" && pwd)"

METRICS="$DEMO_ROOT/results/metrics.json"
QUERY_VCF="$DEMO_ROOT/results/query.vcf.gz"
QUERY_VCF_TBI="$DEMO_ROOT/results/query.vcf.gz.tbi"

[[ -f "$METRICS" ]] || { echo "run-m2-bioresearch: missing $METRICS" >&2; exit 1; }
[[ -f "$QUERY_VCF" ]] || { echo "run-m2-bioresearch: missing $QUERY_VCF" >&2; exit 1; }

mkdir -p "$M2_DIR/input"
cp -f "$QUERY_VCF" "$M2_DIR/input/query.vcf.gz"
if [[ -f "$QUERY_VCF_TBI" ]]; then
  cp -f "$QUERY_VCF_TBI" "$M2_DIR/input/query.vcf.gz.tbi"
fi

if [[ "$START_BRA" == "1" ]]; then
  if [[ ! -f "$BRA_ROOT/docker-compose.yml" ]]; then
    echo "run-m2-bioresearch: SHOWCASE_BRA_ROOT has no docker-compose.yml: $BRA_ROOT" >&2
    exit 1
  fi
  echo "[m2] starting bioresearch-assistant stack..."
  bra_docker_compose "$BRA_ROOT" "$SHOWCASE_ROOT" up -d
fi

WES_RUN_ID="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["wes_run_id"])' "$METRICS")"
WES_ENGINE="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("wes_engine","unknown"))' "$METRICS")"

cat > "$M2_DIR/m2-handoff.json" <<EOF
{
  "schema_version": 1,
  "status": "prepared",
  "source": {
    "demo_root": "$DEMO_ROOT",
    "metrics_path": "$METRICS",
    "wes_run_id": "$WES_RUN_ID",
    "wes_engine": "$WES_ENGINE"
  },
  "artifacts": {
    "query_vcf": "$M2_DIR/input/query.vcf.gz",
    "query_vcf_index": "$M2_DIR/input/query.vcf.gz.tbi"
  },
  "bioresearch_assistant": {
    "root": "$BRA_ROOT",
    "start_attempted": $( [[ "$START_BRA" == "1" ]] && echo "true" || echo "false" ),
    "frontend_url": "http://localhost:3000",
    "backend_url": "http://localhost:8000",
    "next_steps": [
      "Open the app and create/select a project",
      "Upload query_vcf from artifacts.query_vcf",
      "Run interpretation or downstream analysis workflow",
      "Capture resulting report/export and reference this handoff file"
    ]
  }
}
EOF

echo "{\"ok\":true,\"wrote\":\"$M2_DIR/m2-handoff.json\"}"
