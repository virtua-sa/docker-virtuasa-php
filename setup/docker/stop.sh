#!/bin/bash
set -e

# Chown the /data dir
sudo chown -R ${DOCKER_HOST_UID}:${DOCKER_HOST_GID} "${DOCKER_BASE_DIR}"