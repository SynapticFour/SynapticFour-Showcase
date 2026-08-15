#!/usr/bin/env bash
# The well-known Solum-Demo token must never be applied as a silent default.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../scripts/lib/solum_sidecar_token.sh
source "$ROOT/scripts/lib/solum_sidecar_token.sh"

unset SOLUM_SIDECAR_TOKEN || true
unset SHOWCASE_USE_DEMO_SIDECAR_TOKEN || true
unset SHOWCASE_REQUIRE_SIDECAR_TOKEN || true
RESOLVED_SOLUM_SIDECAR_TOKEN=""
if resolve_solum_sidecar_token 2>/dev/null; then
  echo "test_solum_token: expected failure when token unset" >&2
  exit 1
fi

SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1
resolve_solum_sidecar_token
[[ "$RESOLVED_SOLUM_SIDECAR_TOKEN" == "$SHOWCASE_DEMO_SIDECAR_TOKEN" ]]

unset SHOWCASE_USE_DEMO_SIDECAR_TOKEN
SOLUM_SIDECAR_TOKEN="site-secret-not-demo"
resolve_solum_sidecar_token
[[ "$RESOLVED_SOLUM_SIDECAR_TOKEN" == "site-secret-not-demo" ]]

SHOWCASE_REQUIRE_SIDECAR_TOKEN=1
SOLUM_SIDECAR_TOKEN="$SHOWCASE_DEMO_SIDECAR_TOKEN"
if resolve_solum_sidecar_token 2>/dev/null; then
  echo "test_solum_token: REQUIRE=1 must refuse the demo token" >&2
  exit 1
fi

echo "test_solum_token: ok"
