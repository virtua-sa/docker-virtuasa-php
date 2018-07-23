#!/usr/bin/env bash
set -xe

# Print Debian version
uname -a
echo -n "Debian version: " && cat /etc/debian_version

# Print all environment variables
printenv

# Print all shell options
shopt

# Enable some shell options
shopt -s extglob

export DEBCONF_FRONTEND='noninteractive'
WGET="curl -sSL"
BASE_PATH="/setup/docker/${FROM_DISTRIBUTION}"
# Check if Debian version is already configured
[[ ! -e "${BASE_PATH}/apt/debian-${DOCKER_FROM_IMAGE##*:}" ]] \
    && echo "Debian version not supported yet, file ${BASE_PATH}/apt/debian-${DOCKER_FROM_IMAGE##*:} doesn't exist !" \
    && exit 1;

# Check if PHP version is already configured
[[ ! -e "${BASE_PATH}/apt/php-${PHP_VERSION}" ]] \
    && echo "PHP version not supported yet, file ${BASE_PATH}/apt/php-${PHP_VERSION} doesn't exist !" \
    && exit 1;

# Install base packages
DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --force-yes --fix-missing --no-install-recommends \
    && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y --force-yes --fix-missing --no-install-recommends \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --fix-missing --no-install-recommends \
        $(<${BASE_PATH}/apt/debian-${DOCKER_FROM_IMAGE##*:})

# Run distribution version hook
if [ -f "${BASE_PATH}/build.d/debian-${FROM_VERSION}.sh" ]; then
   ${BASE_PATH}/build.d/debian-${FROM_VERSION}.sh || exit 1
fi

# Use Sury repository, to get PHP 7+ on Debian 9
if [[ "${PHP_VERSION}" =~ ^7\. ]]; then
    echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list
    ${WGET} https://packages.sury.org/php/apt.gpg | apt-key add -
fi

# Use Dotdeb repository, to get PHP 5.5 on Debian 7
if [[ "${PHP_VERSION}" = "5.5" ]]; then
    echo "deb http://packages.dotdeb.org wheezy-php55 all" > /etc/apt/sources.list.d/dotdeb.list
    ${WGET} https://www.dotdeb.org/dotdeb.gpg | apt-key add -
fi

# Use Yarnpkg repository, to get Yarn on Debian
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ wheezy|jessie|stretch ]]; then
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
    ${WGET} https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
fi

# Use Nodesource, to get Node.js on Debian
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ wheezy ]]; then
    ${WGET} https://deb.nodesource.com/setup_6.x | bash -
fi
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ jessie|stretch ]]; then
    ${WGET} https://deb.nodesource.com/setup_8.x | bash -
fi

if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[56])) ]]; then
    # Use Tideways pre-compiled packages
    echo "deb http://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages debian main" > /etc/apt/sources.list.d/tideways.list
    ${WGET} https://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages/EEB5E8F4.gpg | apt-key add -
fi

# Update APT and list all available PHP packages
apt-get update
apt-cache search php${PHP_VERSION_APT} | grep -v dbgsym | cut -d' ' -f1

# Install development tools
DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --fix-missing --no-install-recommends \
    $(<${BASE_PATH}/apt/php-${PHP_VERSION})
php -v

# Run php version hook
if [ -f "${BASE_PATH}/build.d/php-${PHP_VERSION}.sh" ]; then
   ${BASE_PATH}/build.d/php-${PHP_VERSION}.sh
fi

# Install NodeJS and Yarn
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ wheezy|jessie|stretch ]]; then
    DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --fix-missing --no-install-recommends \
        nodejs \
        yarn
    echo -n "Node.js " && node -v && echo -n "NPM v" && npm -v
fi
##Install Ruby and Capistrano BUG on capistrano install
#if [[ "${DOCKER_FROM_IMAGE##*:}" =~ jessie|stretch ]]; then
#    apt-get install -y --force-yes --fix-missing --no-install-recommends \
#        ruby-full
#    ruby -v && echo -n "gem v" && gem -v
#    gem install capistrano
#    cap -v
#fi

# Print Apache and Nginx versions
/usr/sbin/apache2 -v
/usr/sbin/nginx -v
/usr/sbin/sendmail -V

# mungehosts
${WGET} https://github.com/hiteshjasani/nim-mungehosts/releases/download/v0.1.1/mungehosts > /usr/local/bin/mungehosts && chmod 755 /usr/local/bin/mungehosts

# Install Behat
if [[ "${PHP_VERSION}" =~ ^(5\.[5]) ]]; then
    ${WGET} https://github.com/Behat/Behat/releases/download/v3.3.0/behat.phar > /usr/local/bin/behat && chmod a+x /usr/local/bin/behat
    echo -n "behat --version : " && behat --version
    rm -rf /tmp/behat_gherkin_cache
elif [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.6)) ]]; then
    ${WGET} https://github.com/Behat/Behat/releases/download/v3.3.0/behat.phar > /usr/local/bin/behat && chmod a+x /usr/local/bin/behat
    echo -n "behat --version : " && behat --version
    rm -rf /tmp/behat_gherkin_cache
fi

# Install Composer
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[3456])) ]]; then
    ${WGET} https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
    echo -n "composer --version : " && composer --version
fi

# Install DbUnit
if [[ "${PHP_VERSION}" =~ ^7\. ]]; then
    ${WGET} https://phar.phpunit.de/dbunit.phar > /usr/local/bin/dbunit && chmod a+x /usr/local/bin/dbunit
fi

# Install Phing
if [[ "${PHP_VERSION}" =~ ^(5\.[345]) ]]; then
    ${WGET} https://www.phing.info/get/phing-2.16.0.phar > /usr/local/bin/phing && chmod a+x /usr/local/bin/phing
    echo -n "phing -version : " && phing -version
elif [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.6)) ]]; then
    ${WGET} https://www.phing.info/get/phing-latest.phar > /usr/local/bin/phing && chmod a+x /usr/local/bin/phing
    echo -n "phing -version : " && phing -version
fi

# Install PHP_CodeSniffer
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[456])) ]]; then
    ${WGET} https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar > /usr/local/bin/phpcs && chmod a+x /usr/local/bin/phpcs
    echo -n "phpcs --version : " && phpcs --version
    ${WGET} https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar > /usr/local/bin/phpcbf && chmod a+x /usr/local/bin/phpcbf
    echo -n "phpcbf --version : " && phpcbf --version
fi

# Install PHP Copy/Paste Detector (PHPCPD)
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[3456])) ]]; then
    ${WGET} https://github.com/sebastianbergmann/phpcpd/releases/download/2.0.0/phpcpd.phar > /usr/local/bin/phpcpd && chmod a+x /usr/local/bin/phpcpd
    echo -n "phpcpd --version : " && phpcpd --version
fi

# Install PHP_Depend
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[3456])) ]]; then
    ${WGET} http://static.pdepend.org/php/latest/pdepend.phar > /usr/local/bin/pdepend && chmod a+x /usr/local/bin/pdepend
    echo -n "pdepend --version : " && pdepend --version
fi

# Install phpDocumentor
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[456])) ]]; then
    ${WGET} http://phpdoc.org/phpDocumentor.phar > /usr/local/bin/phpdoc && chmod a+x /usr/local/bin/phpdoc
    echo -n "phpdoc --version : " && phpdoc --version
fi

# Install phpdox
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[56])) ]]; then
    ${WGET} http://phpdox.de/releases/phpdox.phar > /usr/local/bin/phpdox && chmod a+x /usr/local/bin/phpdox
    echo -n "phpdox --version : " && phpdox --version
fi
if [[ "${PHP_VERSION}" =~ ^5\.4 ]]; then
    ${WGET} https://github.com/theseer/phpdox/releases/download/0.9.0/phpdox-0.9.0.phar > /usr/local/bin/phpdox && chmod a+x /usr/local/bin/phpdox
    echo -n "phpdox --version : " && phpdox --version
fi
if [[ "${PHP_VERSION}" =~ ^5\.3 ]]; then
    ${WGET} https://github.com/theseer/phpdox/releases/download/0.8.1.1/phpdox-0.8.1.1.phar > /usr/local/bin/phpdox && chmod a+x /usr/local/bin/phpdox
    echo -n "phpdox --version : " && phpdox --version
fi

# Install PHPLOC
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[6])) ]]; then
    ${WGET} https://phar.phpunit.de/phploc.phar > /usr/local/bin/phploc && chmod a+x /usr/local/bin/phploc
    echo -n "phploc --version : " && phploc --version
fi

# Install PHP Mess Detector (PHPMD)
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[3456])) ]]; then
    ${WGET} http://static.phpmd.org/php/latest/phpmd.phar > /usr/local/bin/phpmd && chmod a+x /usr/local/bin/phpmd
    echo -n "phpmd --version : " && phpmd --version
fi

# Install PhpMetrics
if [[ "${PHP_VERSION}" =~ ^(5\.[4]) ]]; then
    ${WGET} https://github.com/phpmetrics/PhpMetrics/releases/download/v2.0.0/phpmetrics.phar > /usr/local/bin/phpmetrics && chmod a+x /usr/local/bin/phpmetrics
    echo -n "phpmetrics --version : " && phpmetrics --version
elif [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[56])) ]]; then
    ${WGET} https://github.com/phpmetrics/PhpMetrics/releases/download/v2.3.2/phpmetrics.phar > /usr/local/bin/phpmetrics && chmod a+x /usr/local/bin/phpmetrics
    echo -n "phpmetrics --version : " && phpmetrics --version
fi

# Install PHPUnit
if [[ "${PHP_VERSION}" =~ ^7\.[123456] ]]; then
    ${WGET} https://phar.phpunit.de/phpunit.phar > /usr/local/bin/phpunit && chmod a+x /usr/local/bin/phpunit
    echo -n "phpunit --version : " && phpunit --version
fi
if [[ "${PHP_VERSION}" =~ ^7\. ]]; then
    ${WGET} https://phar.phpunit.de/phpunit-6.2.phar > /usr/local/bin/phpunit62 && chmod a+x /usr/local/bin/phpunit62
    echo -n "phpunit62 --version : " && phpunit62 --version
fi
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.6)) ]]; then
    ${WGET} https://phar.phpunit.de/phpunit-5.7.phar > /usr/local/bin/phpunit57 && chmod a+x /usr/local/bin/phpunit57
    echo -n "phpunit57 --version : " && phpunit57 --version
fi
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[3456])) ]]; then
    ${WGET} https://phar.phpunit.de/phpunit-4.8.phar > /usr/local/bin/phpunit48 && chmod a+x /usr/local/bin/phpunit48
    echo -n "phpunit48 --version : " && phpunit48 --version
fi

# Install XHGUI
if [[ "${PHP_VERSION}" =~ ^((7\.)|(5\.[56])) ]]; then
    rm -Rf "${XHGUI_BASE_DIR}"
    git clone https://github.com/perftools/xhgui.git "${XHGUI_BASE_DIR}" --branch 0.9.0
    chmod -R 755 "${XHGUI_BASE_DIR}"
    chmod -R 777 "${XHGUI_BASE_DIR}/cache"
    if [[ "${PHP_VERSION}" =~ ^(7\.) ]]; then
        composer require -d "${XHGUI_BASE_DIR}" mongodb/mongodb:1.2
    else
        composer install -d "${XHGUI_BASE_DIR}" --ignore-platform-reqs
    fi
fi

# Install common Node.js tools
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ wheezy|jessie|stretch ]]; then
# BUG on gulp install
#    npm install -g bower grunt gulp pm2 webpack
    npm install -g bower grunt pm2 webpack
fi

# Configure Apache
a2enmod headers php${PHP_VERSION_APT} rewrite ssl
[[ "${DOCKER_FROM_IMAGE##*:}" =~ lenny|squeeze ]] && a2enmod version
mkdir -p /var/logs/apache
chmod -R 755 /var/logs/apache

# Apply distribution-specific configuration files
# For files matching the pattern /setup/**/*.conf-<debian-version>*
find /setup -name "*.conf-${DOCKER_FROM_IMAGE##*:}*" | while IFS= read -r file; do
    cp -vf "${file}" "${file%%.conf-*}.conf${file##*.conf-${DOCKER_FROM_IMAGE##*:}}"
done
# For files matching the pattern /setup/**/*.ini-<debian-version>*
find /setup -name "*.ini-${DOCKER_FROM_IMAGE##*:}*" | while IFS= read -r file; do
    cp -vf "${file}" "${file%%.ini-*}.ini${file##*.ini-${DOCKER_FROM_IMAGE##*:}}"
done
# For files matching the pattern /setup/**/*.conf-<php-version>*
find /setup -name "*.conf-${PHP_VERSION}*" | while IFS= read -r file; do
    cp -vf "${file}" "${file%%.conf-*}.conf${file##*.conf-${PHP_VERSION}}"
done
# For files matching the pattern /setup/**/*.ini-<php-version>*
find /setup -name "*.ini-${PHP_VERSION}*" | while IFS= read -r file; do
    cp -vf "${file}" "${file%%.ini-*}.ini${file##*.ini-${PHP_VERSION}}"
done
# Remove non-applicable configuration files
find /setup -name "*.conf-*" -exec rm {} \;
find /setup -name "*.ini-*" -exec rm {} \;

# Copy initial configuration files
ls -alhR /etc/php${PHP_VERSION_DIR}
ls -alhR /etc/apache2
ls -alhR /etc/nginx
if [[ "${PHP_VERSION}" =~ ^(5\.[234]) ]]; then
    [[ -L "/etc/php${PHP_VERSION_DIR}/apache2/conf.d" ]] && rm /etc/php${PHP_VERSION_DIR}/apache2/conf.d
    [[ -L "/etc/php${PHP_VERSION_DIR}/cli/conf.d" ]] && rm /etc/php${PHP_VERSION_DIR}/cli/conf.d
    [[ -L "/etc/php${PHP_VERSION_DIR}/fpm/conf.d" ]] && rm /etc/php${PHP_VERSION_DIR}/fpm/conf.d
    mkdir -p /etc/php${PHP_VERSION_DIR}/apache2/conf.d
    mkdir -p /etc/php${PHP_VERSION_DIR}/cli/conf.d
    mkdir -p /etc/php${PHP_VERSION_DIR}/fpm/conf.d
    cp -vrf /etc/php${PHP_VERSION_DIR}/conf.d/* /etc/php${PHP_VERSION_DIR}/apache2/conf.d
    cp -vrf /etc/php${PHP_VERSION_DIR}/conf.d/* /etc/php${PHP_VERSION_DIR}/cli/conf.d
    cp -vrf /etc/php${PHP_VERSION_DIR}/conf.d/* /etc/php${PHP_VERSION_DIR}/fpm/conf.d
    if [ -d "/etc/php${PHP_VERSION_DIR}/mods-available/" ]; then
        # override symlinks
        cp /etc/php${PHP_VERSION_DIR}/conf.d/*.ini /etc/php${PHP_VERSION_DIR}/mods-available
        ln -sf /etc/php${PHP_VERSION_DIR}/mods-available /etc/php${PHP_VERSION_DIR}/apache2/mods-available
        ln -sf /etc/php${PHP_VERSION_DIR}/mods-available /etc/php${PHP_VERSION_DIR}/cli/mods-available
        ln -sf /etc/php${PHP_VERSION_DIR}/mods-available /etc/php${PHP_VERSION_DIR}/fpm/mods-available
    fi
fi
cp -vrf /setup/php/apache/* /etc/php${PHP_VERSION_DIR}/apache2
cp -vrf /setup/php/cli/* /etc/php${PHP_VERSION_DIR}/cli
cp -vrf /setup/php/fpm/* /etc/php${PHP_VERSION_DIR}/fpm
(cd /etc/apache2/sites-enabled && a2dissite *)
rm /etc/apache2/sites-available/*
cp -vrf /setup/apache/* /etc/apache2
rm /etc/nginx/nginx.conf*
rm /etc/nginx/sites-available/*
rm /etc/nginx/sites-enabled/*
cp -vrf /setup/nginx/* /etc/nginx

# Default timezone
sudo find /etc -name "php.ini" -exec sed -i "s|^;*date.timezone =.*|date.timezone = \"${DOCKER_TIMEZONE}\"|" {} +

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

# Remove unnecessary files left after installations
apt-get clean -y && apt-get clean -y && apt-get autoclean -y && rm -r /var/lib/apt/lists/*
