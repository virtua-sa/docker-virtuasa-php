#!/bin/bash
set -e

echo "Starting the Virtua Docker Container ..."
echo "More info at: <https://hub.docker.com/r/virtuasa/php/>"
echo "Built from commit: ${DOCKER_FROM_COMMIT}"
echo

# Print ran commands
[[ -n "${DOCKER_DEBUG}" ]] && set -x

# Set working directory
sudo mkdir -p ${DOCKER_BASE_DIR}
cd ${DOCKER_BASE_DIR}

# Exec custom init script
[[ -n "${DOCKER_CUSTOM_INIT}" ]] && [[ -e "${DOCKER_CUSTOM_INIT}" ]] && sudo chmod +x "${DOCKER_CUSTOM_INIT}" \
    && echo "Executing custom init script: ${DOCKER_CUSTOM_INIT} ..." \
    && ./${DOCKER_CUSTOM_INIT}

# Set SIGTERM trap
trap 'kill ${!}; . /setup/docker/stop.sh' SIGTERM

# Set timezone
echo "${DOCKER_TIMEZONE}" | sudo tee /etc/timezone > /dev/null
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Print installed PHP version
php -v

# Get HOST ip address
DOCKER_HOST_IP="${DOCKER_HOST_IP:-$(/sbin/ip route|awk '/default/ { print $3 }')}"
export DOCKER_HOST_IP

# Print all environment variables (can be overriden in docker-compose.yml)
[[ -n "${DOCKER_DEBUG}" ]] && printenv

# Print all shell options
[[ -n "${DOCKER_DEBUG}" ]] && shopt

# Enable some shell options
shopt -s extglob

# Force the UID/GID of the docker container running user
[[ -n "${DOCKER_USER_UID}" ]] && usermod -u ${DOCKER_USER_UID} docker
[[ -n "${DOCKER_USER_GID}" ]] && groupmod -u ${DOCKER_USER_GID} docker && usermod -g ${DOCKER_USER_GID} docker

# Copy Nginx configuration files
sudo rm /etc/nginx/nginx.conf*
sudo rm /etc/nginx/sites-enabled/*
sudo cp /setup/nginx/nginx.conf* /etc/nginx
sudo cp /setup/nginx/!(nginx).conf* /etc/nginx/sites-enabled

# Copy image's configuration files to host filesystem
if [[ "${DOCKER_COPY_CONFIG_TO_HOST}" = "true" ]]; then
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/apache"
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/docker"
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/nginx"
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/php/apache/conf.d"
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/php/cli/conf.d"
    sudo cp -nr "/etc/apache2/sites-available/"*.conf "${DOCKER_HOST_SETUP_DIR}/apache"
    sudo cp -nr "/setup/docker/.gitignore" "${DOCKER_HOST_SETUP_DIR}/docker"
    sudo cp -nr "/etc/nginx/nginx.conf" "${DOCKER_HOST_SETUP_DIR}/docker/nginx"
    sudo cp -nr "/etc/nginx/sites-enabled"*.conf "${DOCKER_HOST_SETUP_DIR}/docker/nginx"
    sudo cp -nr "/etc/php${PHP_VERSION_DIR}/apache2/"*.ini "${DOCKER_HOST_SETUP_DIR}/php/apache"
    sudo cp -nr "/etc/php${PHP_VERSION_DIR}/cli/"*.ini "${DOCKER_HOST_SETUP_DIR}/php/cli"
fi

# Copy image's configuration files from host filesystem
if [[ "${DOCKER_COPY_CONFIG_FROM_HOST}" = "true" ]]; then
    sudo cp "${DOCKER_HOST_SETUP_DIR}/apache/"*.conf "/etc/apache2/sites-available"
    sudo cp "${DOCKER_HOST_SETUP_DIR}/nginx/nginx.conf" "/etc/nginx"
    sudo cp "${DOCKER_HOST_SETUP_DIR}/nginx/"!(nginx).conf "/etc/nginx/sites-enabled"
    sudo cp -r "${DOCKER_HOST_SETUP_DIR}/php/apache/"*.ini "/etc/php${PHP_VERSION_DIR}/apache2"
    sudo cp -r "${DOCKER_HOST_SETUP_DIR}/php/cli/"*.ini "/etc/php${PHP_VERSION_DIR}/cli"
fi

# Chown the mount directory
[[ -n "${DOCKER_HOST_UID}" ]] && [[ -n "${DOCKER_HOST_GID}" ]] && sudo chown -R ${DOCKER_HOST_UID}:${DOCKER_HOST_GID} "${DOCKER_BASE_DIR}"

# Chmod the requested directories
[[ -n "${DOCKER_CHMOD_666}" ]] && sudo chmod 666 ${DOCKER_CHMOD_666}
[[ -n "${DOCKER_CHMOD_777}" ]] && sudo chmod 777 ${DOCKER_CHMOD_777}
[[ -n "${DOCKER_CHMOD_R666}" ]] && sudo chmod -R 666 ${DOCKER_CHMOD_R666}
[[ -n "${DOCKER_CHMOD_R777}" ]] && sudo chmod -R 777 ${DOCKER_CHMOD_R777}

# Configure Apache
(cd /etc/apache2/sites-enabled && sudo a2ensite *)

# Export system environment variables to Apache
echo -e "\n$(printenv | sed "s/'//g" | sed "s/^\([^=]*\)=\(.*\)$/export \1='\2'/g")\n" | sudo tee -a /etc/apache2/envvars > /dev/null

# Replace system environment variables into Nginx configuration files
export DOLLAR='$'
for file in /etc/nginx/*.conf.tpl; do
    sudo envsubst < ${file} | sudo tee ${file%%.tpl} > /dev/null
done
for file in /etc/nginx/sites-enabled/*.conf.tpl; do
    sudo envsubst < ${file} | sudo tee ${file%%.tpl} > /dev/null
done

# Run Composer if necessary
if [[ "${PHP_VERSION}" != "5.2" ]]; then
    [[ -e 'composer.json' && ! -e 'vendor/autoload.php' ]] && composer install --no-interaction
fi

# Install npm packages if necessary
[[ -e 'packages.json' && ! -f 'node_modules' ]] && npm install

# Apache gets grumpy about PID files pre-existing
sudo rm -f /var/run/apache2/apache2.pid
sudo rm -f /var/run/apache2/ssl_mutex
sudo mkdir -p /var/run/apache2
[[ "${PHP_VERSION}" = "5.4" ]] && sudo chown ${APACHE_RUN_USER} /var/lock/apache2

# Apache log directory
sudo mkdir -p "${DOCKER_BASE_DIR}/${APACHE_LOG_PATH}"
sudo chmod -R 755 "${DOCKER_BASE_DIR}/${APACHE_LOG_PATH}"

# Apache root directory
sudo mkdir -p "${DOCKER_BASE_DIR}/${APACHE_DOCUMENT_ROOT}"

# PHP log direcotry
sudo mkdir -p "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}"
sudo chmod -R 755 "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}"

# Clean Behat cache directory
sudo rm -rf /tmp/behat_gherkin_cache

# Exec custom startup script
[[ -n "${DOCKER_CUSTOM_START}" ]] && [[ -e "${DOCKER_CUSTOM_START}" ]] && sudo chmod +x "${DOCKER_CUSTOM_START}" \
    && echo "Executing custom start script: ${DOCKER_CUSTOM_START} ..." \
    && ./${DOCKER_CUSTOM_START}

# Display server IP
echo "Started ${DOCKER_WEB_SERVER} web server on ..."
[[ "${DOCKER_FROM_IMAGE##*:}" = "lenny" ]] \
    && IP="$(ifconfig | awk '/inet addr/{print substr($2,6)}' | head -n 3 | tail -n 1)" \
    || IP="$(hostname -I | cut -d' ' -f1)"
echo "> http://${IP}"
echo "> https://${IP}"
if [[ "${DOCKER_COPY_IP_TO_HOST}" = "true" ]]; then
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/docker"
    sudo cp -nr "/setup/docker/.gitignore" "${DOCKER_HOST_SETUP_DIR}/docker"
    echo "${IP}" | sudo tee "${DOCKER_HOST_SETUP_DIR}/docker/ip" > /dev/null
fi

# Chown the mount dir after Apache has started
(sleep 5s; [[ -n "${DOCKER_HOST_UID}" ]] && [[ -n "${DOCKER_HOST_GID}" ]] && sudo chown -R ${DOCKER_HOST_UID}:${DOCKER_HOST_GID} "${DOCKER_BASE_DIR}") &

# Start web server
if [[ "${DOCKER_WEB_SERVER}" = "apache" ]]; then
    [[ "${DOCKER_FROM_IMAGE##*:}" = "lenny" ]] \
        && sudo /usr/sbin/apache2ctl -DFOREGROUND \
        || sudo /usr/sbin/apache2ctl -D FOREGROUND
elif [[ "${DOCKER_WEB_SERVER}" = "nginx" ]]; then
    sudo nginx -g "daemon off;"
fi