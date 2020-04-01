#!/usr/bin/env bash
set -xe

# install OpenSSL 1.0.1
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --force-yes
DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes libssl-dev info2man pkg-config libtool
DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes remove curl

# Remove wrong OpenSSL headers
rm -Rf /usr/lib/x86_64-linux-gnu/openssl-*

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
CPPFLAGS="-I/usr/include/openssl" LDFLAGS="-L/usr/lib/" ./configure --disable-shared > log-file 2>&1 || (cat log-file; exit 1)
make > log-file 2>&1 || (cat log-file; exit 1)
make install > log-file 2>&1 || (cat log-file; exit 1)
appdir=$(pwd)
cd ..
rm -Rf "${appdir}"
ln -s /usr/local/bin/curl /usr/bin/curl
curl --version

DEBIAN_FRONTEND=noninteractive apt-get purge -y --force-yes libssl-dev info2man pkg-config libtool

exit 0
