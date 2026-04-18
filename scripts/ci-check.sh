#!/usr/bin/env bash
# Local CI parity with .github/workflows/ci.yml (no Docker / no demo).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

echo "[ci-check] bash -n scripts/*.sh scripts/lib/*.sh"
for f in scripts/*.sh scripts/lib/*.sh; do
  [[ -f "$f" ]] || continue
  bash -n "$f"
done

echo "[ci-check] python3 assemble_showcase_report.py"
if command -v python3.12 >/dev/null 2>&1; then
  PY=python3.12
elif command -v python3.11 >/dev/null 2>&1; then
  PY=python3.11
else
  PY=python3
fi
"$PY" -m py_compile scripts/assemble_showcase_report.py

echo "[ci-check] assemble_showcase_report.py (fixtures/ci)"
"$PY" scripts/assemble_showcase_report.py \
  --showcase-root "$ROOT" \
  --demo-root "$ROOT/fixtures/ci/demo" \
  --helios-report "$ROOT/fixtures/ci/helios/report.json" \
  --output /tmp/showcase-ci-report.json \
  --markdown-output /tmp/showcase-ci-report.md
test -s /tmp/showcase-ci-report.json
test -s /tmp/showcase-ci-report.md

echo "[ci-check] ok"
