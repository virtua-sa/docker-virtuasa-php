#!/bin/bash
set -xe

# Print all environment variables
printenv

# Check if Debian version is already configured
[[ ! -e "/home/docker/docker/apt/debian-${FROM_IMAGE##*:}" ]] \
    && echo "Debian version not supported yet, file /home/docker/docker/apt/debian-${FROM_IMAGE##*:} doesn't exist !" \
    && exit 1;

# Check if PHP version is already configured
[[ ! -e "/home/docker/docker/apt/php-${PHP_VERSION}" ]] \
    && echo "PHP version not supported yet, file /home/docker/docker/apt/php-${PHP_VERSION} doesn't exist !" \
    && exit 1;

# Install base packages
apt-get update && apt-get install -y --fix-missing --no-install-recommends \
    $(</home/docker/docker/apt/debian-${FROM_IMAGE##*:})

# Use Sury repository, to get PHP 7+ on Debian
if [[ "${PHP_VERSION}" =~ ^7\. ]]; then
    echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list
    curl -sSL https://packages.sury.org/php/apt.gpg | apt-key add -
fi

# Use Yarnpkg repository, to get Yarn on Debian
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

# Use Nodesource, to get Node.js 6x on Debian
curl -sSL https://deb.nodesource.com/setup_6.x | bash -

# Update APT and list all available PHP packages
apt-get update
apt-cache search php${PHP_VERSION_APT} | grep -v dbgsym | cut -d' ' -f1

# Install development tools
apt-get install -y --fix-missing --no-install-recommends \
    $(</home/docker/docker/apt/php-${PHP_VERSION}) \
    nodejs \
    yarn

# Remove unnecessary files left after installations
apt-get clean -y && apt-get autoclean -y && rm -r /var/lib/apt/lists/*

# Ensure PHP7 and Node.js are correctly installed
php -v
echo -n "Node.js " && node -v && echo -n "NPM v" && npm -v

# Install Composer
if [[ "${PHP_VERSION}" != "5.2" ]]; then
    curl -sSL https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
    echo -n "composer --version : " && composer --version
fi

# Install PHPUnit
if [[ "${PHP_VERSION}" =~ ^7\. ]]; then
    curl -sSL https://phar.phpunit.de/phpunit-6.2.phar > /usr/local/bin/phpunit62 && chmod +x /usr/local/bin/phpunit62
    echo -n "phpunit62 --version : " && phpunit62 --version
fi
curl -sSL https://phar.phpunit.de/phpunit-5.7.phar > /usr/local/bin/phpunit57 && chmod +x /usr/local/bin/phpunit57
echo -n "phpunit57 --version : " && phpunit57 --version
curl -sSL https://phar.phpunit.de/phpunit-4.8.phar > /usr/local/bin/phpunit48 && chmod +x /usr/local/bin/phpunit48
echo -n "phpunit48 --version : " && phpunit48 --version

# Install common Node.js tools
npm install -g bower grunt gulp webpack

# Configure Apache
a2enmod rewrite ssl
mkdir -p /var/logs/apache
chmod -R 755 /var/logs/apache

# Copy initial configuration files
ls -alhR /etc/php${PHP_VERSION_DIR}
ls -alhR /etc/apache2/sites-available
cp /home/docker/php/apache/conf.d/*docker*.ini /etc/php${PHP_VERSION_DIR}/apache2/conf.d
cp /home/docker/php/cli/conf.d/*docker*.ini /etc/php${PHP_VERSION_DIR}/cli/conf.d
(cd /etc/apache2/sites-enabled && a2dissite *)
rm /etc/apache2/sites-available/*
cp /home/docker/apache/*.conf /etc/apache2/sites-available

# Create mountpoint for the web application
mkdir -p "${DOCKER_BASE_DIR}"
chmod -R 755 "${DOCKER_BASE_DIR}"

# Create a non privileged user
useradd --create-home --groups sudo --shell /bin/bash docker
echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/docker
