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

# Run distribution version hook
if [[ -f "${BASE_PATH}/build.d/debian-${FROM_VERSION}-repository.sh" ]]; then
   ${BASE_PATH}/build.d/debian-${FROM_VERSION}-repository.sh || exit 1
fi

# Install base packages
DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --force-yes --fix-missing --no-install-recommends \
    && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y --force-yes --fix-missing --no-install-recommends \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --fix-missing --no-install-recommends \
        $(<${BASE_PATH}/apt/debian-${DOCKER_FROM_IMAGE##*:})

# Run distribution version hook
if [[ -f "${BASE_PATH}/build.d/debian-${FROM_VERSION}.sh" ]]; then
   ${BASE_PATH}/build.d/debian-${FROM_VERSION}.sh || exit 1
fi

# Use Sury repository, to get PHP 7+ on Debian 9
if [[ "${PHP_VERSION}" =~ ^(7|8)\. ]]; then
    echo "deb https://packages.sury.org/php/ ${FROM_VERSION} main" > /etc/apt/sources.list.d/php.list
    ${WGET} https://packages.sury.org/php/apt.gpg | apt-key add -
fi

# Use Dotdeb repository, to get PHP 5.5 on Debian 7
if [[ "${PHP_VERSION}" = "5.5" ]]; then
    echo "deb http://packages.dotdeb.org wheezy-php55 all" > /etc/apt/sources.list.d/dotdeb.list
    ${WGET} https://www.dotdeb.org/dotdeb.gpg | apt-key add -
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

#Install Ruby and Capistrano BUG on capistrano install
if [[ "${DOCKER_FROM_IMAGE##*:}" =~ jessie|stretch ]]; then
    DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --fix-missing --no-install-recommends ruby
    if [[ "${DOCKER_FROM_IMAGE##*:}" =~ jessie ]]; then
        # in case of jessie upgrade ruby to 2.3.3
        wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
        tar -xzvf ruby-install-0.7.0.tar.gz
        cd ruby-install-0.7.0
        sudo make install
        sudo ruby-install --system ruby 2.3.3
        cd ..
        rm -rf ruby-install-0.7.0
        hash -r
    fi
    ruby -v && echo -n "gem v" && gem -v
    gem install bundler
    bundler install --gemfile=/setup/docker/debian/capistrano/Gemfile
    cap -v
fi

# Print Apache and Nginx versions
/usr/sbin/apache2 -v
/usr/sbin/nginx -v
/usr/sbin/sendmail -V || msmtp --version

# Copy bin files
chmod a+x ${BASE_PATH}/bin/*
cp ${BASE_PATH}/bin/* /usr/local/bin
cp ${BASE_PATH}/bash_completion.d/* /etc/bash_completion.d

# mungehosts
${WGET} https://github.com/hiteshjasani/nim-mungehosts/releases/download/v0.1.1/mungehosts > /usr/local/bin/mungehosts && chmod 755 /usr/local/bin/mungehosts

# Install Composer
if [[ "${PHP_VERSION}" =~ ^(5\.[345]) ]]; then
    ${WGET} https://getcomposer.org/installer | php -- --disable-tls && mv composer.phar /usr/local/bin/composer
    echo -n "composer --version : " && composer --version
    # git config --global --unset http.sslVersion || echo "http.sslVersion not set"
    # git config --global --add http.sslVersion tlsv1.2
else
    ${WGET} https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
    echo -n "composer --version : " && composer --version
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
# DEV Enable support of FIXUID
USER=docker
GROUP=docker
groupadd -g 1000 ${GROUP}
useradd -u 1000 -g ${GROUP} -g sudo -d /home/${USER} -s /bin/sh ${USER} && \
curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf -
chown root:root /usr/local/bin/fixuid
chmod 4755 /usr/local/bin/fixuid
mkdir -p /etc/fixuid
printf "user: ${USER}\ngroup: ${GROUP}\npaths:\n  - /home\n" > /etc/fixuid/config.yml
mkdir -p /home/${USER}
chown ${USER}:${GROUP} /home/${USER}

if [[ "${DOCKER_FROM_IMAGE##*:}" = "lenny" ]]; then
    echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
else
    echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/docker
    chmod 440 /etc/sudoers.d/docker
fi
adduser ${USER} www-data

# Clean all unecessary files (doc)
find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true
find /usr/share/doc -empty|xargs rmdir || true
rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/*
rm -rf /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*

# Remove unnecessary files left after installations
apt-get clean -y && apt-get clean -y && apt-get autoclean -y && rm -r /var/lib/apt/lists/*
