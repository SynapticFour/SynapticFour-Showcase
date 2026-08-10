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

echo "[ci-check] consent-gate fixtures present"
test -f "$ROOT/fixtures/ci/consent-gate/consent-gate-result.json"
test -f "$ROOT/fixtures/ci/consent-gate/consent-gate-deny-result.json"
bash -n scripts/run-consent-gate.sh
mkdir -p "$ROOT/artifacts/consent-gate"
cp "$ROOT/fixtures/ci/consent-gate/consent-gate-result.json" "$ROOT/artifacts/consent-gate/consent-gate-result.json"
"$PY" scripts/assemble_showcase_report.py \
  --showcase-root "$ROOT" \
  --demo-root "$ROOT/fixtures/ci/demo" \
  --helios-report "$ROOT/fixtures/ci/helios/report.json" \
  --output /tmp/showcase-ci-consent.json \
  --markdown-output /tmp/showcase-ci-consent.md
"$PY" -c "import json; r=json.load(open('/tmp/showcase-ci-consent.json')); assert r.get('consent_gate',{}).get('wes_may_proceed') is True, r.get('consent_gate')"

echo "[ci-check] gatk-rs / S4MP fixtures"
test -f "$ROOT/fixtures/ci/gatk-rs/gatk-rs-smoke-result.json"
test -f "$ROOT/fixtures/ci/gatk-rs/smoke.vcf"
test -f "$ROOT/fixtures/ci/s4mp/diff-report.md"
test -f "$ROOT/fixtures/ci/s4mp/s4mp-evidence.json"
bash -n scripts/run-gatk-rs-smoke.sh
bash -n scripts/attach-s4mp-evidence.sh
./scripts/run-gatk-rs-smoke.sh --fixtures
./scripts/attach-s4mp-evidence.sh --fixtures
test -f "$ROOT/artifacts/gatk-rs/gatk-rs-smoke-result.json"
test -f "$ROOT/artifacts/s4mp/s4mp-evidence.json"
"$PY" scripts/assemble_showcase_report.py \
  --showcase-root "$ROOT" \
  --demo-root "$ROOT/fixtures/ci/demo" \
  --helios-report "$ROOT/fixtures/ci/helios/report.json" \
  --output /tmp/showcase-ci-w4.json \
  --markdown-output /tmp/showcase-ci-w4.md
"$PY" -c "
import json
r=json.load(open('/tmp/showcase-ci-w4.json'))
assert r.get('gatk_rs',{}).get('status')=='ok', r.get('gatk_rs')
assert r.get('s4mp',{}).get('maturity')=='heuristic-map-not-certified', r.get('s4mp')
"

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
assert m['summaries']['consent_gate'].get('present') is True
assert m['summaries']['gatk_rs'].get('present') is True
assert m['summaries']['s4mp'].get('present') is True
assert m['summaries']['ga4gh_infra_co_deploy'].get('present') is True
assert m['summaries']['ga4gh_infra_co_deploy'].get('ran', 0) >= 1
assert any(f.get('role')=='gatk_rs_smoke' for f in m['files'])
assert any(f.get('role')=='s4mp_port_diff' for f in m['files'])
assert any(f.get('role')=='ga4gh_infra_co_deploy' for f in m['files'])
print('evidence-pack fixture ok', m['pack_id'], 'files', len(m['files']))
"

echo "[ci-check] ok"
