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
DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

APT_FLAGS="-y --force-yes --fix-missing --no-install-recommends"

apt-get update
apt-get install ${APT_FLAGS} wget curl

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
apt-get update \
    && apt-get upgrade ${APT_FLAGS}  \
    && apt-get dist-upgrade ${APT_FLAGS}  \
    && apt-get install ${APT_FLAGS}  \
        $(<${BASE_PATH}/apt/debian-${DOCKER_FROM_IMAGE##*:})

# Run distribution version hook
if [[ -f "${BASE_PATH}/build.d/debian-${FROM_VERSION}.sh" ]]; then
   ${BASE_PATH}/build.d/debian-${FROM_VERSION}.sh || exit 1
fi

# Use Sury repository, to get PHP 7+ on Debian 9
echo "deb https://packages.sury.org/php/ ${FROM_VERSION} main" > /etc/apt/sources.list.d/php.list
${WGET} https://packages.sury.org/php/apt.gpg | apt-key add -

# Add blackfire repository
wget -q -O - https://packages.blackfire.io/gpg.key | apt-key add -
echo "deb https://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list

# Update APT and list all available PHP packages
apt-get update
apt-cache search php${PHP_VERSION_APT} | grep -v dbgsym | cut -d' ' -f1

# Install development tools
apt-get install ${APT_FLAGS}  \
    $(<${BASE_PATH}/apt/php-${PHP_VERSION})
php -v

# Install blackfire
apt-get install ${APT_FLAGS}  blackfire blackfire-php
# create the socket dir
mkdir /var/run/blackfire
# disable by default
for f in $(find /etc/php/ -iname *blackfire.ini); do
  mv -v $f "${f}.disable"
done

for f in $(find /etc/php/ -iname *blackfire.ini); do
  mv -v $f "${f}.disable"
done

# Run php version hook
if [ -f "${BASE_PATH}/build.d/php-${PHP_VERSION}.sh" ]; then
   ${BASE_PATH}/build.d/php-${PHP_VERSION}.sh
fi

# Install NodeJS and Yarn
curl -sL https://deb.nodesource.com/setup_16.x | bash -
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list

apt-get update
apt-get install ${APT_FLAGS} nodejs yarn
echo -n "Node.js " && node -v
echo -n "NPM v" && npm -v
echo -n "Yarn " && yarn --version

# Print Apache and Nginx versions
/usr/sbin/apache2 -v
/usr/sbin/nginx -v
/usr/sbin/sendmail -V || msmtp --version

# Copy bin files
chmod a+x ${BASE_PATH}/bin/*
cp ${BASE_PATH}/bin/* /usr/local/bin
cp ${BASE_PATH}/bash_completion.d/* /etc/bash_completion.d
# enable bash completion
sed -i -e '/^# enable bash completion/,/^#fi/ {
 s/^#//;
 s/^ enable bash completion/#&/;
}' /etc/bash.bashrc

# mungehosts
${WGET} https://github.com/hiteshjasani/nim-mungehosts/releases/download/v0.1.1/mungehosts > /usr/local/bin/mungehosts && chmod 755 /usr/local/bin/mungehosts

# Install Composer
${WGET} https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
echo -n "composer --version : " && composer --version

# Configure Apache
a2enmod headers php${PHP_VERSION_APT} rewrite ssl
mkdir -p /var/logs/apache
chmod -R 755 /var/logs/apache
mkdir -p /var/run/php

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
cp -vrf /setup/php/* /etc/php${PHP_VERSION_DIR}
(cd /etc/apache2/sites-enabled && a2dissite *)
rm /etc/apache2/sites-available/*
cp -vrf /setup/apache/* /etc/apache2
rm /etc/nginx/nginx.conf*
rm /etc/nginx/sites-available/*
rm /etc/nginx/sites-enabled/*
cp -vrf /setup/nginx/* /etc/nginx
# supervisor config
cp -vrf /setup/docker/debian/supervisor/* /etc/supervisor/conf.d/
find /etc/supervisor/conf.d/ -name "*.tpl" | while IFS= read -r file; do
    envsubst < ${file} | sudo tee ${file%%.tpl} > /dev/null
    rm ${file}
done

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
curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf -
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

# update all packages
apt-get update && apt-get ${APT_FLAGS} dist-upgrade && apt-get ${APT_FLAGS} autoremove

# Clean all unecessary files (doc)
find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true
find /usr/share/doc -empty|xargs rmdir || true
rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/*
rm -rf /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*

# Remove unnecessary files left after installations
apt-get clean -y && apt-get clean -y && apt-get autoclean -y && rm -r /var/lib/apt/lists/*
