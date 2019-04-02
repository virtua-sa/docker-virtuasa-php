#!/usr/bin/env bash
set -e

CURRENT_DOCKER_UID=$(id -u docker)
CURRENT_DOCKER_GID=$(id -g docker)

# UID and GID changing
if [[ -n "${DOCKER_DEV_UID}" ]] && [[ "${CURRENT_DOCKER_UID}" != "${DOCKER_DEV_UID}" ]]; then
    echo "Change docker UID from ${CURRENT_DOCKER_UID} to ${DOCKER_DEV_UID}"
    usermod -u ${DOCKER_DEV_UID} docker
    find / -user ${CURRENT_DOCKER_UID} -exec chown -h ${DOCKER_DEV_UID} {} \; || true
fi

if [[ -n "${DOCKER_DEV_GID}" ]] && [[ "${CURRENT_DOCKER_GID}" != "${DOCKER_DEV_GID}" ]]; then
    echo "Change docker GID from ${CURRENT_DOCKER_GID} to ${DOCKER_DEV_GID}"
    groupmod -g ${DOCKER_DEV_GID} docker
    find / -user ${CURRENT_DOCKER_GID} -exec chgrp -h ${DOCKER_DEV_GID} {} \; || true
    usermod -g ${DOCKER_DEV_GID} docker
fi

exec sudo -E -u docker "$@"
