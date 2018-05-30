#!/usr/bin/env bash

# install OpenSSL 1.0.1
apt-get upgrade -y --force-yes && apt-get install -y --force-yes libssl-dev make info2man curl
apt-get -y --force-yes remove curl

echo "Build OpenSSL..."
tar xfz /setup/tmp/openssl-*
cd openssl-*
./config --prefix=/usr zlib-dynamic --openssldir=/etc/ssl shared > log-file 2>&1
make > log-file 2>&1
make install > log-file 2>&1
cd ..
rm -Rf openssl-*
openssl version || exit 1

echo "Build Curl..."
tar xfz /setup/tmp/curl-*
cd curl-*
./configure --disable-shared > log-file 2>&1
make > log-file 2>&1
make install > log-file 2>&1
cd ..
rm -Rf curl-*
ln -s /usr/local/bin/curl /usr/bin/curl
curl --version || exit 1

apt-get purge -y --force-yes libssl-dev make info2man

exit 0
