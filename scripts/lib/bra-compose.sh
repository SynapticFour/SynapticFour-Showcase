# shellcheck shell=bash
# Shared docker compose invocation for bioresearch-assistant (optional Postgres port override).
# Expects: BRA_ROOT, SHOWCASE_ROOT (absolute paths).

bra_docker_compose_files() {
  local bra_root="$1"
  local showcase_root="$2"
  local override="${SHOWCASE_BRA_COMPOSE_OVERRIDE:-$showcase_root/contrib/bioresearch-assistant-postgres-override.yml}"
  BRA_COMPOSE_FILES=("$bra_root/docker-compose.yml")
  if [[ "${SHOWCASE_BRA_POSTGRES_HOST_PORT_OVERRIDE:-1}" == "1" && -f "$override" ]]; then
    BRA_COMPOSE_FILES+=("$override")
  fi
}

# Usage: bra_docker_compose "$BRA_ROOT" "$SHOWCASE_ROOT" [docker compose args... e.g. up -d]
bra_docker_compose() {
  local bra_root="$1"
  local showcase_root="$2"
  shift 2
  bra_docker_compose_files "$bra_root" "$showcase_root"
  local args=()
  for f in "${BRA_COMPOSE_FILES[@]}"; do
    args+=(-f "$f")
  done
  ( cd "$bra_root" && docker compose "${args[@]}" "$@" )
}
