#!/usr/bin/env bash
# H2.2 Org CAP — contract-artefact gate (HTTP proof lives in Solum sidecar tests).
#
# Live end-to-end against a real IdP is site-specific. This script records that
# the groups→CAP_* mapping file is present. It does **not** prove JWT grant/deny.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT_DIR="${SHOWCASE_H22_OUT:-$SHOWCASE_ROOT/artifacts/h22-org-cap}"
mkdir -p "$OUT_DIR"

SOLUM_ROOT="${SHOWCASE_SOLUM_ROOT:-$SHOWCASE_ROOT/../Solum}"
SIBLING="$SOLUM_ROOT/config/org-iam/pilot-groups.toml"
FIXTURE="$SHOWCASE_ROOT/fixtures/ci/org-iam/pilot-groups.toml"

if [[ -f "$SIBLING" ]]; then
  MAPPING="$SIBLING"
  SOURCE="solum-sibling"
elif [[ -f "$FIXTURE" ]]; then
  MAPPING="$FIXTURE"
  SOURCE="showcase-fixture"
else
  echo "h22-org-cap: missing mapping (tried $SIBLING and $FIXTURE)" >&2
  exit 1
fi

python3 - "$OUT_DIR/result.json" "$MAPPING" "$SOURCE" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path
out, mapping, source = sys.argv[1], Path(sys.argv[2]), sys.argv[3]
text = mapping.read_text(encoding="utf-8")
if "claim_path" not in text or "capabilities" not in text:
    raise SystemExit("h22-org-cap: mapping file missing claim_path/capabilities")
doc = {
  "gate": "h22-org-cap",
  "recorded_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
  "mapping_file": str(mapping),
  "mapping_bytes": mapping.stat().st_size,
  "source": source,
  "decision": "contract_artefact_present",
  "note": (
      "Contract artefact present. This is not an HTTP/JWT proof. "
      "Prove grant/deny with: cargo test -p solum-sidecar --test http org_iam_"
  ),
  "adr": "docs/adr/0002-solum-org-iam-cap.md",
}
Path(out).write_text(json.dumps(doc, indent=2) + "\n")
print(json.dumps(doc, indent=2))
PY

echo "h22-org-cap: contract artefact present ($SOURCE) — see $OUT_DIR/result.json"
echo "h22-org-cap: run Solum org_iam_ HTTP tests for JWT grant/deny evidence"
