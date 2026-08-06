#!/usr/bin/env bash
# W4: Attach S4MP port-diff evidence as a sidecar (NOT a WES executor).
#
# Never runs live `make diff` / Java GATK clone in Showcase CI — too heavy and unstable.
# Prefers committed fixtures; optionally copies an existing .s4/reports/diff-report.md.
#
# Modes:
#   (default)   Copy live report if present, else fixture, else soft-skip
#   --fixtures  Always use committed fixture artefacts
#
# Golden path: SHOWCASE_ENABLE_S4MP=1
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

S4MP_ROOT="${SHOWCASE_S4MP_ROOT:-$SHOWCASE_ROOT/../S4MP}"
OUT_DIR="${SHOWCASE_S4MP_OUT:-$SHOWCASE_ROOT/artifacts/s4mp}"
STRICT="${SHOWCASE_S4MP_STRICT:-0}"
PUBLISH_EXAMPLES="${SHOWCASE_S4MP_PUBLISH_EXAMPLES:-0}"
MODE="live"

usage() {
  cat <<'EOF'
Usage: scripts/attach-s4mp-evidence.sh [--fixtures] [--publish-examples]

Environment:
  SHOWCASE_S4MP_ROOT     Sibling S4MP checkout (default ../S4MP)
  SHOWCASE_S4MP_STRICT=1 Exit non-zero on skip (default: soft-fail, exit 0)
  SHOWCASE_S4MP_OUT      Artefact directory (default artifacts/s4mp)

Honesty: S4MP artefacts are heuristic Java↔Rust port maps / Markdown diffs.
`s4 certify` is a stub — this is not a certificate or compliance claim.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --fixtures) MODE="fixtures"; shift ;;
    --publish-examples) PUBLISH_EXAMPLES=1; shift ;;
    *)
      echo "attach-s4mp-evidence: unknown argument: $1" >&2
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
  echo "[s4mp-evidence] status=$status${detail:+ ($detail)} → $OUT_DIR"
  exit "$code"
}

write_pointer() {
  local status="$1"
  local report_name="$2"
  local source="$3"
  local sha="$4"
  local pin_sha="$5"
  local note="$6"
  python3 - "$OUT_DIR/s4mp-evidence.json" "$status" "$report_name" "$source" "$sha" "$pin_sha" "$note" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path
dest, status, report_name, source, sha, pin_sha, note = sys.argv[1:8]
out = {
  "schema_version": 1,
  "stage": "s4mp_port_evidence",
  "kind": "s4mp-port-diff",
  "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
  "status": status,
  "report": report_name or None,
  "source": source or None,
  "sha256": sha or None,
  "pin_sha": pin_sha or None,
  "maturity": "heuristic-map-not-certified",
  "wes_role": "none",
  "honesty": (
    "S4MP sidecar evidence only — Markdown port-diff / heuristic map. "
    "Not a WES executor. Not a certification. `s4 certify` remains a stub."
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
  elif command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$f" | awk '{print $1}'
  else
    python3 -c "import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())" "$f"
  fi
}

PIN_SHA=""
if [[ -d "$S4MP_ROOT/.git" ]] && command -v git >/dev/null 2>&1; then
  PIN_SHA="$(git -C "$S4MP_ROOT" rev-parse HEAD 2>/dev/null || true)"
fi

FIXTURE_REPORT="$SHOWCASE_ROOT/fixtures/ci/s4mp/diff-report.md"
LIVE_REPORT="$S4MP_ROOT/.s4/reports/diff-report.md"
DEST_REPORT="$OUT_DIR/diff-report.md"

pick_and_copy() {
  local src="$1"
  local source_label="$2"
  cp "$src" "$DEST_REPORT"
  local digest
  digest="$(sha256_file "$DEST_REPORT")"
  printf '%s\n' "$digest" >"$OUT_DIR/diff-report.md.sha256"
  write_pointer "ok" "diff-report.md" "$source_label" "$digest" "$PIN_SHA" \
    "Attached existing Markdown port-diff; did not run live s4 pipeline."
}

if [[ "$MODE" == "fixtures" ]]; then
  if [[ ! -f "$FIXTURE_REPORT" ]]; then
    write_pointer "failed" "" "" "" "$PIN_SHA" "Missing fixtures/ci/s4mp/diff-report.md"
    finish "failed" "missing fixture"
  fi
  pick_and_copy "$FIXTURE_REPORT" "fixtures/ci/s4mp/diff-report.md"
  if [[ -f "$SHOWCASE_ROOT/fixtures/ci/s4mp/s4mp-evidence.json" ]]; then
    # Prefer committed pointer when present (stable timestamps for CI), keep report+sha.
    python3 - "$SHOWCASE_ROOT/fixtures/ci/s4mp/s4mp-evidence.json" "$OUT_DIR" <<'PY'
import json, sys
from pathlib import Path
src, out_dir = Path(sys.argv[1]), Path(sys.argv[2])
data = json.loads(src.read_text(encoding="utf-8"))
digest_path = out_dir / "diff-report.md.sha256"
if digest_path.is_file():
    data["sha256"] = digest_path.read_text(encoding="utf-8").strip()
data["report"] = "diff-report.md"
data["source"] = "fixtures/ci/s4mp/diff-report.md"
(out_dir / "s4mp-evidence.json").write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
  fi
  if [[ "$PUBLISH_EXAMPLES" == "1" ]]; then
    mkdir -p "$SHOWCASE_ROOT/demo/results"
    cp "$OUT_DIR/s4mp-evidence.json" "$SHOWCASE_ROOT/demo/results/s4mp-evidence-example.json"
  fi
  finish "ok" "fixtures"
fi

if [[ -f "$LIVE_REPORT" ]]; then
  pick_and_copy "$LIVE_REPORT" "$LIVE_REPORT"
  finish "ok" "live .s4 report"
fi

if [[ -f "$FIXTURE_REPORT" ]]; then
  pick_and_copy "$FIXTURE_REPORT" "fixtures/ci/s4mp/diff-report.md (fallback; no live .s4 report)"
  finish "ok" "fixture fallback"
fi

write_pointer "skipped" "" "" "" "$PIN_SHA" \
  "No S4MP diff-report.md (live or fixture). Soft-skip — not an executor failure."
finish "skipped" "no report"
