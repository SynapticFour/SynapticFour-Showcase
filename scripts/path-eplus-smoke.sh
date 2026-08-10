#!/usr/bin/env bash
# Live Path E+ smoke: Solum CDR + FHIR Patient + subject-link (+ optional Ferrum note).
# Soft-fail when sidecar/EHRbase are not running (exit 0 with SKIP).
# Hard-fail (exit 1) when SOLUM_PATH_EPLUS_REQUIRE=1 and checks fail.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${PATH_EPLUS_OUT:-$ROOT/artifacts/path-eplus-smoke}"
mkdir -p "$OUT"

SIDECAR_URL="${SOLUM_SIDECAR_URL:-http://127.0.0.1:8787}"
TOKEN="${SOLUM_SIDECAR_TOKEN:-}"
ACTOR="${SOLUM_PATH_EPLUS_ACTOR:-practitioner/path-eplus}"
REQUIRE="${SOLUM_PATH_EPLUS_REQUIRE:-0}"

skip() {
  echo "SKIP: $*" | tee "$OUT/result.txt"
  if [[ "$REQUIRE" == "1" ]]; then
    exit 1
  fi
  exit 0
}

fail() {
  echo "FAIL: $*" | tee "$OUT/result.txt"
  exit 1
}

if [[ -z "$TOKEN" ]]; then
  skip "SOLUM_SIDECAR_TOKEN unset"
fi

HDR=(-H "X-Solum-Sidecar-Token: $TOKEN" -H "Content-Type: application/json")

if ! curl -sf --max-time 3 "${HDR[@]}" "$SIDECAR_URL/v1/consent/status?subject=smoke&purpose=care_provision" >/dev/null 2>&1 \
  && ! curl -sf --max-time 3 -o /dev/null -w "%{http_code}" "${HDR[@]}" "$SIDECAR_URL/v1/audit/verify" 2>/dev/null | grep -qE '200|400|401|403'; then
  # Probe with a cheap authenticated call; 401 without token already handled.
  code="$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 "${HDR[@]}" "$SIDECAR_URL/v1/audit/verify" || true)"
  if [[ "$code" == "000" || -z "$code" ]]; then
    skip "sidecar not reachable at $SIDECAR_URL"
  fi
fi

# Upload template (idempotent when EHRbase up; may 5xx if Track B off — still try FHIR).
curl -sS --max-time 60 "${HDR[@]}" -X POST "$SIDECAR_URL/v1/cdr/template" \
  -d "{\"actor\":\"$ACTOR\",\"capability\":[\"solum:cdr:write\"]}" \
  >"$OUT/template.json" || true

PATIENT_ID="path-eplus-$(date -u +%Y%m%d%H%M%S)"
CREATE="$(curl -sS --max-time 60 "${HDR[@]}" -X POST "$SIDECAR_URL/v1/fhir/Patient" \
  -d "{\"actor\":\"$ACTOR\",\"capability\":[\"solum:cdr:write\"],\"link_cdr\":true,\"resource\":{\"resourceType\":\"Patient\",\"id\":\"$PATIENT_ID\",\"name\":[{\"family\":\"PathEplus\"}]}}")"
echo "$CREATE" >"$OUT/patient-create.json"
echo "$CREATE" | grep -q "\"id\"" || fail "Patient create did not return id: $CREATE"

LINK="$(curl -sS --max-time 30 "${HDR[@]}" \
  "$SIDECAR_URL/v1/cdr/subject-link/$PATIENT_ID?actor=$ACTOR&capability=solum:cdr:read")"
echo "$LINK" >"$OUT/subject-link.json"
echo "$LINK" | grep -q "$PATIENT_ID" || fail "subject-link missing for $PATIENT_ID: $LINK"

# Optional: stamp ferrum_drs_id if provided
if [[ -n "${FERRUM_DRS_ID:-}" ]]; then
  curl -sS --max-time 30 "${HDR[@]}" -X POST "$SIDECAR_URL/v1/cdr/subject-link" \
    -d "{\"actor\":\"$ACTOR\",\"capability\":[\"solum:cdr:write\"],\"solum_subject_id\":\"$PATIENT_ID\",\"ferrum_drs_id\":\"$FERRUM_DRS_ID\"}" \
    >"$OUT/subject-link-upsert.json"
fi

echo "OK patient=$PATIENT_ID sidecar=$SIDECAR_URL" | tee "$OUT/result.txt"
cp -f "$ROOT/fixtures/ci/solum-cdr/subject-link-fixture.json" "$OUT/fixture-ref-subject-link.json" 2>/dev/null || true
exit 0
