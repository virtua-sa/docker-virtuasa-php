#!/usr/bin/env bash

# Make sure we stop building/pushing images if an error happens
set -e

dp_phpv="$1"
[[ "${dp_phpv}" = "all" ]] \
    && $0 5.2 && $0 5.3 && $0 5.4 && $0 5.5 && $0 5.6 \
    && $0 7.0 && $0 7.1 && $0 7.2 && $0 7.3 && $0 7.4 \
    && $0 8.0 \
    && exit 0;

[[ ! "${dp_phpv}" =~ ^[578]\.[0-9]$ ]] && echo "Wrong PHP version number: ${dp_phpv}" && exit 1;

docker ps -aq --filter "name=virtuasa/php:${dp_phpv}-dev" | xargs -rn1 docker rm

docker images -q virtuasa/php:${dp_phpv}-dev | xargs -rn1 docker rmi
