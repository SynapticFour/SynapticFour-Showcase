#!/usr/bin/env bash
# W1: Run Solum Stage-1 proofs via sibling Solum-Demo (product repos untouched).
#
# Artefacts under artifacts/solum/ (consumed by assemble_showcase_report.py):
#   solum-stage-result.json   — summary
#   solum-authz-allow.json    — encrypt allow (200)
#   solum-authz-deny.json     — fail-closed deny (403)
#   solum-audit-verify.json   — harness tamper + GET /v1/audit/verify
#
# Opt-in from golden path: SHOWCASE_ENABLE_SOLUM=1
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SOLUM_DEMO_ROOT="${SHOWCASE_SOLUM_DEMO_ROOT:-$SHOWCASE_ROOT/../Solum-Demo}"
OUT_DIR="${SHOWCASE_SOLUM_OUT:-$SHOWCASE_ROOT/artifacts/solum}"
BASE_URL="${SHOWCASE_SOLUM_BASE_URL:-http://127.0.0.1:8080}"
TOKEN="${SOLUM_SIDECAR_TOKEN:-solum-demo-local-token-not-for-production}"
TOKEN_HEADER="X-Solum-Sidecar-Token"
WAIT_SECONDS="${SHOWCASE_SOLUM_WAIT_SECONDS:-300}"
SKIP_UP="${SHOWCASE_SOLUM_SKIP_UP:-0}"
SKIP_DOWN="${SHOWCASE_SOLUM_SKIP_DOWN:-0}"
PUBLISH_EXAMPLES="${SHOWCASE_SOLUM_PUBLISH_EXAMPLES:-0}"
PRODUCT_TAG="stage1-baseline-sidecar-custody-2026-08-01"

usage() {
  cat <<'EOF'
Usage: scripts/run-solum-stage.sh [--skip-up] [--skip-down] [--publish-examples]

Environment:
  SHOWCASE_SOLUM_DEMO_ROOT   Path to Solum-Demo (default: ../Solum-Demo)
  SHOWCASE_SOLUM_OUT         Artefact directory (default: ./artifacts/solum)
  SHOWCASE_SOLUM_BASE_URL    Dashboard URL (default: http://127.0.0.1:8080)
  SOLUM_SIDECAR_TOKEN        Shared demo token (must match Solum-Demo compose)
  SHOWCASE_SOLUM_WAIT_SECONDS  Max wait for /v1 readiness (default: 300)
  SHOWCASE_SOLUM_SKIP_UP     If 1, do not docker compose up
  SHOWCASE_SOLUM_SKIP_DOWN   If 1, leave compose running
  SHOWCASE_SOLUM_PUBLISH_EXAMPLES  If 1, copy artefacts into demo/results/

Requires: docker compose, curl, python3, sibling Solum-Demo checkout.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --skip-up) SKIP_UP=1; shift ;;
    --skip-down) SKIP_DOWN=1; shift ;;
    --publish-examples) PUBLISH_EXAMPLES=1; shift ;;
    *)
      echo "run-solum-stage: unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

if [[ ! -d "$SOLUM_DEMO_ROOT" ]]; then
  echo "run-solum-stage: Solum-Demo missing: $SOLUM_DEMO_ROOT" >&2
  echo "  Clone https://github.com/SynapticFour/Solum-Demo next to Showcase, or set SHOWCASE_SOLUM_DEMO_ROOT." >&2
  exit 1
fi
SOLUM_DEMO_ROOT="$(cd "$SOLUM_DEMO_ROOT" && pwd)"

if [[ ! -f "$SOLUM_DEMO_ROOT/docker-compose.yml" ]]; then
  echo "run-solum-stage: no docker-compose.yml under $SOLUM_DEMO_ROOT" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

wait_ready() {
  local deadline=$((SECONDS + WAIT_SECONDS))
  echo "[solum-stage] waiting for sidecar via $BASE_URL/v1/audit/export (up to ${WAIT_SECONDS}s)…"
  while (( SECONDS < deadline )); do
    code="$(curl -sS -o /dev/null -w "%{http_code}" \
      -H "$TOKEN_HEADER: $TOKEN" \
      "$BASE_URL/v1/audit/export" 2>/dev/null || echo "000")"
    if [[ "$code" == "200" ]]; then
      echo "[solum-stage] ready (HTTP $code)"
      return 0
    fi
    sleep 3
  done
  echo "run-solum-stage: timed out waiting for Solum-Demo at $BASE_URL" >&2
  return 1
}

if [[ "$SKIP_UP" != "1" ]]; then
  echo "[solum-stage] docker compose up --build -d (Solum-Demo @ $SOLUM_DEMO_ROOT)"
  echo "[solum-stage] cold build compiles solum-sidecar from pinned Solum tag — may take several minutes"
  (cd "$SOLUM_DEMO_ROOT" && docker compose up --build -d)
fi

wait_ready

export SHOWCASE_SOLUM_OUT_DIR="$OUT_DIR"
export SHOWCASE_SOLUM_BASE_URL="$BASE_URL"
export SHOWCASE_SOLUM_TOKEN="$TOKEN"
export SHOWCASE_SOLUM_TOKEN_HEADER="$TOKEN_HEADER"
export SHOWCASE_SOLUM_DEMO_ROOT_RESOLVED="$SOLUM_DEMO_ROOT"
export SHOWCASE_SOLUM_PRODUCT_TAG="$PRODUCT_TAG"

python3 <<'PY'
from __future__ import annotations

import base64
import json
import os
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

out = Path(os.environ["SHOWCASE_SOLUM_OUT_DIR"])
base = os.environ["SHOWCASE_SOLUM_BASE_URL"].rstrip("/")
token = os.environ["SHOWCASE_SOLUM_TOKEN"]
header = os.environ["SHOWCASE_SOLUM_TOKEN_HEADER"]
demo_root = os.environ["SHOWCASE_SOLUM_DEMO_ROOT_RESOLVED"]
product_tag = os.environ["SHOWCASE_SOLUM_PRODUCT_TAG"]


def request(method: str, path: str, payload: dict | None = None) -> tuple[int, dict]:
    data = None
    headers = {header: token}
    if payload is not None:
        data = json.dumps(payload).encode("utf-8")
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(f"{base}{path}", data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            body_text = resp.read().decode("utf-8")
            code = resp.getcode()
    except urllib.error.HTTPError as exc:
        body_text = exc.read().decode("utf-8", errors="replace")
        code = exc.code
    try:
        body = json.loads(body_text) if body_text.strip() else {}
    except json.JSONDecodeError:
        body = {"_raw": body_text}
    return code, body


def redact_field(body: dict) -> dict:
    out_body = dict(body)
    field = out_body.get("field")
    if isinstance(field, dict) and "ciphertext_base64" in field:
        field = dict(field)
        ct = str(field.get("ciphertext_base64") or "")
        if len(ct) > 24:
            field["ciphertext_base64"] = ct[:24] + "…"
        field["ciphertext_redacted"] = True
        out_body["field"] = field
    return out_body


plain_b64 = base64.b64encode(b"showcase-solum-stage-patient-summary").decode("ascii")

allow_code, allow_body = request(
    "POST",
    "/v1/crypto/encrypt",
    {
        "category": "patient_summary",
        "key_ref": "ephemeral/demo-patient-summary",
        "actor": "practitioner/amina",
        "capability": ["solum:crypto:encrypt"],
        "plaintext_base64": plain_b64,
    },
)
allow = {
    "scenario": "fail_closed_authorization_allow",
    "actor": "practitioner/amina",
    "capability": ["solum:crypto:encrypt"],
    "http_status": allow_code,
    "expected_status": 200,
    "ok": allow_code == 200,
    "response": redact_field(allow_body) if isinstance(allow_body, dict) else allow_body,
    "notes": "Synthetic patient summary encrypt; ephemeral demo keys only.",
}
(out / "solum-authz-allow.json").write_text(json.dumps(allow, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"wrote": "solum-authz-allow.json", "http_status": allow_code, "ok": allow["ok"]}))

deny_code, deny_body = request(
    "POST",
    "/v1/crypto/encrypt",
    {
        "category": "patient_summary",
        "key_ref": "ephemeral/demo-patient-summary",
        "actor": "practitioner/intern",
        "capability": [],
        "plaintext_base64": plain_b64,
    },
)
deny = {
    "scenario": "fail_closed_authorization_deny",
    "actor": "practitioner/intern",
    "capability": [],
    "http_status": deny_code,
    "expected_status": 403,
    "ok": deny_code == 403,
    "response": deny_body,
    "notes": "Empty capability list must fail closed with no ciphertext side effect.",
}
(out / "solum-authz-deny.json").write_text(json.dumps(deny, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"wrote": "solum-authz-deny.json", "http_status": deny_code, "ok": deny["ok"]}))

# Capture clean HELIOS chain export BEFORE tamper simulation (F5/F6).
export_code, export_body = request("GET", "/v1/audit/export", None)
if export_code == 200 and isinstance(export_body, dict):
    (out / "solum-audit-helios-chain.json").write_text(
        json.dumps(export_body, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps({"wrote": "solum-audit-helios-chain.json", "http_status": export_code, "format": export_body.get("format")}))
else:
    print(json.dumps({"wrote": "solum-audit-helios-chain.json", "http_status": export_code, "ok": False}))

# Demo harness has no token; nginx proxies /demo → harness.
tamper_code, tamper_body = request("POST", "/demo/simulate-tampering", None)
# override: harness does not need token — urllib still sent it, fine
verify_code, verify_body = request("GET", "/v1/audit/verify", None)

broken = False
if isinstance(verify_body, dict):
    if verify_body.get("error") == "chain_broken":
        broken = True
    elif verify_body.get("status") == "ok" and verify_code == 200:
        broken = False
    elif verify_code != 200:
        broken = True
else:
    broken = verify_code != 200

verify = {
    "scenario": "tamper_evident_audit",
    "harness_http_status": tamper_code,
    "verify_http_status": verify_code,
    "harness": tamper_body,
    "verify": verify_body,
    "ok": bool(isinstance(tamper_body, dict) and tamper_body.get("ok")) and broken,
    "notes": (
        "Harness rewrites audit.jsonl on the shared volume (not a Solum API). "
        "Product GET /v1/audit/verify should report chain_broken."
    ),
}
(out / "solum-audit-verify.json").write_text(json.dumps(verify, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"wrote": "solum-audit-verify.json", "ok": verify["ok"], "broken": broken}))

summary = {
    "schema_version": 1,
    "stage": "solum",
    "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
    "solum_demo_root": demo_root,
    "base_url": base,
    "product_tag_consumed_by_demo": product_tag,
    "status": "ok" if (allow["ok"] and deny["ok"] and verify["ok"]) else "degraded",
    "authz_allow_ok": allow["ok"],
    "authz_deny_ok": deny["ok"],
    "audit_tamper_detect_ok": verify["ok"],
    "authz_allow_http_status": allow_code,
    "authz_deny_http_status": deny_code,
    "verify_http_status": verify_code,
    "artefacts": {
        "allow": "solum-authz-allow.json",
        "deny": "solum-authz-deny.json",
        "verify": "solum-audit-verify.json",
        "helios_chain_export": "solum-audit-helios-chain.json",
    },
    "honesty": (
        "Local Solum-Demo with ephemeral keys — not production. "
        "Separate regulatory perimeter from Ferrum; Showcase only orchestrates. "
        "solum-audit-helios-chain.json is captured before tamper simulation for HELIOS CLIN-ACCESS."
    ),
}
(out / "solum-stage-result.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"wrote": str(out / "solum-stage-result.json"), "status": summary["status"]}))
if summary["status"] != "ok":
    raise SystemExit(1)
PY

if [[ "$PUBLISH_EXAMPLES" == "1" ]]; then
  DEST="$SHOWCASE_ROOT/demo/results"
  mkdir -p "$DEST"
  cp "$OUT_DIR/solum-authz-allow.json" "$DEST/solum-authz-allow-example.json"
  cp "$OUT_DIR/solum-authz-deny.json" "$DEST/solum-authz-deny-example.json"
  cp "$OUT_DIR/solum-audit-verify.json" "$DEST/solum-audit-verify-example.json"
  cp "$OUT_DIR/solum-stage-result.json" "$DEST/solum-stage-result-example.json"
  echo "[solum-stage] published examples under demo/results/"
fi

if [[ "$SKIP_DOWN" != "1" ]]; then
  echo "[solum-stage] docker compose down (set SHOWCASE_SOLUM_SKIP_DOWN=1 to keep running)"
  (cd "$SOLUM_DEMO_ROOT" && docker compose down)
fi

STATUS="$(python3 -c "import json; print(json.load(open('$OUT_DIR/solum-stage-result.json'))['status'])")"
echo "[solum-stage] done status=$STATUS out=$OUT_DIR"
[[ "$STATUS" == "ok" ]]
