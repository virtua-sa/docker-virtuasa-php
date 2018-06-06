#!/usr/bin/env bash
set -xe

echo "Compile mailparse with pecl"
pecl install mailparse-2.1.6
echo '; Enable mailparse extension module' > /etc/php5/conf.d/mailparse.ini
echo "extension=mailparse.so" >> /etc/php5/conf.d/mailparse.ini

exit 0
