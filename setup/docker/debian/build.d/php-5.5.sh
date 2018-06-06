#!/usr/bin/env bash
set -xe

DIR=$(dirname $0)

echo "Compile mailparse with pecl"
pecl install mailparse-2.1.6
echo '; Enable mailparse extension module' > /etc/php5/mods-available/mailparse.ini
echo "extension=mailparse.so" >> /etc/php5/mods-available/mailparse.ini

exit 0
