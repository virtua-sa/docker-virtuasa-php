#!/usr/bin/env bash
set -e

echo "Starting the Virtua Docker Container ..."
echo "More info at: <https://hub.docker.com/r/virtuasa/php>"
echo "Built from commit: ${DOCKER_FROM_COMMIT}"
echo

export DOLLAR='$'

# Print ran commands
[[ -n "${DOCKER_DEBUG}" ]] && set -x

# Set working directory
sudo mkdir -p ${DOCKER_BASE_DIR}
cd ${DOCKER_BASE_DIR}

# Exec custom init script
[[ -n "${DOCKER_CUSTOM_INIT}" ]] && [[ -e "${DOCKER_CUSTOM_INIT}" ]] && sudo chmod +x "${DOCKER_CUSTOM_INIT}" \
    && echo "Executing custom init script: ${DOCKER_CUSTOM_INIT} ..." \
    && ./${DOCKER_CUSTOM_INIT}

# Set trap for every signals
trap 'echo -e "\n(last error code: '"'"'$?/${PIPESTATUS[*]}'"'"'; on line: '"'"'${LINENO}/$(caller)'"'"'; with command: '"'"'${BASH_COMMAND}'"'"')";
    PTK="${!}"; [[ -n "${PTK}" ]] && ps -e | grep -q "${PTK}" && kill ${PTK};
    echo "Stopping the Virtua Docker Container ..."; . /setup/run/stop.sh' 0

# Configure /etc/hosts
if [[ -n "${HOSTNAME_LOCAL_ALIAS}" ]]; then
    HOSTNAME_LOCAL_ALIAS_SPACE=`echo "${HOSTNAME_LOCAL_ALIAS}" | tr ',' ' ' | tr ';' ' '`
    if grep -Fxq "${HOSTNAME_LOCAL_ALIAS_SPACE}" /etc/hosts; then
        echo "Host ${HOSTNAME_LOCAL_ALIAS} already resolved to 127.0.0.1"
    else
        sudo mungehosts -l "${HOSTNAME_LOCAL_ALIAS_SPACE}"
        echo "Host ${HOSTNAME_LOCAL_ALIAS} resolved to 127.0.0.1 added"
    fi
fi

# Set timezone
echo "${DOCKER_TIMEZONE}" | sudo tee /etc/timezone > /dev/null
sudo dpkg-reconfigure --frontend noninteractive tzdata
sudo find /etc -name "php.ini" -exec sed -i "s|^;*date.timezone =.*|date.timezone = \"${DOCKER_TIMEZONE}\"|" {} +

# Print installed PHP version
php -v

# set blackfire configuration
if [[ -n "${BLACKFIRE_SERVER_ID}" ]] && [[ -n "${BLACKFIRE_SERVER_TOKEN}" ]] && [[ -n "${BLACKFIRE_CLIENT_ID}" ]] && [[ -n "${BLACKFIRE_CLIENT_TOKEN}" ]]; then
cat <<EOSQL | sudo tee "/home/docker/.blackfire.ini"
[blackfire]
server-id=${BLACKFIRE_SERVER_ID}
server-token=${BLACKFIRE_SERVER_TOKEN}
client-id=${BLACKFIRE_CLIENT_ID}
client-token=${BLACKFIRE_CLIENT_TOKEN}
endpoint=https://blackfire.io/
collector=https://blackfire.io/
EOSQL
fi;

# Get HOST ip address
DOCKER_HOST_IP="${DOCKER_HOST_IP:-$(/sbin/ip route | awk '/default/ { print $3 }')}"
export DOCKER_HOST_IP

# Print all environment variables (can be overriden in docker-compose.yml)
[[ -n "${DOCKER_DEBUG}" ]] && printenv

# Print all shell options
[[ -n "${DOCKER_DEBUG}" ]] && shopt

# Enable some shell options
shopt -s extglob

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
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/php"
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/etc"
    sudo cp "/etc/hosts" "${DOCKER_HOST_SETUP_DIR}/etc"

    sudo cp -nr "/etc/apache2/"* "${DOCKER_HOST_SETUP_DIR}/apache"
    sudo cp -nr "/setup/docker/.gitignore" "${DOCKER_HOST_SETUP_DIR}/docker"
    sudo cp -nr "/etc/nginx/"* "${DOCKER_HOST_SETUP_DIR}/nginx"
    sudo cp -nr "/etc/php${PHP_VERSION_DIR}/"* "${DOCKER_HOST_SETUP_DIR}/php"
    sudo chown -R docker:docker "${DOCKER_HOST_SETUP_DIR}"
fi

# Copy image's configuration files from host filesystem
if [[ "${DOCKER_COPY_CONFIG_FROM_HOST}" = "true" ]]; then
    sudo cp -rf "${DOCKER_HOST_SETUP_DIR}/apache/"* "/etc/apache2" || true
    sudo cp -rf "${DOCKER_HOST_SETUP_DIR}/nginx/"* "/etc/nginx" || true
    sudo cp -rf "${DOCKER_HOST_SETUP_DIR}/php/"* "/etc/php${PHP_VERSION_DIR}/" || true
fi

# Create the requested directories
[[ -n "${DOCKER_MKDIR}" ]] && sudo mkdir -p ${DOCKER_MKDIR}

# Chmod the requested directories
[[ -n "${DOCKER_CHMOD_666}" ]] && sudo chmod 666 ${DOCKER_CHMOD_666}
[[ -n "${DOCKER_CHMOD_777}" ]] && sudo chmod 777 ${DOCKER_CHMOD_777}
[[ -n "${DOCKER_CHMOD_R666}" ]] && sudo chmod -R 666 ${DOCKER_CHMOD_R666}
[[ -n "${DOCKER_CHMOD_R777}" ]] && sudo chmod -R 777 ${DOCKER_CHMOD_R777}

# configure msmtp
file=/etc/msmtp.conf
echo "account default" | sudo tee ${file} > /dev/null
echo "add_missing_from_header on" | sudo tee --append ${file} > /dev/null

if [[ -n "${SMTP_MAILHUB}" ]]; then
  host="$(echo ${SMTP_MAILHUB} | sed -e 's,:.*,,g')"
  port="$(echo ${SMTP_MAILHUB} | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
  [[ -z "$port" ]] && port=25
  echo "host $host" | sudo tee --append ${file} > /dev/null
  echo "port $port" | sudo tee --append ${file} > /dev/null
fi

[[ -n "${SMTP_AUTH_USER}" ]] && echo "user ${SMTP_AUTH_USER}" | sudo tee --append ${file} > /dev/null
[[ -n "${SMTP_AUTH_PASS}" ]] && echo "password ${SMTP_AUTH_PASS}" | sudo tee --append ${file} > /dev/null

[[ -n "${SMTP_SENDER_HOSTNAME}" ]] && echo "domain ${SMTP_SENDER_HOSTNAME}" | sudo tee --append ${file} > /dev/null
[[ -n "${SMTP_SENDER_HOSTNAME}" ]] && echo "maildomain ${SMTP_SENDER_HOSTNAME}" | sudo tee --append ${file} > /dev/null
[[ -n "${SMTP_SENDER_HOSTNAME}" ]] && echo "from docker@${SMTP_SENDER_HOSTNAME}" | sudo tee --append ${file} > /dev/null

echo "sendmail_path = \"msmtp -C ${file}\"" | sudo tee /etc/php${PHP_VERSION_DIR}/cli/conf.d/msmtp.ini
echo "sendmail_path = \"msmtp -C ${file}\"" | sudo tee /etc/php${PHP_VERSION_DIR}/apache2/conf.d/msmtp.ini
echo "sendmail_path = \"msmtp -C ${file}\"" | sudo tee /etc/php${PHP_VERSION_DIR}/fpm/conf.d/msmtp.ini
echo "sendmail_path = \"msmtp -C ${file}\"" | sudo tee /etc/php${PHP_VERSION_DIR}/cgi/conf.d/msmtp.ini


# Configure web server
if [[ "${DOCKER_WEB_SERVER}" = "apache" ]]; then
    # Apache gets grumpy about PID files pre-existing
    sudo rm -f /var/run/apache2/apache2.pid
    sudo rm -f /var/run/apache2/ssl_mutex
    sudo mkdir -p /var/run/apache2
    # Apache log directory
    export APACHE_LOG_DIR="${DOCKER_BASE_DIR}/${APACHE_LOG_PATH}"
    sudo mkdir -p "${DOCKER_BASE_DIR}/${APACHE_LOG_PATH}"
    sudo chmod -R 755 "${DOCKER_BASE_DIR}/${APACHE_LOG_PATH}"
    # Apache root directory
    sudo mkdir -p "${DOCKER_BASE_DIR}/${APACHE_DOCUMENT_ROOT}"
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

# PHP log directory
sudo mkdir -p "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}"
sudo chmod -R 755 "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}"

# Replace system environment variables into PHP configuration files
echo -n "Applying PHP configuration file templates "
find /etc/php${PHP_VERSION_DIR} -regex ".*\.\(conf\|ini\)\.tpl" | while IFS= read -r file; do
    envsubst < ${file} | sudo tee ${file%%.tpl} > /dev/null
    sudo rm ${file}
    [[ -n "${DOCKER_DEBUG}" ]] && cat ${file%%.tpl}
    echo -n "."
done
echo " OK"

# Exec custom startup script
[[ -n "${DOCKER_CUSTOM_START}" ]] && [[ -e "${DOCKER_CUSTOM_START}" ]] && sudo chmod +x "${DOCKER_CUSTOM_START}" \
    && echo "Executing custom start script: ${DOCKER_CUSTOM_START} ..." \
    && ./${DOCKER_CUSTOM_START}

# Display server IP
echo "Started ${DOCKER_WEB_SERVER} web server on ..."
IP="$(hostname -I | cut -d' ' -f1)"
echo "> http://${IP}"
echo "> https://${IP}"
if [[ "${DOCKER_COPY_IP_TO_HOST}" = "true" ]]; then
    sudo mkdir -p "${DOCKER_HOST_SETUP_DIR}/docker"
    sudo cp -nr "/setup/docker/.gitignore" "${DOCKER_HOST_SETUP_DIR}/docker"
    echo "${IP}" | sudo tee "${DOCKER_HOST_SETUP_DIR}/docker/ip" > /dev/null
fi

# Start web server
if [[ "${DOCKER_WEB_SERVER}" = "apache" ]]; then
  sudo sed -i "s|^autostart = .*|autostart = true|" /etc/supervisor/conf.d/apache.conf
elif [[ "${DOCKER_WEB_SERVER}" = "nginx" ]]; then
  sudo sed -i "s|^autostart = .*|autostart = true|" /etc/supervisor/conf.d/nginx.conf
fi

exec sudo sudo supervisord -n -c /etc/supervisor/supervisord.conf