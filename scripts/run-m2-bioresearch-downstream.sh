#!/usr/bin/env bash
# M2 orchestration: handoff → DRS import → Phenopacket + asset link.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/run-m2-bioresearch.sh"
"$SCRIPT_DIR/run-m2-bioresearch-import.sh"
"$SCRIPT_DIR/run-m2-bioresearch-link.sh"

echo '{"ok":true,"step":"m2_downstream_complete"}'
