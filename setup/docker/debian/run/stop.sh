#!/usr/bin/env bash
set -e

# Print ran commands
[[ -n "${DOCKER_DEBUG}" ]] && set -x

# Exec custom stop script
[[ -n "${DOCKER_CUSTOM_STOP}" ]] && [[ -e "${DOCKER_CUSTOM_STOP}" ]] && sudo chmod +x "${DOCKER_CUSTOM_STOP}" \
    && echo "Executing custom stop script: ${DOCKER_CUSTOM_STOP} ..." \
    && ./${DOCKER_CUSTOM_STOP}
