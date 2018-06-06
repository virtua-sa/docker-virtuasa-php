#!/usr/bin/env bash
set -xe

echo "Compile xdebug with pecl"
DEBIAN_FRONTEND=noninteractive apt-get remove -y --force-yes php5-xdebug
pecl install xdebug-2.2.7
echo '; Enable xdebug extension module' > /etc/php5/conf.d/xdebug.ini
echo "zend_extension=`find /usr/lib -name xdebug.so | tr -d '[:space:]'`" >> /etc/php5/conf.d/xdebug.ini

exit 0
