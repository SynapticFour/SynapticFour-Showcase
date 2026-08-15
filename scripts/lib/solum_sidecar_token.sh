# Shared Solum sidecar token resolution. Source this file; do not execute it.
# Sets RESOLVED_SOLUM_SIDECAR_TOKEN or returns 1.
#
# The well-known Solum-Demo compose token is never applied silently.
# Live scripts must receive SOLUM_SIDECAR_TOKEN or SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1.

SHOWCASE_DEMO_SIDECAR_TOKEN="solum-demo-local-token-not-for-production"

resolve_solum_sidecar_token() {
  if [[ "${SHOWCASE_REQUIRE_SIDECAR_TOKEN:-0}" == "1" ]]; then
    if [[ -z "${SOLUM_SIDECAR_TOKEN:-}" || "${SOLUM_SIDECAR_TOKEN}" == "${SHOWCASE_DEMO_SIDECAR_TOKEN}" ]]; then
      echo "resolve_solum_sidecar_token: SHOWCASE_REQUIRE_SIDECAR_TOKEN=1 refuses the demo default; set SOLUM_SIDECAR_TOKEN to a site secret." >&2
      return 1
    fi
  fi
  if [[ -n "${SOLUM_SIDECAR_TOKEN:-}" ]]; then
    RESOLVED_SOLUM_SIDECAR_TOKEN="${SOLUM_SIDECAR_TOKEN}"
    return 0
  fi
  if [[ "${SHOWCASE_USE_DEMO_SIDECAR_TOKEN:-0}" == "1" ]]; then
    RESOLVED_SOLUM_SIDECAR_TOKEN="${SHOWCASE_DEMO_SIDECAR_TOKEN}"
    echo "resolve_solum_sidecar_token: using Solum-Demo well-known local token (SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1). Not a production credential." >&2
    return 0
  fi
  echo "resolve_solum_sidecar_token: SOLUM_SIDECAR_TOKEN is unset." >&2
  echo "  Local Solum-Demo compose: SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1 <command>" >&2
  echo "  Any other stack: export SOLUM_SIDECAR_TOKEN to match the sidecar." >&2
  return 1
}
