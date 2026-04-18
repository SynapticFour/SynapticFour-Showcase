#!/usr/bin/env bash
# M2.2: Create a minimal Phenopacket and link the imported DRS VCF asset.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

M2_DIR="${SHOWCASE_M2_DIR:-$SHOWCASE_ROOT/artifacts/m2}"
IMPORT_JSON="${SHOWCASE_M2_IMPORT_RESULT:-$M2_DIR/m2-import-result.json}"
HANDOFF_JSON="${SHOWCASE_M2_HANDOFF:-$M2_DIR/m2-handoff.json}"
BRA_BASE_URL="${SHOWCASE_BRA_BASE_URL:-http://localhost:8000}"
API_PREFIX="${SHOWCASE_BRA_API_PREFIX:-/api/v1}"
DRY_RUN="${SHOWCASE_M2_DRY_RUN:-0}"
PSEUDONYM_OVERRIDE="${SHOWCASE_M2_PSEUDONYM_ID:-}"

usage() {
  cat <<'EOF'
Usage: scripts/run-m2-bioresearch-link.sh [--dry-run]

Requires m2-import-result.json from run-m2-bioresearch-import.sh (status: imported).

Creates:
  POST {BRA}/api/v1/phenopackets
  POST {BRA}/api/v1/phenopackets/{pseudonym_id}/assets

Environment:
  SHOWCASE_M2_DIR              M2 artifact dir (default: ./artifacts/m2)
  SHOWCASE_M2_IMPORT_RESULT    Path to m2-import-result.json
  SHOWCASE_M2_HANDOFF          Path to m2-handoff.json (for WES id → pseudonym)
  SHOWCASE_BRA_BASE_URL        Backend base URL (default: http://localhost:8000)
  SHOWCASE_BRA_API_PREFIX      API prefix (default: /api/v1)
  SHOWCASE_M2_PSEUDONYM_ID     Override pseudonym_id (default: showcase-{wes_run_id})
  SHOWCASE_M2_DRY_RUN          1 = write planned URLs only
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    *)
      echo "run-m2-bioresearch-link: unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

[[ -f "$IMPORT_JSON" ]] || { echo "run-m2-bioresearch-link: missing $IMPORT_JSON" >&2; exit 1; }
[[ -f "$HANDOFF_JSON" ]] || { echo "run-m2-bioresearch-link: missing $HANDOFF_JSON" >&2; exit 1; }

WES_RUN_ID="$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print((d.get("source") or {}).get("wes_run_id","unknown"))' "$HANDOFF_JSON")"
DRS_ID="$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(d.get("drs_object_id") or "")' "$IMPORT_JSON")"
IMPORT_STATUS="$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(d.get("status") or "")' "$IMPORT_JSON")"

[[ -n "$DRS_ID" ]] || { echo "run-m2-bioresearch-link: drs_object_id missing in $IMPORT_JSON" >&2; exit 1; }
if [[ "$IMPORT_STATUS" != "imported" ]]; then
  echo "run-m2-bioresearch-link: expected m2-import-result status=imported; got: $IMPORT_STATUS" >&2
  exit 1
fi

if [[ -z "$PSEUDONYM_OVERRIDE" ]]; then
  PSEUDO="showcase-${WES_RUN_ID}"
else
  PSEUDO="$PSEUDONYM_OVERRIDE"
fi

BASE="${BRA_BASE_URL%/}"
PP_URL="${BASE}${API_PREFIX}/phenopackets"
LINK_URL="${BASE}${API_PREFIX}/phenopackets/${PSEUDO}/assets"
RESULT_JSON="$M2_DIR/m2-link-result.json"
TMP_PP="$M2_DIR/.tmp_pp_resp.json"
TMP_LINK="$M2_DIR/.tmp_link_resp.json"
mkdir -p "$M2_DIR"

if [[ "$DRY_RUN" == "1" ]]; then
  cat > "$RESULT_JSON" <<EOF
{
  "status": "dry_run",
  "pseudonym_id": "$PSEUDO",
  "phenopackets_url": "$PP_URL",
  "link_assets_url": "$LINK_URL",
  "drs_object_id": "$DRS_ID"
}
EOF
  echo "{\"ok\":true,\"wrote\":\"$RESULT_JSON\",\"dry_run\":true}"
  exit 0
fi

export PSEUDO DRS_ID
PP_BODY="$(python3 <<'PY'
import json
import os

print(
    json.dumps(
        {
            "pseudonym_id": os.environ["PSEUDO"],
            "phenotypes": [],
            "diseases": [],
            "genes_of_interest": [],
            "notes": "SynapticFour showcase — Ferrum GA4GH demo VCF handoff",
        }
    )
)
PY
)"

LINK_BODY="$(python3 <<'PY'
import json
import os

print(json.dumps({"drs_object_id": os.environ["DRS_ID"], "file_type": "vcf"}))
PY
)"

HTTP_CODE="$(curl -sS -o "$TMP_PP" -w '%{http_code}' -X POST "$PP_URL" \
  -H 'Content-Type: application/json' \
  -d "$PP_BODY" || true)"

if [[ "$HTTP_CODE" != "201" && "$HTTP_CODE" != "409" ]]; then
  echo "run-m2-bioresearch-link: POST phenopackets failed: HTTP $HTTP_CODE" >&2
  cat "$TMP_PP" >&2 || true
  exit 1
fi

HTTP_LINK="$(curl -sS -o "$TMP_LINK" -w '%{http_code}' -X POST "$LINK_URL" \
  -H 'Content-Type: application/json' \
  -d "$LINK_BODY" || true)"

if [[ "$HTTP_LINK" != "201" && "$HTTP_LINK" != "409" ]]; then
  echo "run-m2-bioresearch-link: POST assets failed: HTTP $HTTP_LINK" >&2
  cat "$TMP_LINK" >&2 || true
  exit 1
fi

python3 <<PY
import json
from pathlib import Path

out = {
    "status": "linked",
    "pseudonym_id": "${PSEUDO}",
    "drs_object_id": "${DRS_ID}",
    "phenopacket_http": "${HTTP_CODE}",
    "asset_http": "${HTTP_LINK}",
}
try:
    out["phenopacket_response"] = json.loads(Path("${TMP_PP}").read_text())
except Exception:
    out["phenopacket_response"] = None
try:
    out["asset_response"] = json.loads(Path("${TMP_LINK}").read_text())
except Exception:
    out["asset_response"] = None
Path("${RESULT_JSON}").write_text(json.dumps(out, indent=2), encoding="utf-8")
print(json.dumps({"ok": True, "wrote": "${RESULT_JSON}", "pseudonym_id": "${PSEUDO}"}))
PY

rm -f "$TMP_PP" "$TMP_LINK" 2>/dev/null || true
