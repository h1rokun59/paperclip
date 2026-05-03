#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${REPO_ROOT}/.env"
COMPOSE_FILE="${REPO_ROOT}/docker/docker-compose.mdr.yml"
COMPANY_SLUG="mdr-frontier-research-lab"
COMPANY_NAME="MDR Frontier Research Lab"
CONTAINER_NAME="paperclip-mdr"
REMOTE_NAME="${PAPERCLIP_MDR_REMOTE:-}"
SKIP_PULL="${PAPERCLIP_MDR_SKIP_PULL:-0}"
SKIP_IMPORT="${PAPERCLIP_MDR_SKIP_IMPORT:-0}"

usage() {
  cat <<'USAGE'
Usage: scripts/mdr-up.sh [--no-pull] [--no-import]

Starts the local Paperclip MDR research lab from the latest Git state.

Options:
  --no-pull     Do not fetch/pull the configured Git remote.
  --no-import   Start Paperclip but skip the MDR company import check.

Environment:
  PAPERCLIP_MDR_REMOTE      Git remote to pull from. Defaults to private, then origin.
  PAPERCLIP_MDR_SKIP_PULL   Set to 1 to skip Git pull.
  PAPERCLIP_MDR_SKIP_IMPORT Set to 1 to skip company import.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-pull)
      SKIP_PULL=1
      ;;
    --no-import)
      SKIP_IMPORT=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

log() {
  printf '[mdr-up] %s\n' "$*"
}

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Required command not found: $1" >&2
    exit 1
  fi
}

random_hex_32() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32
    return
  fi
  node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
}

resolve_remote() {
  if [ -n "${REMOTE_NAME}" ]; then
    printf '%s\n' "${REMOTE_NAME}"
    return
  fi
  if git -C "${REPO_ROOT}" remote get-url private >/dev/null 2>&1; then
    printf '%s\n' private
    return
  fi
  printf '%s\n' origin
}

pull_latest() {
  if [ "${SKIP_PULL}" = "1" ]; then
    log "Skipping git pull."
    return
  fi

  if ! git -C "${REPO_ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    log "Not inside a git worktree; skipping git pull."
    return
  fi

  if [ -n "$(git -C "${REPO_ROOT}" status --porcelain)" ]; then
    log "Worktree has local changes; skipping git pull to avoid mixing states."
    return
  fi

  local remote branch
  remote="$(resolve_remote)"
  branch="$(git -C "${REPO_ROOT}" branch --show-current)"
  if [ -z "${branch}" ]; then
    log "Detached HEAD; skipping git pull."
    return
  fi
  if ! git -C "${REPO_ROOT}" remote get-url "${remote}" >/dev/null 2>&1; then
    log "Remote '${remote}' is not configured; skipping git pull."
    return
  fi

  log "Pulling latest ${remote}/${branch}."
  git -C "${REPO_ROOT}" fetch "${remote}" "${branch}"
  git -C "${REPO_ROOT}" pull --ff-only "${remote}" "${branch}"
}

ensure_env() {
  if [ -f "${ENV_FILE}" ]; then
    return
  fi

  log "Creating local .env."
  cat > "${ENV_FILE}" <<EOF
BETTER_AUTH_SECRET=$(random_hex_32)
PAPERCLIP_PUBLIC_URL=http://localhost:3100
PAPERCLIP_PORT=3100
PAPERCLIP_DATA_DIR=./data/docker-paperclip
OPENAI_API_KEY=
ANTHROPIC_API_KEY=
EOF
  chmod 600 "${ENV_FILE}" || true
}

load_env() {
  set -a
  # shellcheck disable=SC1090
  . "${ENV_FILE}"
  set +a

  PAPERCLIP_PORT="${PAPERCLIP_PORT:-3100}"
  PAPERCLIP_PUBLIC_URL="${PAPERCLIP_PUBLIC_URL:-http://localhost:${PAPERCLIP_PORT}}"
  PAPERCLIP_DATA_DIR="${PAPERCLIP_DATA_DIR:-./data/docker-paperclip}"
  case "${PAPERCLIP_DATA_DIR}" in
    /*) DATA_DIR="${PAPERCLIP_DATA_DIR}" ;;
    ../*) DATA_DIR="$(cd "${REPO_ROOT}/docker" && pwd)/${PAPERCLIP_DATA_DIR}" ;;
    *) DATA_DIR="${REPO_ROOT}/${PAPERCLIP_DATA_DIR#./}" ;;
  esac
}

ensure_config() {
  local instance_dir config_file now
  instance_dir="${DATA_DIR}/instances/default"
  config_file="${instance_dir}/config.json"
  mkdir -p "${instance_dir}" "${DATA_DIR}/bin" "${DATA_DIR}/imports"

  cat > "${DATA_DIR}/bin/xdg-open" <<'EOF'
#!/bin/sh
exit 0
EOF
  chmod +x "${DATA_DIR}/bin/xdg-open"

  if [ -f "${config_file}" ]; then
    return
  fi

  log "Creating Paperclip local config."
  now="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  cat > "${config_file}" <<EOF
{
  "\$meta": {
    "version": 1,
    "updatedAt": "${now}",
    "source": "onboard"
  },
  "database": {
    "mode": "embedded-postgres",
    "embeddedPostgresDataDir": "/paperclip/instances/default/db",
    "embeddedPostgresPort": 54329,
    "backup": {
      "enabled": true,
      "intervalMinutes": 60,
      "retentionDays": 7,
      "dir": "/paperclip/instances/default/data/backups"
    }
  },
  "logging": {
    "mode": "file",
    "logDir": "/paperclip/instances/default/logs"
  },
  "server": {
    "deploymentMode": "authenticated",
    "exposure": "private",
    "bind": "lan",
    "host": "0.0.0.0",
    "port": 3100,
    "allowedHostnames": ["localhost", "127.0.0.1"],
    "serveUi": true
  },
  "auth": {
    "baseUrlMode": "explicit",
    "publicBaseUrl": "${PAPERCLIP_PUBLIC_URL}",
    "disableSignUp": false
  },
  "telemetry": {
    "enabled": true
  },
  "storage": {
    "provider": "local_disk",
    "localDisk": {
      "baseDir": "/paperclip/instances/default/data/storage"
    },
    "s3": {
      "bucket": "paperclip",
      "region": "us-east-1",
      "prefix": "",
      "forcePathStyle": false
    }
  },
  "secrets": {
    "provider": "local_encrypted",
    "strictMode": false,
    "localEncrypted": {
      "keyFilePath": "/paperclip/instances/default/secrets/master.key"
    }
  }
}
EOF
}

sync_company_package() {
  local src dst
  src="${REPO_ROOT}/companies/${COMPANY_SLUG}"
  dst="${DATA_DIR}/imports/${COMPANY_SLUG}"
  if [ ! -d "${src}" ]; then
    echo "Company package not found: ${src}" >&2
    exit 1
  fi
  rm -rf "${dst}"
  mkdir -p "${DATA_DIR}/imports"
  cp -R "${src}" "${dst}"
}

compose_up() {
  if docker container inspect "${CONTAINER_NAME}" >/dev/null 2>&1; then
    if [ "$(docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}")" = "true" ]; then
      log "Docker container ${CONTAINER_NAME} is already running."
      return
    fi
    log "Starting existing Docker container ${CONTAINER_NAME}."
    docker start "${CONTAINER_NAME}" >/dev/null
    return
  fi

  log "Starting Paperclip Docker container."
  PAPERCLIP_DATA_DIR="${DATA_DIR}" \
  PAPERCLIP_PUBLIC_URL="${PAPERCLIP_PUBLIC_URL}" \
  PAPERCLIP_PORT="${PAPERCLIP_PORT}" \
  docker compose \
    --project-directory "${REPO_ROOT}" \
    --env-file "${ENV_FILE}" \
    --project-name paperclip-mdr \
    -f "${COMPOSE_FILE}" \
    up -d
}

health_json() {
  curl -fsS "http://127.0.0.1:${PAPERCLIP_PORT}/api/health"
}

wait_for_health() {
  local attempt
  for attempt in $(seq 1 90); do
    if health_json >/tmp/paperclip-mdr-health.json 2>/dev/null; then
      cat /tmp/paperclip-mdr-health.json
      rm -f /tmp/paperclip-mdr-health.json
      return
    fi
    sleep 2
  done
  echo "Paperclip did not become healthy on port ${PAPERCLIP_PORT}." >&2
  docker logs --tail 120 "${CONTAINER_NAME}" >&2 || true
  exit 1
}

docker_cli() {
  docker exec -u node \
    -e PATH=/paperclip/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    "${CONTAINER_NAME}" \
    node /app/cli/node_modules/tsx/dist/cli.mjs /app/cli/src/index.ts "$@"
}

ensure_bootstrap_ready() {
  local health
  health="$(health_json)"
  if printf '%s' "${health}" | grep -q '"bootstrapStatus":"ready"'; then
    return
  fi

  log "First-run bootstrap is pending. Creating a CEO invite."
  docker_cli auth bootstrap-ceo --force --base-url "${PAPERCLIP_PUBLIC_URL}" || true
  echo
  echo "Open the invite URL above, create the first admin user, then leave this command running."
  echo "Waiting for bootstrap to become ready..."
  while true; do
    sleep 3
    health="$(health_json || true)"
    if printf '%s' "${health}" | grep -q '"bootstrapStatus":"ready"'; then
      log "Bootstrap is ready."
      return
    fi
  done
}

ensure_cli_auth() {
  if docker_cli auth whoami --api-base "http://localhost:3100" --json >/dev/null 2>&1; then
    return
  fi

  log "CLI admin authentication is required. Approve the browser URL printed below."
  docker_cli auth login --instance-admin --api-base "http://localhost:3100"
}

company_exists() {
  docker_cli company list --api-base "http://localhost:3100" --json \
    | node -e "let s='';process.stdin.on('data',d=>s+=d);process.stdin.on('end',()=>{const rows=JSON.parse(s);process.exit(rows.some(c=>c.name===process.argv[1])?0:1)})" "${COMPANY_NAME}"
}

ensure_company_imported() {
  if [ "${SKIP_IMPORT}" = "1" ]; then
    log "Skipping company import."
    return
  fi

  ensure_bootstrap_ready
  ensure_cli_auth

  if company_exists; then
    log "${COMPANY_NAME} already exists."
  else
    log "Importing ${COMPANY_NAME}."
    docker_cli company import "/paperclip/imports/${COMPANY_SLUG}" \
      --target new \
      --include company,agents,projects,tasks,skills \
      --yes \
      --api-base "http://localhost:3100"
  fi

  local company_id
  company_id="$(docker_cli company list --api-base "http://localhost:3100" --json \
    | node -e "let s='';process.stdin.on('data',d=>s+=d);process.stdin.on('end',()=>{const rows=JSON.parse(s);const row=rows.find(c=>c.name===process.argv[1]); if(row) process.stdout.write(row.id)})" "${COMPANY_NAME}")"
  if [ -n "${company_id}" ]; then
    docker_cli context set --profile mdr --api-base "http://localhost:3100" --company-id "${company_id}" --use --json >/dev/null
  fi
}

main() {
  need_cmd git
  need_cmd docker
  need_cmd curl
  need_cmd node

  cd "${REPO_ROOT}"
  pull_latest
  ensure_env
  load_env
  ensure_config
  sync_company_package
  compose_up

  log "Waiting for Paperclip health."
  wait_for_health >/dev/null
  ensure_company_imported

  echo
  echo "Paperclip MDR is ready:"
  echo "  ${PAPERCLIP_PUBLIC_URL}/MDR/dashboard"
  echo
  echo "Useful commands:"
  echo "  docker logs -f ${CONTAINER_NAME}"
  echo "  docker compose --project-name paperclip-mdr -f docker/docker-compose.mdr.yml down"
}

main "$@"
