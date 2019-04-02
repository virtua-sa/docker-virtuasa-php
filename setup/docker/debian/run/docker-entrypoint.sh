#!/usr/bin/env bash
set -e

CURRENT_DOCKER_UID=$(id -u docker)
CURRENT_DOCKER_GID=$(id -g docker)

# UID and GID changing
if [[ -n "${DOCKER_HOST_UID}" ]] && [[ "${CURRENT_DOCKER_UID}" != "${DOCKER_HOST_UID}" ]]; then
    echo "Change docker UID from ${CURRENT_DOCKER_UID} to ${DOCKER_HOST_UID}"
    usermod -u ${DOCKER_HOST_UID} docker
    find / -user ${CURRENT_DOCKER_UID} -exec chown -h ${DOCKER_HOST_UID} {} \;
fi

if [[ -n "${DOCKER_HOST_GID}" ]] && [[ "${CURRENT_DOCKER_GID}" != "${DOCKER_HOST_GID}" ]]; then
    echo "Change docker GID from ${CURRENT_DOCKER_GID} to ${DOCKER_HOST_GID}"
    groupmod -g ${DOCKER_HOST_GID} docker
    find / -user ${CURRENT_DOCKER_GID} -exec chgrp -h ${DOCKER_HOST_GID} {} \;
    usermod -g ${DOCKER_HOST_GID} docker
fi

exec sudo -u docker "$@"
