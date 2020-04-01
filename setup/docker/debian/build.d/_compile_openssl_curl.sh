#!/usr/bin/env bash
set -xe

# install OpenSSL 1.0.1
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --force-yes
DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes libssl-dev info2man curl
DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes remove curl

echo "Build OpenSSL..."
tar xfz /setup/tmp/openssl-*
cd openssl-*
./config --prefix=/usr zlib-dynamic --openssldir=/etc/ssl shared > log-file 2>&1 || (cat log-file; exit 1)
make > log-file 2>&1 || (cat log-file; exit 1)
make install > log-file 2>&1 || (cat log-file; exit 1)
appdir=$(pwd)
cd ..
rm -Rf "${appdir}"
openssl version

echo "Build Curl..."
tar xfz /setup/tmp/curl-*
cd curl-*
./configure --disable-shared > log-file 2>&1 || (cat log-file; exit 1)
make > log-file 2>&1 || (cat log-file; exit 1)
make install > log-file 2>&1 || (cat log-file; exit 1)
appdir=$(pwd)
cd ..
rm -Rf "${appdir}"
ln -s /usr/local/bin/curl /usr/bin/curl
curl --version

DEBIAN_FRONTEND=noninteractive apt-get purge -y --force-yes libssl-dev info2man

exit 0
