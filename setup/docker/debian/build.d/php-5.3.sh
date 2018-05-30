#!/usr/bin/env bash

echo "Compile xdebug with pecl"
apt-get remove php5-xdebug
pecl install xdebug-2.2.7
echo '; Enable xdebug extension module' > /etc/php5/conf.d/xdebug.ini
echo "zend_extension=`find /usr/lib -name xdebug.so | tr -d '[:space:]'`" >> /etc/php5/conf.d/xdebug.ini
rm -f /etc/php5/cli/conf.d/xdebug.ini /etc/php5/cgi/conf.d/xdebug.ini
ln -s /etc/php5/conf.d/xdebug.ini /etc/php5/cli/conf.d/xdebug.ini
ln -s /etc/php5/conf.d/xdebug.ini /etc/php5/cgi/conf.d/xdebug.ini
