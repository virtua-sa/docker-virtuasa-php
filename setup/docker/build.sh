#!/bin/bash
set -xe

# Print all environment variables
printenv

# Print all shell options
shopt

# Enable some shell options
shopt -s extglob

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

# Use Nodesource, to get Node.js on Debian
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ wheezy ]]; then
    curl -sSL https://deb.nodesource.com/setup_6.x | bash -
fi
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ jessie|stretch ]]; then
    curl -sSL https://deb.nodesource.com/setup_8.x | bash -
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

# Fix PHP 5.6 issue with uprofiler (https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=784774)
if [[ "${PHP_VERSION}" = "5.6" ]]; then
    sed -i "s/extension=profiler.so/extension=uprofiler.so/g" /etc/php5/mods-available/uprofiler.ini
fi

# Install Behat
if [[ "${PHP_VERSION}" =~ ^(5\.[3]) ]]; then
    curl -sSL https://github.com/Behat/Behat/releases/download/v3.2.2/behat.phar > /usr/local/bin/behat && chmod +x /usr/local/bin/behat
    echo -n "behat --version : " && behat --version
    rm -rf /tmp/behat_gherkin_cache
elif [[ "${PHP_VERSION}" =~ ^(5\.[45]) ]]; then
    curl -sSL https://github.com/Behat/Behat/releases/download/v3.3.0/behat.phar > /usr/local/bin/behat && chmod +x /usr/local/bin/behat
    echo -n "behat --version : " && behat --version
    rm -rf /tmp/behat_gherkin_cache
elif [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.6)) ]]; then
    curl -sSL https://github.com/Behat/Behat/releases/download/v3.3.0/behat.phar > /usr/local/bin/behat && chmod +x /usr/local/bin/behat
    echo -n "behat --version : " && behat --version
    rm -rf /tmp/behat_gherkin_cache
fi

# Install Composer
if [[ "${PHP_VERSION}" != "5.2" ]]; then
    curl -sSL https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
    echo -n "composer --version : " && composer --version
fi

# Install DbUnit
if [[ "${PHP_VERSION}" =~ ^7\. ]]; then
    curl -sSL https://phar.phpunit.de/dbunit.phar > /usr/local/bin/dbunit && chmod +x /usr/local/bin/dbunit
fi

# Install Phing
if [[ "${PHP_VERSION}" =~ ^(5\.[345]) ]]; then
    curl -sSL http://www.phing.info/get/phing-2.16.0.phar > /usr/local/bin/phing && chmod +x /usr/local/bin/phing
    echo -n "phing -version : " && phing -version
elif [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.6)) ]]; then
    curl -sSL http://www.phing.info/get/phing-latest.phar > /usr/local/bin/phing && chmod +x /usr/local/bin/phing
    echo -n "phing -version : " && phing -version
fi

# Install PHP_CodeSniffer
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[456])) ]]; then
    curl -sSL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar > /usr/local/bin/phpcs && chmod +x /usr/local/bin/phpcs
    echo -n "phpcs --version : " && phpcs --version
    curl -sSL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar > /usr/local/bin/phpcbf && chmod +x /usr/local/bin/phpcbf
    echo -n "phpcbf --version : " && phpcbf --version
fi

# Install PHP Copy/Paste Detector (PHPCPD)
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[6])) ]]; then
    curl -sSL https://phar.phpunit.de/phpcpd.phar > /usr/local/bin/phpcpd && chmod +x /usr/local/bin/phpcpd
    echo -n "phpcpd --version : " && phpcpd --version
fi

# Install PHP_Depend
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[3456])) ]]; then
    curl -sSL http://static.pdepend.org/php/latest/pdepend.phar > /usr/local/bin/pdepend && chmod +x /usr/local/bin/pdepend
    echo -n "pdepend --version : " && pdepend --version
fi

# Install phpDocumentor
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[3456])) ]]; then
    curl -sSL http://phpdoc.org/phpDocumentor.phar > /usr/local/bin/phpdoc && chmod +x /usr/local/bin/phpdoc
    echo -n "phpdoc --version : " && phpdoc --version
fi

# Install PHPLOC
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[6])) ]]; then
    curl -sSL https://phar.phpunit.de/phploc.phar > /usr/local/bin/phploc && chmod +x /usr/local/bin/phploc
    echo -n "phploc --version : " && phploc --version
fi

# Install PHP Mess Detector (PHPMD)
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[3456])) ]]; then
    curl -sSL http://static.phpmd.org/php/latest/phpmd.phar > /usr/local/bin/phpmd && chmod +x /usr/local/bin/phpmd
    echo -n "phpmd --version : " && phpmd --version
fi

# Install PhpMetrics
if [[ "${PHP_VERSION}" =~ ^(5\.[4]) ]]; then
    curl -sSL https://github.com/phpmetrics/PhpMetrics/releases/download/v2.0.0/phpmetrics.phar > /usr/local/bin/phpmetrics && chmod +x /usr/local/bin/phpmetrics
    echo -n "phpmetrics --version : " && phpmetrics --version
elif [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[56])) ]]; then
    curl -sSL https://github.com/phpmetrics/PhpMetrics/releases/download/v2.3.2/phpmetrics.phar > /usr/local/bin/phpmetrics && chmod +x /usr/local/bin/phpmetrics
    echo -n "phpmetrics --version : " && phpmetrics --version
fi

# Install PHPUnit
if [[ "${PHP_VERSION}" =~ ^7\. ]]; then
    curl -sSL https://phar.phpunit.de/phpunit.phar > /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit
    echo -n "phpunit --version : " && phpunit --version
fi
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
    npm install -g bower grunt gulp pm2 webpack
fi

# Configure Apache
a2enmod headers php${PHP_VERSION_APT} rewrite ssl
[[ "${DOCKER_FROM_IMAGE##*:}" =~ lenny|squeeze ]] && a2enmod version
mkdir -p /var/logs/apache
chmod -R 755 /var/logs/apache

# Copy initial configuration files
ls -alhR /etc/php${PHP_VERSION_DIR}
ls -alhR /etc/apache2/sites-available
ls -alhR /etc/nginx
cp /setup/php/apache/conf.d/*docker*.ini /etc/php${PHP_VERSION_DIR}/apache2/conf.d
cp /setup/php/cli/conf.d/*docker*.ini /etc/php${PHP_VERSION_DIR}/cli/conf.d
(cd /etc/apache2/sites-enabled && a2dissite *)
rm /etc/apache2/sites-available/*
cp /setup/apache/*.conf /etc/apache2/sites-available
rm /etc/nginx/nginx.conf*
rm /etc/nginx/sites-enabled/*
cp /setup/nginx/nginx.conf* /etc/nginx
cp /setup/nginx/!(nginx).conf* /etc/nginx/sites-enabled

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