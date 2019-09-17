#!/usr/bin/env bash
set -xe

DIR=$(dirname $0)
${DIR}/_compile_openssl_curl.sh

exit 0;
