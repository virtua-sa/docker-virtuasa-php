#!/usr/bin/env bash
set -e

PHP_VERSION="$1"
PUSH_SUFIX="-light"

echo "Start build for branch $PHP_VERSION"
./docker-build.sh "${PHP_VERSION}"
echo "Docker Push Dev images..."
./docker-push.sh "${PHP_VERSION}" "${PUSH_SUFIX}"
echo "Cleaup .."
./docker-clean.sh "${PHP_VERSION}"

echo "Finish build image"

exit 0;
