#!/bin/bash
set -e

# Set timezone
echo ${DOCKER_TIMEZONE} | sudo tee /etc/timezone > /dev/null
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Print installed PHP version
php -v

# Print all environment variables (can be overriden in docker-compose.yml)
printenv

# Copy image's configuration files to host filesystem
sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/apache"
sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/docker"
sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/php/apache/conf.d"
sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/php/cli/conf.d"
if [[ "${DOCKER_COPY_CONFIG_TO_HOST}" = "true" ]]; then
    sudo cp -nr "/etc/apache2/sites-available/"*.conf "${DOCKER_HOST_SETUP_DIR}/apache"
    sudo cp -nr "/home/docker/docker/.gitignore" "${DOCKER_HOST_SETUP_DIR}/docker"
    sudo cp -nr "/etc/php${PHP_VERSION_DIR}/apache2/"*.ini "${DOCKER_HOST_SETUP_DIR}/php/apache"
    sudo cp -nr "/etc/php${PHP_VERSION_DIR}/cli/"*.ini "${DOCKER_HOST_SETUP_DIR}/php/cli"
fi

# Copy image's configuration files from host filesystem
if [[ "${DOCKER_COPY_CONFIG_FROM_HOST}" = "true" ]]; then
    sudo cp -r "${DOCKER_HOST_SETUP_DIR}/php/apache/"*.ini "/etc/php${PHP_VERSION_DIR}/apache2"
    sudo cp -r "${DOCKER_HOST_SETUP_DIR}/php/cli/"*.ini "/etc/php${PHP_VERSION_DIR}/cli"
    sudo cp "${DOCKER_HOST_SETUP_DIR}/apache/"*.conf "/etc/apache2/sites-available"
fi

# Configure Apache
(cd /etc/apache2/sites-enabled && sudo a2ensite *)

# Export system environment variables to Apache
echo -e "\n$(printenv | sed "s/'//g" | sed "s/^\([^=]*\)=\(.*\)$/export \1='\2'/g")\n" | sudo tee -a /etc/apache2/envvars > /dev/null

# Run Composer if necessary
if [[ "${PHP_VERSION}" != "5.2" ]]; then
    [[ -e 'composer.json' && ! -e 'vendor/autoload.php' ]] && composer install --no-interaction
fi

# Install npm packages if necessary
[[ -e 'packages.json' && ! -f 'node_modules' ]] && npm install

# Apache gets grumpy about PID files pre-existing
sudo rm -f /var/run/apache2/apache2.pid

# Apache log direcotry
sudo mkdir -p "${DOCKER_BASE_DIR}/${APACHE_LOG_PATH}"
sudo chmod -R 655 "${DOCKER_BASE_DIR}/${APACHE_LOG_PATH}"

# Apache root directory
sudo mkdir -p "${DOCKER_BASE_DIR}/${APACHE_DOCUMENT_ROOT}"

# PHP log direcotry
sudo mkdir -p "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}"
sudo chmod -R 655 "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}"

# Display server IP
echo "Started web server on ..."
IP="$(hostname -I | cut -d' ' -f1)"
echo "> http://${IP}"
echo "> https://${IP}"
echo "${IP}" | sudo tee "${DOCKER_HOST_SETUP_DIR}/docker/ip" > /dev/null

# Start Apache
sudo /usr/sbin/apache2ctl -D FOREGROUND