#!/usr/bin/env bash
# H2.2 Org CAP — document/fixture gate (HTTP proof lives in Solum sidecar tests).
#
# Live end-to-end against a real IdP is site-specific. This script records the
# contract pins and points operators at `cargo test -p solum-sidecar --test http org_iam_`.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT_DIR="${SHOWCASE_H22_OUT:-$SHOWCASE_ROOT/artifacts/h22-org-cap}"
mkdir -p "$OUT_DIR"

SOLUM_ROOT="${SHOWCASE_SOLUM_ROOT:-$SHOWCASE_ROOT/../Solum}"
MAPPING="$SOLUM_ROOT/config/org-iam/pilot-groups.toml"

if [[ ! -f "$MAPPING" ]]; then
  echo "h22-org-cap: missing mapping $MAPPING" >&2
  exit 1
fi

python3 - "$OUT_DIR/result.json" "$MAPPING" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path
out, mapping = sys.argv[1], Path(sys.argv[2])
doc = {
  "gate": "h22-org-cap",
  "recorded_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
  "mapping_file": str(mapping),
  "mapping_bytes": mapping.stat().st_size,
  "decision": "pass",
  "note": "Contract artefact present. Prove with: cargo test -p solum-sidecar --test http org_iam_",
  "adr": "docs/adr/0002-solum-org-iam-cap.md",
}
Path(out).write_text(json.dumps(doc, indent=2) + "\n")
print(json.dumps(doc, indent=2))
PY

echo "h22-org-cap: PASS — see $OUT_DIR/result.json"
echo "h22-org-cap: run Solum org_iam_ HTTP tests for JWT grant/deny evidence"
