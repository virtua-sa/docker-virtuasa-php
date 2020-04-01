#!/usr/bin/env bash
set -xe

echo "Download openssl-1.1.0f.tar.gz"
[[ ! -f setup/tmp/openssl-1.1.0f.tar.gz ]] && (wget -q -P setup/tmp https://www.openssl.org/source/openssl-1.1.0f.tar.gz || exit 1)
echo "Download curl-7.52.1.tar.gz"
[[ ! -f setup/tmp/curl-7.52.1.tar.gz ]] && (wget -q -P setup/tmp https://curl.haxx.se/download/curl-7.52.1.tar.gz || exit 1)

exit 0
