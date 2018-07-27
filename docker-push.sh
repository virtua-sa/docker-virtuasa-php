#!/usr/bin/env bash

# Make sure we stop building/pushing images if an error happens
set -e

dp_phpv="$1"
dp_sub="$2"
[[ "${dp_phpv}" = "all" ]] \
    && $0 5.2 ${dp_tags} && $0 5.3 ${dp_tags} && $0 5.4 ${dp_tags} && $0 5.5 ${dp_tags} && $0 5.6 ${dp_tags} \
    && $0 7.0 ${dp_tags} && $0 7.1 ${dp_tags} && $0 7.2 ${dp_tags} && exit 0;

[[ ! "${dp_phpv}" =~ ^[57]\.[0-9]$ ]] && echo "Wrong PHP version number: ${dp_phpv}" && exit 1;

docker tag virtuasa/php:${dp_phpv}${dp_sub} virtuasa/php:${dp_phpv}${dp_sub}
docker push virtuasa/php:${dp_phpv}${dp_sub}
