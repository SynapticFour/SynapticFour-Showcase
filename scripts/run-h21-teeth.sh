#!/usr/bin/env bash
# H2.1 Teeth: prove Solum revoke → Ferrum DRS/WES HTTP 403 (not orchestrator skip).
#
# Requires:
#   - Solum sidecar reachable (Solum-Demo or pilot)
#   - Ferrum gateway with FERRUM_SOLUM__BASE_URL + token (+ defaults or tags)
#   - Optional Bearer for require_auth stacks (SHOWCASE_FERRUM_BEARER)
#
# Usage:
#   scripts/run-h21-teeth.sh
#   SHOWCASE_SOLUM_SKIP_UP=1 SHOWCASE_FERRUM_BASE_URL=http://127.0.0.1:8080 scripts/run-h21-teeth.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SOLUM_DEMO_ROOT="${SHOWCASE_SOLUM_DEMO_ROOT:-$SHOWCASE_ROOT/../Solum-Demo}"
OUT_DIR="${SHOWCASE_H21_OUT:-$SHOWCASE_ROOT/artifacts/h21-teeth}"
SOLUM_BASE="${SHOWCASE_SOLUM_BASE_URL:-http://127.0.0.1:8787}"
# Solum-Demo often publishes on 8080; allow override. Prefer 8787 then 8080 probe.
FERRUM_BASE="${SHOWCASE_FERRUM_BASE_URL:-http://127.0.0.1:8080}"
TOKEN="${SOLUM_SIDECAR_TOKEN:-solum-demo-local-token-not-for-production}"
TOKEN_HEADER="X-Solum-Sidecar-Token"
SKIP_UP="${SHOWCASE_SOLUM_SKIP_UP:-0}"
SUBJECT="${SHOWCASE_CONSENT_SUBJECT:-patient/showcase-phenoflow-001}"
PURPOSE="${SHOWCASE_CONSENT_PURPOSE:-secondary_use_hdab}"
ACTOR="${SHOWCASE_CONSENT_ACTOR:-practitioner/showcase-teeth}"
BEARER="${SHOWCASE_FERRUM_BEARER:-}"
DRS_OBJECT_ID="${SHOWCASE_H21_DRS_OBJECT_ID:-}"

mkdir -p "$OUT_DIR"

auth_hdr=()
if [[ -n "$BEARER" ]]; then
  auth_hdr=(-H "Authorization: Bearer $BEARER")
fi

probe_solum() {
  local base="$1"
  curl -sfS -o /dev/null -w '%{http_code}' \
    -H "$TOKEN_HEADER: $TOKEN" \
    "$base/v1/consent/status?subject=probe&purpose=probe" 2>/dev/null || echo "000"
}

resolve_solum_base() {
  for candidate in "$SOLUM_BASE" "http://127.0.0.1:8787" "http://127.0.0.1:8080"; do
    code="$(probe_solum "$candidate")"
    if [[ "$code" == "200" || "$code" == "401" ]]; then
      # 401 means sidecar up but wrong token for probe subject path still hit middleware differently;
      # status with token should be 200. Retry with token expect 200 JSON.
      if curl -sfS -H "$TOKEN_HEADER: $TOKEN" \
        "$candidate/v1/consent/status?subject=patient%2Fprobe&purpose=care_provision" \
        >/dev/null 2>&1; then
        SOLUM_BASE="$candidate"
        return 0
      fi
    fi
  done
  return 1
}

if [[ "$SKIP_UP" != "1" ]]; then
  if ! resolve_solum_base; then
    if [[ -x "$SOLUM_DEMO_ROOT/scripts/up.sh" ]] || [[ -f "$SOLUM_DEMO_ROOT/docker-compose.yml" ]]; then
      echo "h21-teeth: starting Solum-Demo…"
      (cd "$SOLUM_DEMO_ROOT" && ./scripts/up.sh 2>/dev/null || docker compose up -d) || true
      sleep 3
    fi
  fi
fi

if ! resolve_solum_base; then
  echo "h21-teeth: Solum sidecar not reachable (set SHOWCASE_SOLUM_BASE_URL / SOLUM_SIDECAR_TOKEN)" >&2
  exit 1
fi
echo "h21-teeth: Solum at $SOLUM_BASE"
echo "h21-teeth: Ferrum at $FERRUM_BASE"

solum_grant() {
  curl -sfS -X POST "$SOLUM_BASE/v1/consent/grant" \
    -H "Content-Type: application/json" \
    -H "$TOKEN_HEADER: $TOKEN" \
    -d "$(python3 - <<PY
import json
print(json.dumps({
  "subject": "$SUBJECT",
  "purpose": "$PURPOSE",
  "actor": "$ACTOR",
  "capability": ["solum:consent:grant"],
  "scope": ["patient_summary"],
}))
PY
)" >/dev/null
}

solum_revoke() {
  curl -sfS -X POST "$SOLUM_BASE/v1/consent/revoke" \
    -H "Content-Type: application/json" \
    -H "$TOKEN_HEADER: $TOKEN" \
    -d "$(python3 - <<PY
import json
print(json.dumps({
  "subject": "$SUBJECT",
  "purpose": "$PURPOSE",
  "actor": "$SUBJECT",
  "capability": ["solum:consent:revoke"],
}))
PY
)" >/dev/null
}

solum_status() {
  curl -sfS -H "$TOKEN_HEADER: $TOKEN" \
    --get "$SOLUM_BASE/v1/consent/status" \
    --data-urlencode "subject=$SUBJECT" \
    --data-urlencode "purpose=$PURPOSE"
}

http_code() {
  local method="$1"; shift
  if [[ ${#auth_hdr[@]} -gt 0 ]]; then
    curl -sS -o /tmp/h21-body.txt -w '%{http_code}' -X "$method" "${auth_hdr[@]}" "$@" || echo "000"
  else
    curl -sS -o /tmp/h21-body.txt -w '%{http_code}' -X "$method" "$@" || echo "000"
  fi
}

# Minimal WES JSON submit (CWL hello) with Solum binding tags.
wes_post_code() {
  http_code POST \
    -H "Content-Type: application/json" \
    -d "$(python3 - <<PY
import json
print(json.dumps({
  "workflow_type": "CWL",
  "workflow_type_version": "v1.0",
  "workflow_url": "https://raw.githubusercontent.com/common-workflow-language/cwl-v1.2/main/tests/echo.cwl",
  "workflow_params": {},
  "workflow_engine_params": {},
  "tags": {
    "solum_subject": "$SUBJECT",
    "solum_purpose": "$PURPOSE",
    "h21": "teeth",
  },
}))
PY
)" \
    "$FERRUM_BASE/ga4gh/wes/v1/runs"
}

drs_get_code() {
  local oid="${1:?object id}"
  http_code GET \
    "$FERRUM_BASE/ga4gh/drs/v1/objects/${oid}"
}

# --- grant path ---
solum_grant
status_grant="$(solum_status)"
echo "$status_grant" | tee "$OUT_DIR/status-after-grant.json"
echo "$status_grant" | grep -q '"granted"' || {
  echo "h21-teeth: expected granted after grant: $status_grant" >&2
  exit 1
}

wes_grant_code="$(wes_post_code)"
echo "h21-teeth: WES POST after grant → HTTP $wes_grant_code"
echo "$wes_grant_code" > "$OUT_DIR/wes-after-grant.code"
if [[ "$wes_grant_code" == "403" ]]; then
  echo "h21-teeth: unexpected 403 after grant (Solum granted?). Body:" >&2
  cat /tmp/h21-body.txt >&2 || true
  exit 1
fi
if [[ "$wes_grant_code" == "000" ]]; then
  echo "h21-teeth: Ferrum unreachable at $FERRUM_BASE" >&2
  exit 1
fi

drs_grant_code=""
if [[ -n "$DRS_OBJECT_ID" ]]; then
  drs_grant_code="$(drs_get_code "$DRS_OBJECT_ID")"
  echo "h21-teeth: DRS GET after grant → HTTP $drs_grant_code"
  echo "$drs_grant_code" > "$OUT_DIR/drs-after-grant.code"
  if [[ "$drs_grant_code" == "403" ]]; then
    echo "h21-teeth: unexpected DRS 403 after grant" >&2
    cat /tmp/h21-body.txt >&2 || true
    exit 1
  fi
fi

# --- revoke path ---
solum_revoke
status_revoke="$(solum_status)"
echo "$status_revoke" | tee "$OUT_DIR/status-after-revoke.json"
echo "$status_revoke" | grep -q '"revoked"' || {
  echo "h21-teeth: expected revoked after revoke: $status_revoke" >&2
  exit 1
}

wes_revoke_code="$(wes_post_code)"
echo "h21-teeth: WES POST after revoke → HTTP $wes_revoke_code"
echo "$wes_revoke_code" > "$OUT_DIR/wes-after-revoke.code"
cp /tmp/h21-body.txt "$OUT_DIR/wes-after-revoke.body" 2>/dev/null || true

if [[ "$wes_revoke_code" != "403" ]]; then
  echo "h21-teeth: FAIL — expected Ferrum WES 403 after Solum revoke, got $wes_revoke_code" >&2
  echo "h21-teeth: Ensure Ferrum was started with FERRUM_SOLUM__BASE_URL=$SOLUM_BASE and matching sidecar token (+ optional defaults)." >&2
  cat "$OUT_DIR/wes-after-revoke.body" 2>/dev/null || true
  exit 1
fi

drs_revoke_code=""
if [[ -n "$DRS_OBJECT_ID" ]]; then
  drs_revoke_code="$(drs_get_code "$DRS_OBJECT_ID")"
  echo "h21-teeth: DRS GET after revoke → HTTP $drs_revoke_code"
  echo "$drs_revoke_code" > "$OUT_DIR/drs-after-revoke.code"
  if [[ "$drs_revoke_code" != "403" ]]; then
    echo "h21-teeth: FAIL — expected DRS 403 after revoke (object must carry solum_* metadata or Ferrum defaults)" >&2
    exit 1
  fi
fi

python3 - "$OUT_DIR/result.json" "$SUBJECT" "$PURPOSE" "$wes_grant_code" "$wes_revoke_code" "${drs_grant_code:-}" "${drs_revoke_code:-}" <<'PY'
import json, sys
from datetime import datetime, timezone
out, subject, purpose, wg, wr, dg, dr = sys.argv[1:8]
doc = {
  "gate": "h21-teeth",
  "recorded_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
  "subject": subject,
  "purpose": purpose,
  "wes_after_grant": int(wg),
  "wes_after_revoke": int(wr),
  "drs_after_grant": int(dg) if dg else None,
  "drs_after_revoke": int(dr) if dr else None,
  "decision": "pass",
  "note": "Ferrum enforced Solum revoke on WES POST (403).",
}
open(out, "w").write(json.dumps(doc, indent=2) + "\n")
print(json.dumps(doc, indent=2))
PY

echo "h21-teeth: PASS — artefacts in $OUT_DIR"
