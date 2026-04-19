#!/usr/bin/env bash
# M2.1: Import prepared VCF handoff into bioresearch-assistant DRS.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=lib/bra-compose.sh
source "$SCRIPT_DIR/lib/bra-compose.sh"

M2_DIR="${SHOWCASE_M2_DIR:-$SHOWCASE_ROOT/artifacts/m2}"
HANDOFF_JSON="${SHOWCASE_M2_HANDOFF:-$M2_DIR/m2-handoff.json}"
BRA_BASE_URL="${SHOWCASE_BRA_BASE_URL:-http://localhost:8000}"
DRY_RUN="${SHOWCASE_M2_DRY_RUN:-0}"
BRA_ROOT="${SHOWCASE_BRA_ROOT:-$SHOWCASE_ROOT/../bioresearch-assistant}"
if [[ -d "$BRA_ROOT" ]]; then
  BRA_ROOT="$(cd "$BRA_ROOT" && pwd)"
fi
AUTO_START_BRA="${SHOWCASE_M2_AUTO_START_BRA:-1}"
AUTO_BOOTSTRAP_BRA_ENV="${SHOWCASE_M2_AUTO_BOOTSTRAP_BRA_ENV:-1}"

usage() {
  cat <<'EOF'
Usage: scripts/run-m2-bioresearch-import.sh [--dry-run]

Imports the handoff VCF into bioresearch-assistant DRS:
  POST {BRA_BASE_URL}/ga4gh/drs/v1/objects  (multipart name + file)

Environment:
  SHOWCASE_M2_DIR         M2 artifact directory (default: ./artifacts/m2)
  SHOWCASE_M2_HANDOFF     Path to m2-handoff.json (default: artifacts/m2/m2-handoff.json)
  SHOWCASE_BRA_BASE_URL   bioresearch-assistant base URL (default: http://localhost:8000)
  SHOWCASE_M2_DRY_RUN     1 = only validate inputs and print planned request
  SHOWCASE_BRA_ROOT       Path to bioresearch-assistant (default: ../bioresearch-assistant)
  SHOWCASE_M2_AUTO_START_BRA  1 = auto-start BRA compose if API is not reachable
  SHOWCASE_M2_AUTO_BOOTSTRAP_BRA_ENV  1 = if BRA .env is missing, copy from .env.example
  SHOWCASE_M2_BRA_READY_WAIT_ATTEMPTS  curl retries after compose up (default: 90, ~2s each)
EOF
}

# .env.example placeholders fail Pydantic (64 hex encryption key, JWT >=32 chars when set).
# Patch only when invalid; exit 0 if file was changed (caller may force-recreate backend).
bra_fix_invalid_env_secrets() {
  local root="$1"
  local env_file="$root/.env"
  [[ -f "$env_file" ]] || return 1
  python3 - "$env_file" <<'PY'
import re
import secrets
import sys
from pathlib import Path


path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
enc_val = jwt_val = None
for line in text.splitlines():
    if line.startswith("PSEUDONYMIZATION_ENCRYPTION_KEY="):
        enc_val = line.split("=", 1)[1].strip()
    if line.startswith("JWT_SECRET="):
        jwt_val = line.split("=", 1)[1].strip()

def valid_enc(v: str | None) -> bool:
    if not v:
        return False
    return len(v) == 64 and all(c in "0123456789abcdefABCDEF" for c in v)

def valid_jwt(v: str | None) -> bool:
    if v is None:
        return True
    if v == "":
        return True
    return len(v) >= 32

changed = False
if not valid_enc(enc_val):
    enc = secrets.token_hex(32)
    text, n = re.subn(
        r"^PSEUDONYMIZATION_ENCRYPTION_KEY=.*$",
        f"PSEUDONYMIZATION_ENCRYPTION_KEY={enc}",
        text,
        flags=re.M,
    )
    if n:
        changed = True
if not valid_jwt(jwt_val):
    jwt = secrets.token_hex(32)
    text, n = re.subn(r"^JWT_SECRET=.*$", f"JWT_SECRET={jwt}", text, flags=re.M)
    if n:
        changed = True

if changed:
    path.write_text(text, encoding="utf-8")
    print(
        "[m2.1] updated invalid PSEUDONYMIZATION_ENCRYPTION_KEY / JWT_SECRET in .env "
        "(was placeholder or too short — API cannot start otherwise)",
        file=sys.stderr,
    )
    sys.exit(0)
sys.exit(1)
PY
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
      echo "run-m2-bioresearch-import: unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

[[ -f "$HANDOFF_JSON" ]] || { echo "run-m2-bioresearch-import: missing $HANDOFF_JSON" >&2; exit 1; }

bootstrap_bra_env_if_missing() {
  local root="$1"
  local env_file="$root/.env"
  local env_example="$root/.env.example"
  if [[ -f "$env_file" ]]; then
    return 0
  fi
  if [[ "$AUTO_BOOTSTRAP_BRA_ENV" == "1" && -f "$env_example" ]]; then
    echo "[m2.1] missing $env_file, bootstrapping from .env.example"
    cp "$env_example" "$env_file"
    return 0
  fi
  if [[ -f "$env_example" ]]; then
    echo "run-m2-bioresearch-import: missing $env_file" >&2
    echo "Create it from template and retry:" >&2
    echo "  cp \"$env_example\" \"$env_file\"" >&2
  else
    echo "run-m2-bioresearch-import: missing $env_file (and no .env.example found)" >&2
  fi
  return 1
}

QUERY_VCF="$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print((d.get("artifacts") or {}).get("query_vcf",""))' "$HANDOFF_JSON")"
WES_RUN_ID="$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print((d.get("source") or {}).get("wes_run_id","unknown"))' "$HANDOFF_JSON")"
[[ -f "$QUERY_VCF" ]] || { echo "run-m2-bioresearch-import: query_vcf missing: $QUERY_VCF" >&2; exit 1; }

RESULT_JSON="$M2_DIR/m2-import-result.json"
mkdir -p "$M2_DIR"

SERVICE_INFO_URL="${BRA_BASE_URL%/}/ga4gh/drs/v1/service-info"
UPLOAD_URL="${BRA_BASE_URL%/}/ga4gh/drs/v1/objects"
OBJECT_NAME="showcase-${WES_RUN_ID}-query.vcf.gz"

if [[ "$DRY_RUN" == "1" ]]; then
  cat > "$RESULT_JSON" <<EOF
{
  "status": "dry_run",
  "service_info_url": "$SERVICE_INFO_URL",
  "upload_url": "$UPLOAD_URL",
  "object_name": "$OBJECT_NAME",
  "query_vcf": "$QUERY_VCF"
}
EOF
  echo "{\"ok\":true,\"wrote\":\"$RESULT_JSON\",\"dry_run\":true}"
  exit 0
fi

if ! curl -fsS "$SERVICE_INFO_URL" >/dev/null 2>&1; then
  if [[ "$AUTO_START_BRA" == "1" && -f "$BRA_ROOT/docker-compose.yml" ]]; then
    bootstrap_bra_env_if_missing "$BRA_ROOT" || exit 1
    bra_env_patched=0
    if bra_fix_invalid_env_secrets "$BRA_ROOT"; then
      bra_env_patched=1
    fi
    echo "[m2.1] bioresearch-assistant not reachable at $BRA_BASE_URL, starting compose stack..."
    bra_docker_compose "$BRA_ROOT" "$SHOWCASE_ROOT" up -d
    if [[ "$bra_env_patched" == "1" ]]; then
      echo "[m2.1] recreating backend so new secrets from .env take effect..."
      bra_docker_compose "$BRA_ROOT" "$SHOWCASE_ROOT" up -d --force-recreate --no-deps backend
    fi
    # Cold start can exceed 80s (migrations, large Python import graph, uvicorn bind).
    max_wait="${SHOWCASE_M2_BRA_READY_WAIT_ATTEMPTS:-90}"
    i=0
    while [[ "$i" -lt "$max_wait" ]]; do
      if curl -fsS "$SERVICE_INFO_URL" >/dev/null 2>&1; then
        break
      fi
      i=$((i + 1))
      if [[ "$((i % 15))" -eq 0 ]]; then
        echo "[m2.1] still waiting for DRS service-info (${i}/${max_wait} attempts, ~2s each)..." >&2
      fi
      sleep 2
    done
  fi
fi

if ! curl -fsS "$SERVICE_INFO_URL" >/dev/null 2>&1; then
  echo "run-m2-bioresearch-import: cannot reach $SERVICE_INFO_URL" >&2
  echo "Check backend logs (from bioresearch-assistant repo; Showcase often uses a second compose file for Postgres):" >&2
  echo "  cd \"$BRA_ROOT\" && docker compose -f docker-compose.yml -f \"$SHOWCASE_ROOT/contrib/bioresearch-assistant-postgres-override.yml\" logs backend --tail=120" >&2
  echo "If you do not use the Postgres override, omit the second -f. Fix .env secrets if API exits on startup (64 hex PSEUDONYMIZATION_ENCRYPTION_KEY, JWT_SECRET empty or >=32 chars)." >&2
  echo "Then: cd \"$BRA_ROOT\" && docker compose up -d" >&2
  echo "Or set SHOWCASE_BRA_BASE_URL if the API runs elsewhere." >&2
  exit 1
fi

UPLOAD_RESP="$(
  curl -fsS -X POST "$UPLOAD_URL" \
    -F "name=$OBJECT_NAME" \
    -F "file=@$QUERY_VCF"
)"

OBJECT_ID="$(python3 -c 'import json,sys; print(json.load(sys.stdin).get("id",""))' <<<"$UPLOAD_RESP")"
ACCESS_URL="${BRA_BASE_URL%/}/ga4gh/drs/v1/objects/${OBJECT_ID}/access/${OBJECT_ID}"

cat > "$RESULT_JSON" <<EOF
{
  "status": "imported",
  "bra_base_url": "$BRA_BASE_URL",
  "upload_url": "$UPLOAD_URL",
  "query_vcf": "$QUERY_VCF",
  "object_name": "$OBJECT_NAME",
  "drs_object_id": "$OBJECT_ID",
  "drs_access_url_endpoint": "$ACCESS_URL",
  "upload_response": $UPLOAD_RESP
}
EOF

echo "{\"ok\":true,\"wrote\":\"$RESULT_JSON\",\"drs_object_id\":\"$OBJECT_ID\"}"
