#!/usr/bin/env bash
# W4: Optional gatk-rs HaplotypeCaller smoke (NOT the default Ferrum Nextflow GIAB path).
#
# gatk-rs is Alpha / often unstable. This stage soft-fails by default: always writes a
# result JSON and exits 0 unless SHOWCASE_GATK_RS_STRICT=1.
#
# Modes:
#   (default)   Prefer local release binary, else docker image; run tiny fixture HC
#   --fixtures  Write committed fixture artefacts (CI / no binary)
#
# Golden path: SHOWCASE_ENABLE_GATK_RS=1 (after HELIOS; does not replace Java GATK WES)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

GATK_RS_ROOT="${SHOWCASE_GATK_RS_ROOT:-$SHOWCASE_ROOT/../gatk-rs}"
OUT_DIR="${SHOWCASE_GATK_RS_OUT:-$SHOWCASE_ROOT/artifacts/gatk-rs}"
STRICT="${SHOWCASE_GATK_RS_STRICT:-0}"
DOCKER_IMAGE="${SHOWCASE_GATK_RS_IMAGE:-}"
PUBLISH_EXAMPLES="${SHOWCASE_GATK_RS_PUBLISH_EXAMPLES:-0}"
MODE="live"

usage() {
  cat <<'EOF'
Usage: scripts/run-gatk-rs-smoke.sh [--fixtures] [--publish-examples]

Environment:
  SHOWCASE_GATK_RS_ROOT     Sibling gatk-rs checkout (default ../gatk-rs)
  SHOWCASE_GATK_RS_IMAGE    Optional docker image (e.g. gatkr/gatk-rs:latest)
  SHOWCASE_GATK_RS_STRICT=1 Exit non-zero on skip/fail (default: soft-fail, exit 0)
  SHOWCASE_GATK_RS_OUT      Artefact directory (default artifacts/gatk-rs)

Honesty: smoke proves local binary/image can emit a VCF header on a tiny fixture —
not GIAB equivalence, clinical validity, or Ferrum WES integration.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --fixtures) MODE="fixtures"; shift ;;
    --publish-examples) PUBLISH_EXAMPLES=1; shift ;;
    *)
      echo "run-gatk-rs-smoke: unknown argument: $1" >&2
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
  echo "[gatk-rs-smoke] status=$status${detail:+ ($detail)} → $OUT_DIR"
  exit "$code"
}

write_result() {
  local status="$1"
  local method="$2"
  local vcf_name="$3"
  local bin_path="$4"
  local note="$5"
  local pin_sha="${6:-}"
  python3 - "$OUT_DIR/gatk-rs-smoke-result.json" "$status" "$method" "$vcf_name" "$bin_path" "$note" "$pin_sha" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path
dest, status, method, vcf_name, bin_path, note, pin_sha = sys.argv[1:8]
out = {
  "schema_version": 1,
  "stage": "gatk_rs_smoke",
  "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
  "status": status,
  "method": method or None,
  "binary_or_image": bin_path or None,
  "vcf": vcf_name or None,
  "pin_sha": pin_sha or None,
  "wes_integration": "not_wired",
  "honesty": (
    "gatk-rs Alpha smoke only — tiny fixture HC, not GIAB/clinical equivalence. "
    "Default Showcase WES remains Ferrum Nextflow + Broad GATK. "
    "Ferrum-GA4GH-Demo gatk-rs workflow is deferred (Phase B)."
  ),
  "note": note or None,
}
Path(dest).write_text(json.dumps(out, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"ok": status == "ok", "status": status, "wrote": dest}))
PY
}

copy_fixture_vcf() {
  local src="$SHOWCASE_ROOT/fixtures/ci/gatk-rs/smoke.vcf"
  if [[ -f "$src" ]]; then
    cp "$src" "$OUT_DIR/smoke.vcf"
  else
    cat >"$OUT_DIR/smoke.vcf" <<'VCF'
##fileformat=VCFv4.2
##source=gatk-rs HaplotypeCaller assembly-region-v1 (showcase fixture)
##contig=<ID=chr1,length=32>
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	sample
VCF
  fi
}

if [[ "$MODE" == "fixtures" ]]; then
  copy_fixture_vcf
  if [[ -f "$SHOWCASE_ROOT/fixtures/ci/gatk-rs/gatk-rs-smoke-result.json" ]]; then
    cp "$SHOWCASE_ROOT/fixtures/ci/gatk-rs/gatk-rs-smoke-result.json" \
      "$OUT_DIR/gatk-rs-smoke-result.json"
  else
    write_result "ok" "fixtures" "smoke.vcf" "" "CI fixture; no live gatk-rs invocation" ""
  fi
  if [[ "$PUBLISH_EXAMPLES" == "1" ]]; then
    mkdir -p "$SHOWCASE_ROOT/demo/results"
    cp "$OUT_DIR/gatk-rs-smoke-result.json" \
      "$SHOWCASE_ROOT/demo/results/gatk-rs-smoke-result-example.json"
  fi
  finish "ok" "fixtures"
fi

PIN_SHA=""
if [[ -d "$GATK_RS_ROOT/.git" ]] && command -v git >/dev/null 2>&1; then
  PIN_SHA="$(git -C "$GATK_RS_ROOT" rev-parse HEAD 2>/dev/null || true)"
fi

resolve_binary() {
  local cand
  for cand in \
    "${SHOWCASE_GATK_RS_BIN:-}" \
    "$GATK_RS_ROOT/target/release/gatk-rs" \
    "$GATK_RS_ROOT/target/debug/gatk-rs"
  do
    [[ -z "$cand" ]] && continue
    if [[ -x "$cand" ]]; then
      echo "$cand"
      return 0
    fi
  done
  if command -v gatk-rs >/dev/null 2>&1; then
    command -v gatk-rs
    return 0
  fi
  return 1
}

REF="$GATK_RS_ROOT/parity/fixtures/reference.fa"
BAM="$GATK_RS_ROOT/parity/fixtures/sample.bam"
VCF_OUT="$OUT_DIR/smoke.vcf"
LOG_OUT="$OUT_DIR/smoke.log"
rm -f "$VCF_OUT" "$LOG_OUT"

run_hc() {
  local label="$1"
  shift
  echo "[gatk-rs-smoke] running ($label): $*" >&2
  if "$@" >"$LOG_OUT" 2>&1; then
    return 0
  fi
  return 1
}

if [[ ! -d "$GATK_RS_ROOT" ]]; then
  write_result "skipped" "" "" "" "gatk-rs checkout missing: $GATK_RS_ROOT" "$PIN_SHA"
  finish "skipped" "missing checkout"
fi

if [[ ! -f "$REF" || ! -f "$BAM" ]]; then
  write_result "skipped" "" "" "" "parity fixtures missing under $GATK_RS_ROOT/parity/fixtures" "$PIN_SHA"
  finish "skipped" "missing fixtures"
fi

BIN=""
METHOD=""
if BIN="$(resolve_binary)"; then
  METHOD="local_binary"
  if run_hc "local" "$BIN" HaplotypeCaller \
    -R "$REF" -I "$BAM" -O "$VCF_OUT" -L "chr1:1-32" --threads 1
  then
    write_result "ok" "$METHOD" "smoke.vcf" "$BIN" "Live HC on parity/fixtures (chr1:1-32)" "$PIN_SHA"
    finish "ok" "local binary"
  fi
  echo "[gatk-rs-smoke] local binary failed; see $LOG_OUT" >&2
fi

if [[ -n "$DOCKER_IMAGE" ]] && command -v docker >/dev/null 2>&1; then
  METHOD="docker"
  # Mount gatk-rs root so parity fixtures are available at the same relative paths.
  if run_hc "docker" docker run --rm \
    -v "$GATK_RS_ROOT:/work:ro" \
    -v "$OUT_DIR:/out" \
    -w /work \
    "$DOCKER_IMAGE" \
    HaplotypeCaller \
    -R /work/parity/fixtures/reference.fa \
    -I /work/parity/fixtures/sample.bam \
    -O /out/smoke.vcf \
    -L "chr1:1-32" --threads 1
  then
    write_result "ok" "$METHOD" "smoke.vcf" "$DOCKER_IMAGE" "Docker HC on parity fixtures" "$PIN_SHA"
    finish "ok" "docker"
  fi
  echo "[gatk-rs-smoke] docker run failed; see $LOG_OUT" >&2
fi

write_result "failed" "${METHOD:-none}" "" "${BIN:-$DOCKER_IMAGE}" \
  "Could not run gatk-rs HC (build binary or set SHOWCASE_GATK_RS_IMAGE). Soft-fail." \
  "$PIN_SHA"
finish "failed" "no runnable caller"
