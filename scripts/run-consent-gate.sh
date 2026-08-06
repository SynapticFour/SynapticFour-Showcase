#!/usr/bin/env bash
# W3: PhenoFlow-purpose → Solum consent gate (before WES).
#
# Technical purpose-binding demo — NOT a legal consent substitute.
# Product repos stay untouched; Showcase orchestrates Solum-Demo (+ optional BRA).
#
# Modes:
#   --allow     Grant consent for purpose, expect status=granted → exit 0 (WES may proceed)
#   --deny      Do not grant (or revoke); expect not granted → exit 0 with blocked=true
#   --fixtures  Write fixture artefacts without Docker (CI)
#
# Golden path: SHOWCASE_ENABLE_CONSENT_GATE=1 runs --allow before Ferrum demo.
# Deny demo:   SHOWCASE_CONSENT_GATE_MODE=deny (skips WES in run-golden-path.sh)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SOLUM_DEMO_ROOT="${SHOWCASE_SOLUM_DEMO_ROOT:-$SHOWCASE_ROOT/../Solum-Demo}"
OUT_DIR="${SHOWCASE_CONSENT_OUT:-$SHOWCASE_ROOT/artifacts/consent-gate}"
BASE_URL="${SHOWCASE_SOLUM_BASE_URL:-http://127.0.0.1:8080}"
TOKEN="${SOLUM_SIDECAR_TOKEN:-solum-demo-local-token-not-for-production}"
TOKEN_HEADER="X-Solum-Sidecar-Token"
WAIT_SECONDS="${SHOWCASE_SOLUM_WAIT_SECONDS:-300}"
SKIP_UP="${SHOWCASE_SOLUM_SKIP_UP:-0}"
SKIP_DOWN="${SHOWCASE_SOLUM_SKIP_DOWN:-1}"
PUBLISH_EXAMPLES="${SHOWCASE_CONSENT_PUBLISH_EXAMPLES:-0}"
BRA_BASE_URL="${SHOWCASE_BRA_BASE_URL:-http://localhost:8000}"
BRA_API_PREFIX="${SHOWCASE_BRA_API_PREFIX:-/api/v1}"
TRY_BRA="${SHOWCASE_CONSENT_TRY_BRA:-0}"

SUBJECT="${SHOWCASE_CONSENT_SUBJECT:-patient/showcase-phenoflow-001}"
PURPOSE="${SHOWCASE_CONSENT_PURPOSE:-secondary_use_hdab}"
ACTOR_GRANT="${SHOWCASE_CONSENT_ACTOR:-practitioner/showcase-gate}"
SCOPE_JSON='["patient_summary"]'
PRODUCT_TAG="stage1-baseline-sidecar-custody-2026-08-01"

MODE="allow"

usage() {
  cat <<'EOF'
Usage: scripts/run-consent-gate.sh [--allow|--deny|--fixtures] [--publish-examples]

Environment:
  SHOWCASE_SOLUM_DEMO_ROOT / SHOWCASE_SOLUM_BASE_URL / SOLUM_SIDECAR_TOKEN
  SHOWCASE_CONSENT_SUBJECT   default patient/showcase-phenoflow-001
  SHOWCASE_CONSENT_PURPOSE   default wes_variant_calling
  SHOWCASE_CONSENT_TRY_BRA=1 Attempt POST /api/v1/phenopackets when BRA is up
  SHOWCASE_SOLUM_SKIP_DOWN   default 1 (leave Solum-Demo up for subsequent stages)

Exit codes:
  0  Gate completed (check JSON: decision allow|deny|blocked)
  1  Infrastructure / unexpected failure
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --allow) MODE="allow"; shift ;;
    --deny) MODE="deny"; shift ;;
    --fixtures) MODE="fixtures"; shift ;;
    --publish-examples) PUBLISH_EXAMPLES=1; shift ;;
    --skip-up) SKIP_UP=1; shift ;;
    --skip-down) SKIP_DOWN=1; shift ;;
    *)
      echo "run-consent-gate: unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

mkdir -p "$OUT_DIR"

write_phenopacket_binding() {
  local dest="$1"
  python3 - "$dest" "$SUBJECT" "$PURPOSE" <<'PY'
import json, sys
from datetime import datetime, timezone
dest, subject, purpose = sys.argv[1], sys.argv[2], sys.argv[3]
# Minimal Phenopacket-shaped binding for Showcase narrative (not a full GA4GH export).
doc = {
    "schema_version": "showcase-phenoflow-binding/1",
    "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
    "honesty": (
        "Technical purpose-binding artefact for Showcase W3 — not a legal consent "
        "record and not a substitute for institutional consent workflows."
    ),
    "subject": subject,
    "purpose": purpose,
    "phenopacket": {
        "id": "showcase-phenoflow-001",
        "subject": {"id": subject},
        "phenotypicFeatures": [
            {"type": {"id": "HP:0001250", "label": "Seizure"}}
        ],
        "metaData": {
            "createdBy": "SynapticFour-Showcase",
            "phenopacketSchemaVersion": "2.0",
            "externalReferences": [
                {"id": "showcase:purpose", "description": purpose}
            ],
        },
    },
    "intended_wes": {
        "engine": "nextflow",
        "gate": "solum_consent_status_must_be_granted",
    },
}
open(dest, "w", encoding="utf-8").write(json.dumps(doc, indent=2) + "\n")
print(json.dumps({"wrote": dest}))
PY
}

if [[ "$MODE" == "fixtures" ]]; then
  write_phenopacket_binding "$OUT_DIR/phenopacket-purpose-binding.json"
  python3 - "$OUT_DIR" "$SUBJECT" "$PURPOSE" "$MODE" <<'PY'
import json, sys
from datetime import datetime, timezone
out, subject, purpose, mode = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
# Fixture: simulate allow/deny without sidecar (CI).
# Default fixture documents both outcomes as examples via mode=allow narrative.
result = {
    "schema_version": 1,
    "stage": "consent_gate",
    "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
    "mode": "fixtures",
    "subject": subject,
    "purpose": purpose,
    "decision": "allow",
    "blocked": False,
    "wes_may_proceed": True,
    "consent_status": "granted",
    "phenopacket_binding": "phenopacket-purpose-binding.json",
    "bra_phenopacket": {"attempted": False, "status": "skipped_fixtures"},
    "solum": {
        "product_tag_consumed_by_demo": "stage1-baseline-sidecar-custody-2026-08-01",
        "grant_http_status": 200,
        "status_http_status": 200,
        "status_body": {"status": "granted"},
    },
    "honesty": (
        "Technical purpose-binding demo only — not legal consent. "
        "Fixture mode does not call Solum or BRA."
    ),
}
open(f"{out}/consent-gate-result.json", "w", encoding="utf-8").write(json.dumps(result, indent=2) + "\n")
deny = dict(result)
deny.update({
    "decision": "deny",
    "blocked": True,
    "wes_may_proceed": False,
    "consent_status": "unknown",
    "solum": {
        "product_tag_consumed_by_demo": "stage1-baseline-sidecar-custody-2026-08-01",
        "grant_http_status": None,
        "status_http_status": 200,
        "status_body": {"status": "unknown"},
    },
})
open(f"{out}/consent-gate-deny-result.json", "w", encoding="utf-8").write(json.dumps(deny, indent=2) + "\n")
print(json.dumps({"ok": True, "wrote": f"{out}/consent-gate-result.json"}))
PY
  if [[ "$PUBLISH_EXAMPLES" == "1" ]]; then
    mkdir -p "$SHOWCASE_ROOT/demo/results"
    cp "$OUT_DIR/phenopacket-purpose-binding.json" "$SHOWCASE_ROOT/demo/results/phenopacket-purpose-binding-example.json"
    cp "$OUT_DIR/consent-gate-result.json" "$SHOWCASE_ROOT/demo/results/consent-gate-allow-example.json"
    cp "$OUT_DIR/consent-gate-deny-result.json" "$SHOWCASE_ROOT/demo/results/consent-gate-deny-example.json"
  fi
  # Also copy allow into fixtures/ci for CI pack
  mkdir -p "$SHOWCASE_ROOT/fixtures/ci/consent-gate"
  cp "$OUT_DIR/consent-gate-result.json" "$SHOWCASE_ROOT/fixtures/ci/consent-gate/consent-gate-result.json"
  cp "$OUT_DIR/consent-gate-deny-result.json" "$SHOWCASE_ROOT/fixtures/ci/consent-gate/consent-gate-deny-result.json"
  cp "$OUT_DIR/phenopacket-purpose-binding.json" "$SHOWCASE_ROOT/fixtures/ci/consent-gate/phenopacket-purpose-binding.json"
  echo "[consent-gate] fixtures written"
  exit 0
fi

if [[ ! -d "$SOLUM_DEMO_ROOT" ]]; then
  echo "run-consent-gate: Solum-Demo missing: $SOLUM_DEMO_ROOT" >&2
  exit 1
fi
SOLUM_DEMO_ROOT="$(cd "$SOLUM_DEMO_ROOT" && pwd)"

wait_ready() {
  local deadline=$((SECONDS + WAIT_SECONDS))
  echo "[consent-gate] waiting for Solum-Demo at $BASE_URL …"
  while (( SECONDS < deadline )); do
    code="$(curl -sS -o /dev/null -w "%{http_code}" \
      -H "$TOKEN_HEADER: $TOKEN" \
      "$BASE_URL/v1/audit/export" 2>/dev/null || echo "000")"
    if [[ "$code" == "200" ]]; then
      echo "[consent-gate] ready"
      return 0
    fi
    sleep 3
  done
  echo "run-consent-gate: timed out waiting for Solum-Demo" >&2
  return 1
}

if [[ "$SKIP_UP" != "1" ]]; then
  echo "[consent-gate] docker compose up --build -d ($SOLUM_DEMO_ROOT)"
  (cd "$SOLUM_DEMO_ROOT" && docker compose up --build -d)
fi
wait_ready

write_phenopacket_binding "$OUT_DIR/phenopacket-purpose-binding.json"

# Optional BRA phenopacket create (soft — gate does not require BRA)
BRA_META='{"attempted": false, "status": "skipped"}'
if [[ "$TRY_BRA" == "1" ]]; then
  if curl -sS -o /dev/null -w "%{http_code}" "$BRA_BASE_URL/health" 2>/dev/null | grep -qE '200|404'; then
    # health may 404; try phenopackets list
    code="$(curl -sS -o /dev/null -w "%{http_code}" "$BRA_BASE_URL$BRA_API_PREFIX/phenopackets" 2>/dev/null || echo 000)"
    if [[ "$code" == "200" || "$code" == "401" || "$code" == "403" ]]; then
      BRA_META="$(python3 - <<PY
import json, urllib.request, urllib.error
url = "$BRA_BASE_URL$BRA_API_PREFIX/phenopackets"
body = {
  "pseudonym_id": "showcase-phenoflow-001",
  "phenopacket_json": json.load(open("$OUT_DIR/phenopacket-purpose-binding.json"))["phenopacket"],
}
data = json.dumps(body).encode()
req = urllib.request.Request(url, data=data, headers={"Content-Type": "application/json"}, method="POST")
try:
    with urllib.request.urlopen(req, timeout=15) as resp:
        print(json.dumps({"attempted": True, "http_status": resp.getcode(), "status": "created", "body": json.loads(resp.read().decode() or "{}")}))
except urllib.error.HTTPError as e:
    print(json.dumps({"attempted": True, "http_status": e.code, "status": "http_error", "body": e.read().decode(errors="replace")[:500]}))
except Exception as e:
    print(json.dumps({"attempted": True, "status": "error", "message": str(e)}))
PY
)"
    else
      BRA_META='{"attempted": true, "status": "bra_unreachable", "list_http_status": '"${code}"'}'
    fi
  else
    BRA_META='{"attempted": true, "status": "bra_unreachable"}'
  fi
fi

export SHOWCASE_CONSENT_OUT_DIR="$OUT_DIR"
export SHOWCASE_CONSENT_MODE="$MODE"
export SHOWCASE_CONSENT_SUBJECT_E="$SUBJECT"
export SHOWCASE_CONSENT_PURPOSE_E="$PURPOSE"
export SHOWCASE_CONSENT_BASE="$BASE_URL"
export SHOWCASE_CONSENT_TOKEN="$TOKEN"
export SHOWCASE_CONSENT_HEADER="$TOKEN_HEADER"
export SHOWCASE_CONSENT_ACTOR_E="$ACTOR_GRANT"
export SHOWCASE_CONSENT_BRA_META="$BRA_META"
export SHOWCASE_CONSENT_PRODUCT_TAG="$PRODUCT_TAG"

python3 <<'PY'
from __future__ import annotations

import json
import os
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

out = Path(os.environ["SHOWCASE_CONSENT_OUT_DIR"])
mode = os.environ["SHOWCASE_CONSENT_MODE"]
subject = os.environ["SHOWCASE_CONSENT_SUBJECT_E"]
purpose = os.environ["SHOWCASE_CONSENT_PURPOSE_E"]
base = os.environ["SHOWCASE_CONSENT_BASE"].rstrip("/")
token = os.environ["SHOWCASE_CONSENT_TOKEN"]
header = os.environ["SHOWCASE_CONSENT_HEADER"]
actor = os.environ["SHOWCASE_CONSENT_ACTOR_E"]
bra_meta = json.loads(os.environ["SHOWCASE_CONSENT_BRA_META"])
product_tag = os.environ["SHOWCASE_CONSENT_PRODUCT_TAG"]


def request(method: str, path: str, payload: dict | None = None) -> tuple[int, dict]:
    data = None
    headers = {header: token}
    if payload is not None:
        data = json.dumps(payload).encode("utf-8")
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(f"{base}{path}", data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            text = resp.read().decode("utf-8")
            code = resp.getcode()
    except urllib.error.HTTPError as exc:
        text = exc.read().decode("utf-8", errors="replace")
        code = exc.code
    try:
        body = json.loads(text) if text.strip() else {}
    except json.JSONDecodeError:
        body = {"_raw": text}
    return code, body


grant_code = None
grant_body = None
if mode == "allow":
    grant_code, grant_body = request(
        "POST",
        "/v1/consent/grant",
        {
            "subject": subject,
            "purpose": purpose,
            "actor": actor,
            "capability": ["solum:consent:grant"],
            "scope": ["patient_summary"],
        },
    )
elif mode == "deny":
    # Ensure unknown/revoked: try revoke if previously granted (best-effort).
    request(
        "POST",
        "/v1/consent/revoke",
        {
            "subject": subject,
            "purpose": purpose,
            "actor": subject,
            "capability": ["solum:consent:revoke"],
        },
    )

q = urllib.parse.urlencode({"subject": subject, "purpose": purpose})
status_code, status_body = request("GET", f"/v1/consent/status?{q}", None)
consent_status = status_body.get("status") if isinstance(status_body, dict) else None

if mode == "allow":
    granted = consent_status == "granted"
    decision = "allow" if granted else "blocked"
    wes_may = granted
    blocked = not granted
else:
    granted = consent_status == "granted"
    decision = "deny"
    wes_may = False
    blocked = True
    # Deny path succeeds as a demo when consent is NOT granted
    if granted:
        # Unexpected: still mark blocked for WES but flag degraded
        decision = "deny_degraded_still_granted"

result = {
    "schema_version": 1,
    "stage": "consent_gate",
    "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
    "mode": mode,
    "subject": subject,
    "purpose": purpose,
    "decision": decision,
    "blocked": blocked,
    "wes_may_proceed": wes_may,
    "consent_status": consent_status,
    "phenopacket_binding": "phenopacket-purpose-binding.json",
    "bra_phenopacket": bra_meta,
    "solum": {
        "product_tag_consumed_by_demo": product_tag,
        "base_url": base,
        "grant_http_status": grant_code,
        "grant_body": grant_body,
        "status_http_status": status_code,
        "status_body": status_body,
    },
    "honesty": (
        "Technical purpose-binding demo only — not legal consent. "
        "Solum fail-closed status gates Showcase WES when SHOWCASE_ENABLE_CONSENT_GATE=1."
    ),
}
(out / "consent-gate-result.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"ok": True, "decision": decision, "wes_may_proceed": wes_may, "consent_status": consent_status}))

if mode == "allow" and not wes_may:
    raise SystemExit(1)
if mode == "deny" and granted and decision == "deny_degraded_still_granted":
    # Still exit 0 so negative demo artefacts exist; golden path checks wes_may_proceed
    pass
PY

if [[ "$PUBLISH_EXAMPLES" == "1" ]]; then
  mkdir -p "$SHOWCASE_ROOT/demo/results"
  cp "$OUT_DIR/phenopacket-purpose-binding.json" "$SHOWCASE_ROOT/demo/results/phenopacket-purpose-binding-example.json"
  if [[ "$MODE" == "allow" ]]; then
    cp "$OUT_DIR/consent-gate-result.json" "$SHOWCASE_ROOT/demo/results/consent-gate-allow-example.json"
  else
    cp "$OUT_DIR/consent-gate-result.json" "$SHOWCASE_ROOT/demo/results/consent-gate-deny-example.json"
  fi
fi

if [[ "$SKIP_DOWN" != "1" ]]; then
  (cd "$SOLUM_DEMO_ROOT" && docker compose down)
fi

echo "[consent-gate] done mode=$MODE → $OUT_DIR/consent-gate-result.json"
