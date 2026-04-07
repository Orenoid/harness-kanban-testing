#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ENV_FILE="${REPO_ROOT}/.devcontainer/workspace.env"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Missing ${ENV_FILE}" >&2
  exit 1
fi

set -a
source "${ENV_FILE}"
set +a

pnpm_cmd() {
  if command -v pnpm >/dev/null 2>&1; then
    pnpm "$@"
  else
    corepack pnpm "$@"
  fi
}

run_as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo -n "$@"
  else
    return 1
  fi
}

ensure_workspace_node_modules_writable() {
  local node_modules_dir="${REPO_ROOT}/node_modules"
  local uid gid
  uid="$(id -u)"
  gid="$(id -g)"

  if [[ -w "${node_modules_dir}" ]]; then
    return 0
  fi

  echo "Ensuring ${node_modules_dir} is writable..."

  if ! run_as_root mkdir -p "${node_modules_dir}"; then
    echo "Failed to create ${node_modules_dir} with elevated permissions." >&2
    return 1
  fi

  if ! run_as_root chown -R "${uid}:${gid}" "${node_modules_dir}"; then
    echo "Failed to update ownership for ${node_modules_dir}." >&2
    return 1
  fi

  if [[ ! -w "${node_modules_dir}" ]]; then
    echo "${node_modules_dir} is still not writable after fixing permissions." >&2
    return 1
  fi
}

write_env_files() {
  echo "Writing development .env files..."

  mkdir -p "${REPO_ROOT}/apps/api-server" "${REPO_ROOT}/apps/web"

  cat > "${REPO_ROOT}/apps/api-server/.env" <<EOF
PORT=${API_PORT}
NODE_ENV=development
APP_ENV=${APP_ENV}

BETTER_AUTH_SECRET=${BETTER_AUTH_SECRET}
BETTER_AUTH_URL=${BETTER_AUTH_URL}

APP_BASE_URL=${APP_BASE_URL}

AI_PROVIDER=${AI_PROVIDER}
OPENAI_API_KEY=${OPENAI_API_KEY}
OPENAI_MODEL=${OPENAI_MODEL}

EMBEDDING_OPENAI_API_KEY=${EMBEDDING_OPENAI_API_KEY}
EMBEDDING_OPENAI_MODEL=${EMBEDDING_OPENAI_MODEL}
EOF

  cat > "${REPO_ROOT}/apps/web/.env" <<EOF
PORT=${WEB_PORT}
NEXT_PUBLIC_APP_BASE_URL=${NEXT_PUBLIC_APP_BASE_URL}
NEXT_PUBLIC_API_SERVER_URL=${NEXT_PUBLIC_API_SERVER_URL}
EOF
}

main() {
  cd "${REPO_ROOT}"

  write_env_files
  ensure_workspace_node_modules_writable

  echo "Installing workspace dependencies..."
  pnpm_cmd install

  echo "Devcontainer initialization complete."
}

main "$@"
