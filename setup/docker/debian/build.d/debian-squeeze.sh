#!/usr/bin/env bash
set -xe

PATH=$(dirname $0)
${PATH}/_compile_openssl_curl.sh

exit 0;
