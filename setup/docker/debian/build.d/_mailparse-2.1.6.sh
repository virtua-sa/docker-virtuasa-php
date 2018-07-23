#!/usr/bin/env bash
set -xe

echo "Compile mailparse with pecl"
pecl install mailparse-2.1.6

if [ -d "/etc/php${PHP_VERSION_DIR}/mods-available/" ]; then
    echo '; Enable mailparse extension module' > /etc/php${PHP_VERSION_DIR}/mods-available/mailparse.ini
    echo "extension=mailparse.so" >> /etc/php${PHP_VERSION_DIR}/mods-available/mailparse.ini
    php5enmod mailparse
else
    echo '; Enable mailparse extension module' > /etc/php${PHP_VERSION_DIR}/conf.d/mailparse.ini
    echo "extension=mailparse.so" >> /etc/php${PHP_VERSION_DIR}/conf.d/mailparse.ini
fi

exit 0
