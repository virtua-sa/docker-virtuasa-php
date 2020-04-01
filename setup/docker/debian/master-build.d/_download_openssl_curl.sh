#!/usr/bin/env bash
set -xe

echo "Download OpenSSL_1_1_0.tar.gz"
[[ ! -f setup/tmp/OpenSSL_1_1_0.tar.gz ]] && (wget -q -P setup/tmp https://github.com/openssl/openssl/archive/OpenSSL_1_1_0.tar.gz || exit 1)
echo "Download curl-7.52.1.tar.gz"
[[ ! -f setup/tmp/curl-7.52.1.tar.gz ]] && (wget -q -P setup/tmp https://curl.haxx.se/download/curl-7.52.1.tar.gz || exit 1)

exit 0
