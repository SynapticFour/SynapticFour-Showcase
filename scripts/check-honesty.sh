#!/usr/bin/env bash
# In-repo honesty gates: fixture planes stay separate; customer docs match artefacts.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

PY=python3
command -v python3.12 >/dev/null 2>&1 && PY=python3.12

echo "[honesty] genomic HELIOS fixture must not include CLIN-ACCESS-001"
"$PY" - <<'PY'
import json, sys
from pathlib import Path
root = Path(".")
sys.path.insert(0, "scripts")
from lib.helios_honesty import genomic_report_is_honest, helios_honesty, honesty_sidecar_document

data = json.loads((root / "fixtures/ci/helios/report.json").read_text())
ok, msg = genomic_report_is_honest(data)
if not ok:
    raise SystemExit(msg)
print("  fixture genomic report ok")

example_path = root / "demo/results/helios-report-example.json"
example = json.loads(example_path.read_text())
h = helios_honesty(example)
if not h["input_files_recorded"]:
    raise SystemExit("example report should record Nextflow config/log in input_files")
if h.get("vacuous_checks"):
    raise SystemExit(f"example report should not be a vacuous container pass: {h}")
readme = (root / "demo/results/README.md").read_text()
if "4.4.0.0" not in readme or "digest" not in readme.lower():
    raise SystemExit("demo/results/README.md must describe the GATK version-tag / digest warning")
sidecar_path = root / "demo/results/helios-report-example.honesty.json"
if not sidecar_path.is_file():
    raise SystemExit("missing demo/results/helios-report-example.honesty.json")
side = json.loads(sidecar_path.read_text())
expected = honesty_sidecar_document("demo/results/helios-report-example.json", example)
if side != expected:
    raise SystemExit("honesty sidecar is stale; regenerate from helios_honesty.honesty_sidecar_document")
print("  example HELIOS honesty sidecar ok")
PY

echo "[honesty] customer docs must not call fixture CI a live stack"
if grep -n 'customer-equivalent' .github/workflows/ci.yml; then
  echo "ci.yml still says customer-equivalent" >&2
  exit 1
fi

echo "[honesty] DEMO.md must not claim input+output hashes for the committed example"
if grep -n 'aller Input- und Output-Dateien' DEMO.md; then
  echo "DEMO.md still claims hashes of all input and output files" >&2
  exit 1
fi

echo "[honesty] H2 public docs must not say Full H2 exit signed"
if grep -RIn --include='*.md' 'Full H2 exit signed' docs README.md SECURITY.md; then
  echo "H2 still described as Full H2 exit signed" >&2
  exit 1
fi

echo "[honesty] scripts must not silently default the Solum demo token"
if grep -n 'SOLUM_SIDECAR_TOKEN:-solum-demo-local-token' scripts/run-*.sh; then
  echo "a live script still defaults SOLUM_SIDECAR_TOKEN" >&2
  exit 1
fi

echo "[honesty] H2.3 second-pass path exists"
test -f docs/internal/pilots/H2-SECOND-PASS.md
test -f docs/pilots/H2-OPS-RUNBOOK.md

echo "[honesty] NOTICE + LICENSE present"
test -f LICENSE
test -f NOTICE

echo "[honesty] ok"
