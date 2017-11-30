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

# Disable Nginx for lenny and squeeze
[[ "${DOCKER_FROM_IMAGE##*:}" =~ lenny|squeeze ]] && export DOCKER_WEB_SERVER="apache"

# Exec custom init script
[[ -n "${DOCKER_CUSTOM_INIT}" ]] && [[ -e "${DOCKER_CUSTOM_INIT}" ]] && sudo chmod +x "${DOCKER_CUSTOM_INIT}" \
    && echo "Executing custom init script: ${DOCKER_CUSTOM_INIT} ..." \
    && ./${DOCKER_CUSTOM_INIT}

# Set trap for every signals
trap 'echo -e "\n(last error code: '"'"'$?/${PIPESTATUS[*]}'"'"'; on line: '"'"'${LINENO}/$(caller)'"'"'; with command: '"'"'${BASH_COMMAND}'"'"')";
    PTK="${!}"; [[ -n "${PTK}" ]] && ps -e | grep -q "${PTK}" && kill ${PTK};
    echo "Stopping the Virtua Docker Container ..."; . /setup/docker/stop.sh' 0

# Set timezone
echo "${DOCKER_TIMEZONE}" | sudo tee /etc/timezone > /dev/null
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Print installed PHP version
php -v

# Get HOST ip address
DOCKER_HOST_IP="${DOCKER_HOST_IP:-$(/sbin/ip route | awk '/default/ { print $3 }')}"
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

# Copy Apache configuration files
sudo rm -rf /etc/apache2/sites-available/*
sudo cp -r /setup/apache/* /etc/apache2

# Copy Nginx configuration files
sudo rm -rf /etc/nginx/nginx.conf*
sudo rm -rf /etc/nginx/sites-available/*
sudo rm -rf /etc/nginx/sites-enabled/*
sudo cp -r /setup/nginx/* /etc/nginx

# Copy PHP configuration files
sudo cp -r /setup/php/apache/* /etc/php${PHP_VERSION_DIR}/apache2
sudo cp -r /setup/php/cli/* /etc/php${PHP_VERSION_DIR}/cli
sudo cp -r /setup/php/fpm/* /etc/php${PHP_VERSION_DIR}/fpm


# Copy image's configuration files to host filesystem
if [[ "${DOCKER_COPY_CONFIG_TO_HOST}" = "true" ]]; then
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/apache"
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/docker"
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/nginx"
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/php/apache"
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/php/cli"
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/php/fpm"
    if [[ "${DOCKER_FROM_IMAGE##*:}" = "lenny" ]]; then
        sudo cp -r "/etc/apache2/"* "${DOCKER_HOST_SETUP_DIR}/apache"
        sudo cp -r "/setup/docker/.gitignore" "${DOCKER_HOST_SETUP_DIR}/docker"
        sudo cp -r "/etc/nginx/"* "${DOCKER_HOST_SETUP_DIR}/nginx"
        sudo cp -r "/etc/php${PHP_VERSION_DIR}/apache2/"* "${DOCKER_HOST_SETUP_DIR}/php/apache"
        sudo cp -r "/etc/php${PHP_VERSION_DIR}/cli/"* "${DOCKER_HOST_SETUP_DIR}/php/cli"
        sudo cp -r "/etc/php${PHP_VERSION_DIR}/fpm/"* "${DOCKER_HOST_SETUP_DIR}/php/fpm"
    else
        sudo cp -nr "/etc/apache2/"* "${DOCKER_HOST_SETUP_DIR}/apache"
        sudo cp -nr "/setup/docker/.gitignore" "${DOCKER_HOST_SETUP_DIR}/docker"
        sudo cp -nr "/etc/nginx/"* "${DOCKER_HOST_SETUP_DIR}/nginx"
        sudo cp -nr "/etc/php${PHP_VERSION_DIR}/apache2/"* "${DOCKER_HOST_SETUP_DIR}/php/apache"
        sudo cp -nr "/etc/php${PHP_VERSION_DIR}/cli/"* "${DOCKER_HOST_SETUP_DIR}/php/cli"
        sudo cp -nr "/etc/php${PHP_VERSION_DIR}/fpm/"* "${DOCKER_HOST_SETUP_DIR}/php/fpm"
    fi
fi

# Copy image's configuration files from host filesystem
if [[ "${DOCKER_COPY_CONFIG_FROM_HOST}" = "true" ]]; then
    sudo cp -rf "${DOCKER_HOST_SETUP_DIR}/apache/"* "/etc/apache2"
    sudo cp -rf "${DOCKER_HOST_SETUP_DIR}/nginx/"* "/etc/nginx"
    sudo cp -rf "${DOCKER_HOST_SETUP_DIR}/php/apache/"* "/etc/php${PHP_VERSION_DIR}/apache2"
    sudo cp -rf "${DOCKER_HOST_SETUP_DIR}/php/cli/"* "/etc/php${PHP_VERSION_DIR}/cli"
    sudo cp -rf "${DOCKER_HOST_SETUP_DIR}/php/fpm/"* "/etc/php${PHP_VERSION_DIR}/fpm"
fi

# Chown the mount directory
[[ -n "${DOCKER_HOST_UID}" ]] && [[ -n "${DOCKER_HOST_GID}" ]] && sudo chown -R ${DOCKER_HOST_UID}:${DOCKER_HOST_GID} "${DOCKER_BASE_DIR}"

# Chmod the requested directories
[[ -n "${DOCKER_CHMOD_666}" ]] && sudo chmod 666 ${DOCKER_CHMOD_666}
[[ -n "${DOCKER_CHMOD_777}" ]] && sudo chmod 777 ${DOCKER_CHMOD_777}
[[ -n "${DOCKER_CHMOD_R666}" ]] && sudo chmod -R 666 ${DOCKER_CHMOD_R666}
[[ -n "${DOCKER_CHMOD_R777}" ]] && sudo chmod -R 777 ${DOCKER_CHMOD_R777}

# Run Composer if necessary
if [[ "${PHP_VERSION}" != "5.2" ]]; then
    [[ -e 'composer.json' && ! -e 'vendor/autoload.php' ]] && composer install --no-interaction
fi

# Install npm packages if necessary
[[ -e 'packages.json' && ! -f 'node_modules' ]] && npm install

# Configure web server
if [[ "${DOCKER_WEB_SERVER}" = "apache" ]]; then
    # Apache gets grumpy about PID files pre-existing
    sudo rm -f /var/run/apache2/apache2.pid
    sudo rm -f /var/run/apache2/ssl_mutex
    sudo mkdir -p /var/run/apache2
    [[ "${PHP_VERSION}" = "5.4" ]] && sudo chown ${APACHE_RUN_USER} /var/lock/apache2
    # Apache log directory
    export APACHE_LOG_DIR="${DOCKER_BASE_DIR}/${APACHE_LOG_PATH}"
    sudo mkdir -p "${DOCKER_BASE_DIR}/${APACHE_LOG_PATH}"
    sudo chmod -R 755 "${DOCKER_BASE_DIR}/${APACHE_LOG_PATH}"
    # Apache root directory
    sudo mkdir -p "${DOCKER_BASE_DIR}/${APACHE_DOCUMENT_ROOT}"
    export DOLLAR='$'
    # Disable previous Apache sites
    (cd /etc/apache2/sites-enabled && find -mindepth 1 -print -quit | grep -q . && sudo a2dissite * || true)
    # Replace system environment variables into Apache configuration files
    echo -n "Applying Apache configuration file templates "
    find /etc/apache2 -name "*.conf.tpl" | while IFS= read -r file; do
        envsubst < ${file} | sudo tee ${file%%.tpl} > /dev/null
        sudo rm ${file}
        [[ -n "${DOCKER_DEBUG}" ]] && cat ${file%%.tpl}
        echo -n "."
    done
    echo " OK"
    # Configure Apache
    (cd /etc/apache2/sites-enabled && sudo a2ensite *)
    echo -e "\nexport APACHE_RUN_USER='${APACHE_RUN_USER}'\n" | sudo tee -a /etc/apache2/envvars > /dev/null
    echo -e "\nexport APACHE_RUN_GROUP='${APACHE_RUN_GROUP}'\n" | sudo tee -a /etc/apache2/envvars > /dev/null
    echo -e "\nexport APACHE_LOG_DIR='${APACHE_LOG_DIR}'\n" | sudo tee -a /etc/apache2/envvars > /dev/null
elif [[ "${DOCKER_WEB_SERVER}" = "nginx" ]]; then
    # Nginx log directory
    sudo mkdir -p "${DOCKER_BASE_DIR}/${NGINX_LOG_PATH}"
    sudo chmod -R 755 "${DOCKER_BASE_DIR}/${NGINX_LOG_PATH}"
    # Replace system environment variables into Nginx configuration files
    echo -n "Applying Nginx configuration file templates "
    find /etc/nginx -name "*.conf.tpl" | while IFS= read -r file; do
        envsubst < ${file} | sudo tee ${file%%.tpl} > /dev/null
        sudo rm ${file}
        [[ -n "${DOCKER_DEBUG}" ]] && cat ${file%%.tpl}
        echo -n "."
    done
    echo " OK"
fi

# PHP log direcotry
sudo mkdir -p "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}"
sudo chmod -R 755 "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}"

# Replace system environment variables into PHP configuration files
echo -n "Applying PHP configuration file templates "
find /etc/php${PHP_VERSION_DIR} -name "*.ini.tpl" | while IFS= read -r file; do
    envsubst < ${file} | sudo tee ${file%%.tpl} > /dev/null
    sudo rm ${file}
    [[ -n "${DOCKER_DEBUG}" ]] && cat ${file%%.tpl}
    echo -n "."
done
echo " OK"

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
    sudo nginx
fi