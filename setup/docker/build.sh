#!/bin/bash
set -xe

# Print all environment variables
printenv

# Check if Debian version is already configured
[[ ! -e "/setup/docker/apt/debian-${DOCKER_FROM_IMAGE##*:}" ]] \
    && echo "Debian version not supported yet, file /setup/docker/apt/debian-${DOCKER_FROM_IMAGE##*:} doesn't exist !" \
    && exit 1;

# Check if PHP version is already configured
[[ ! -e "/setup/docker/apt/php-${PHP_VERSION}" ]] \
    && echo "PHP version not supported yet, file /setup/docker/apt/php-${PHP_VERSION} doesn't exist !" \
    && exit 1;

# Install base packages
apt-get update && apt-get install -y --fix-missing --no-install-recommends \
    $(</setup/docker/apt/debian-${DOCKER_FROM_IMAGE##*:})

# Use Sury repository, to get PHP 7+ on Debian 9
if [[ "${PHP_VERSION}" =~ ^7\. ]]; then
    echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list
    curl -sSL https://packages.sury.org/php/apt.gpg | apt-key add -
fi

# Use Dotdeb repository, to get PHP 5.5 on Debian 7
if [[ "${PHP_VERSION}" = "5.5" ]]; then
    echo "deb http://packages.dotdeb.org wheezy-php55 all" > /etc/apt/sources.list.d/dotdeb.list
    curl -sSL https://www.dotdeb.org/dotdeb.gpg | apt-key add -
fi

# Use Yarnpkg repository, to get Yarn on Debian
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ wheezy|jessie|stretch ]]; then
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
fi

# Use Nodesource, to get Node.js 6x on Debian
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ wheezy|jessie|stretch ]]; then
    curl -sSL https://deb.nodesource.com/setup_6.x | bash -
fi

# Update APT and list all available PHP packages
apt-get update
apt-cache search php${PHP_VERSION_APT} | grep -v dbgsym | cut -d' ' -f1

# Install development tools
apt-get install -y --fix-missing --no-install-recommends \
    $(</setup/docker/apt/php-${PHP_VERSION})
php -v
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ wheezy|jessie|stretch ]]; then
    apt-get install -y --fix-missing --no-install-recommends \
        nodejs \
        yarn
    echo -n "Node.js " && node -v && echo -n "NPM v" && npm -v
fi

# Remove unnecessary files left after installations
apt-get clean -y && apt-get autoclean -y && rm -r /var/lib/apt/lists/*

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
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.6)) ]]; then
    curl -sSL https://phar.phpunit.de/phpunit-5.7.phar > /usr/local/bin/phpunit57 && chmod +x /usr/local/bin/phpunit57
    echo -n "phpunit57 --version : " && phpunit57 --version
fi
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[3456])) ]]; then
    curl -sSL https://phar.phpunit.de/phpunit-4.8.phar > /usr/local/bin/phpunit48 && chmod +x /usr/local/bin/phpunit48
    echo -n "phpunit48 --version : " && phpunit48 --version
fi

# Install common Node.js tools
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ wheezy|jessie|stretch ]]; then
    npm install -g bower grunt gulp webpack
fi

# Configure Apache
a2enmod headers php${PHP_VERSION_APT} rewrite ssl
[[ "${DOCKER_FROM_IMAGE##*:}" =~ lenny|squeeze ]] && a2enmod version
mkdir -p /var/logs/apache
chmod -R 755 /var/logs/apache

# Copy initial configuration files
ls -alhR /etc/php${PHP_VERSION_DIR}
ls -alhR /etc/apache2/sites-available
cp /setup/php/apache/conf.d/*docker*.ini /etc/php${PHP_VERSION_DIR}/apache2/conf.d
cp /setup/php/cli/conf.d/*docker*.ini /etc/php${PHP_VERSION_DIR}/cli/conf.d
(cd /etc/apache2/sites-enabled && a2dissite *)
rm /etc/apache2/sites-available/*
cp /setup/apache/*.conf /etc/apache2/sites-available

# Create mountpoint for the web application
mkdir -p "${DOCKER_BASE_DIR}"
chmod -R 755 "${DOCKER_BASE_DIR}"

# Create a non privileged user
useradd --create-home --groups sudo --shell /bin/bash docker
if [[ "${DOCKER_FROM_IMAGE##*:}" = "lenny" ]]; then
    echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
else
    echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/docker
    chmod 440 /etc/sudoers.d/docker
fi
adduser docker www-data
adduser www-data docker
chown docker "${DOCKER_BASE_DIR}"

# Clean all unecessary files (doc)
find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true
find /usr/share/doc -empty|xargs rmdir || true
rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/*
rm -rf /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*