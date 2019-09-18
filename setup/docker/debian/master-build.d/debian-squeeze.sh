#!/usr/bin/env bash
set -xe

echo "Download openssl-1.1.1d.tar.gz"
wget -q -P setup/tmp https://www.openssl.org/source/openssl-1.1.1d.tar.gz || exit 1
echo "Download curl-7.66.0.tar.gz"
wget -q -P setup/tmp https://curl.haxx.se/download/curl-7.66.0.tar.gz || exit 1

exit 0
