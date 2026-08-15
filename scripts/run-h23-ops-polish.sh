#!/usr/bin/env bash
# H2.3 Ops polish — documentation gate (collector path + thin metrics documented).
# This is not a live collector/IdP proof.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT_DIR="${SHOWCASE_H23_OUT:-$SHOWCASE_ROOT/artifacts/h23-ops-polish}"
mkdir -p "$OUT_DIR"

OPS="$SHOWCASE_ROOT/docs/pilots/H2-OPS-RUNBOOK.md"
SECOND="$SHOWCASE_ROOT/docs/internal/pilots/H2-SECOND-PASS.md"
KENYA_SEND="${SHOWCASE_SOLUM_ROOT:-$SHOWCASE_ROOT/../Solum}/docs/counsel/KENYA-K1-SEND-CHECKLIST.md"

missing=()
[[ -f "$OPS" ]] || missing+=("$OPS")
[[ -f "$SECOND" ]] || missing+=("$SECOND")

if ((${#missing[@]})); then
  printf 'h23-ops-polish: missing required Showcase docs:\n' >&2
  printf '  %s\n' "${missing[@]}" >&2
  exit 1
fi

kenya_status="missing_optional"
if [[ -f "$KENYA_SEND" ]]; then
  kenya_status="present"
fi

for needle in "Collector visa demo path" "Thin metrics" "H2-SECOND-PASS"; do
  if ! grep -q "$needle" "$OPS"; then
    echo "h23-ops-polish: ops runbook missing section marker: $needle" >&2
    exit 1
  fi
done

for needle in "Solum KMS" "Observability baseline" "HELIOS clinical" "CLI org-IAM"; do
  if ! grep -q "$needle" "$SECOND"; then
    echo "h23-ops-polish: second-pass doc missing: $needle" >&2
    exit 1
  fi
done

python3 - "$OUT_DIR/result.json" "$OPS" "$SECOND" "$KENYA_SEND" "$kenya_status" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path
out, ops, second, kenya, kenya_status = sys.argv[1], Path(sys.argv[2]), Path(sys.argv[3]), sys.argv[4], sys.argv[5]
doc = {
  "gate": "h23-ops-polish",
  "recorded_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
  "ops_runbook": str(ops),
  "second_pass": str(second),
  "kenya_send_checklist": kenya if kenya_status == "present" else None,
  "kenya_send_status": kenya_status,
  "decision": "docs_present",
  "note": (
      "Documentation gate only. Live collector demo is site-specific "
      "(ferrum auth account or IdP visa). Kenya counsel checklist lives in Solum "
      "and is optional here."
  ),
}
Path(out).write_text(json.dumps(doc, indent=2) + "\n")
print(json.dumps(doc, indent=2))
PY

echo "h23-ops-polish: docs present — see $OUT_DIR/result.json (kenya_send=$kenya_status)"
