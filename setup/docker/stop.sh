#!/bin/bash
set -e

# Print ran commands
[[ -n "${DOCKER_DEBUG}" ]] && set -x

# Chown the /data dir
[[ -n "${DOCKER_HOST_UID}" ]] && [[ -n "${DOCKER_HOST_GID}" ]] && sudo chown -R ${DOCKER_HOST_UID}:${DOCKER_HOST_GID} "${DOCKER_BASE_DIR}"