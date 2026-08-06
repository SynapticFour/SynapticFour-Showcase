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

echo "[ci-check] python3 compile"
if command -v python3.12 >/dev/null 2>&1; then
  PY=python3.12
elif command -v python3.11 >/dev/null 2>&1; then
  PY=python3.11
else
  PY=python3
fi
"$PY" -m py_compile scripts/assemble_showcase_report.py
"$PY" -m py_compile scripts/evidence_pack.py
bash -n scripts/run-solum-stage.sh
bash -n scripts/evidence-pack.sh

echo "[ci-check] assemble_showcase_report.py (fixtures/ci + solum)"
mkdir -p "$ROOT/artifacts/solum"
cp "$ROOT/fixtures/ci/solum/solum-stage-result.json" "$ROOT/artifacts/solum/solum-stage-result.json"
"$PY" scripts/assemble_showcase_report.py \
  --showcase-root "$ROOT" \
  --demo-root "$ROOT/fixtures/ci/demo" \
  --helios-report "$ROOT/fixtures/ci/helios/report.json" \
  --output /tmp/showcase-ci-report.json \
  --markdown-output /tmp/showcase-ci-report.md
test -s /tmp/showcase-ci-report.json
test -s /tmp/showcase-ci-report.md
"$PY" -c "import json; r=json.load(open('/tmp/showcase-ci-report.json')); assert r.get('solum',{}).get('status')=='ok', r.get('solum')"

echo "[ci-check] evidence-pack.sh --fixtures"
rm -rf "$ROOT/artifacts/evidence-pack-fixtures" "$ROOT/artifacts/evidence-pack-latest"
./scripts/evidence-pack.sh --fixtures
test -f "$ROOT/artifacts/evidence-pack-fixtures/MANIFEST.json"
test -f "$ROOT/artifacts/evidence-pack-fixtures/README.md"
test -f "$ROOT/artifacts/evidence-pack-fixtures/helios-report.json"
"$PY" -c "
import json
m=json.load(open('artifacts/evidence-pack-fixtures/MANIFEST.json'))
assert m.get('pack_kind')=='synapticfour-showcase-evidence-pack'
assert m['summaries']['helios'].get('checks_total',0) >= 1
assert any(f.get('role')=='helios_report' for f in m['files'])
assert m['summaries']['helixtest'].get('present') is True
assert m['summaries']['solum'].get('present') is True
print('evidence-pack fixture ok', m['pack_id'], 'files', len(m['files']))
"

echo "[ci-check] ok"
