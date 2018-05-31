ARG FROM_IMAGE="debian:stretch"
FROM ${FROM_IMAGE}

# Retrieve build arguments
ARG FROM_IMAGE="debian:stretch"
ARG FROM_DISTRIBUTION="debian"
ARG FROM_VERSION="stretch"
ARG DOCKER_BUILD_DATE=""
ARG DOCKER_FROM_COMMIT=""
ARG PHP_VERSION="7.1"
ARG PHP_VERSION_APT="7.1"
ARG PHP_VERSION_DIR="/7.1"

# Set metadata labels, see: http://label-schema.org/rc1/
LABEL org.label-schema.build-date="${DOCKER_BUILD_DATE}" \
      org.label-schema.name="Virtua Docker Image - PHP" \
      org.label-schema.description="PHP web development docker images used by Virtua SA." \
      org.label-schema.url="https://hub.docker.com/r/virtuasa/php/" \
      org.label-schema.vcs-ref="${DOCKER_FROM_COMMIT}" \
      org.label-schema.vcs-url="https://github.com/virtua-sa/docker-virtuasa-php" \
      org.label-schema.vendor="Virtua SA" \
      org.label-schema.schema-version="1.0"

# Set default environment variables
ENV LANG=C.UTF-8 \
    APACHE_DOCUMENT_ROOT="web" \
    APACHE_LOG_PATH="var/logs/apache" \
    APACHE_RUN_GROUP="docker" \
    APACHE_RUN_USER="docker" \
    APACHE_SERVER_ADMIN="webmaster@localhost" \
    APACHE_SERVER_NAME="localhost" \
    APACHE_SSL_CERT_KEY="/etc/ssl/private/ssl-cert-snakeoil.key" \
    APACHE_SSL_CERT_PEM="/etc/ssl/certs/ssl-cert-snakeoil.pem" \
    DOCKER_BASE_DIR="/data" \
    DOCKER_BUILD_DATE="${DOCKER_BUILD_DATE}" \
    DOCKER_CHMOD_666="" \
    DOCKER_CHMOD_777="" \
    DOCKER_CHMOD_R666="" \
    DOCKER_CHMOD_R777="" \
    DOCKER_COPY_CONFIG_FROM_HOST="false" \
    DOCKER_COPY_CONFIG_TO_HOST="false" \
    DOCKER_COPY_IP_TO_HOST="false" \
    DOCKER_CUSTOM_INIT="docker-init.sh" \
    DOCKER_CUSTOM_START="docker-start.sh" \
    DOCKER_CUSTOM_STOP="docker-stop.sh" \
    DOCKER_DEBUG="" \
    DOCKER_FROM_COMMIT="${DOCKER_FROM_COMMIT}" \
    DOCKER_FROM_IMAGE="${FROM_IMAGE}" \
    DOCKER_HOST_GID="" \
    DOCKER_HOST_SETUP_DIR="setup" \
    DOCKER_HOST_UID="" \
    DOCKER_MKDIR="" \
    DOCKER_TIMEZONE="Europe/Zurich" \
    DOCKER_WEB_SERVER="apache" \
    NGINX_DOCUMENT_ROOT="web" \
    NGINX_LOG_PATH="var/logs/nginx" \
    NGINX_RUN_GROUP="docker" \
    NGINX_RUN_USER="docker" \
    PHP_LOG_PATH="var/logs/php" \
    PHP_MEMORY_LIMIT_APACHE="128M" \
    PHP_MEMORY_LIMIT_CLI="512M" \
    PHP_VERSION="${PHP_VERSION}" \
    PHP_VERSION_APT="${PHP_VERSION_APT}" \
    PHP_VERSION_DIR="${PHP_VERSION_DIR}" \
    PHP_XDEBUG_APACHE_ENABLE="off" \
    PHP_XDEBUG_CLI_ENABLE="off" \
    XHGUI_ACTIVE="false" \
    XHGUI_BASE_DIR="/xhgui" \
    XHGUI_DB_ENSURE="false" \
    XHGUI_DB_HOST="" \
    XHGUI_DB_NAME="" \
    XHGUI_SERVER_NAME="xhgui.${APACHE_SERVER_NAME}"

# Copy the needed shell scripts
COPY ./setup/ /setup/

# Make sure scripts are executables and run the build script
RUN set -xe \
    && mkdir -p /setup/run/ && chmod -R a+rX /setup \
    && find /setup -type f -name "*.sh" -exec sed -i 's/\r$//' {} \; \
    && find /setup -type f -name "*.sh" -exec chmod +x {} \; \
    && echo "PHP_VERSION=${PHP_VERSION}" \
    && /setup/docker/${FROM_DISTRIBUTION}/build.sh \
    && cp -R /setup/docker/${FROM_DISTRIBUTION}/run/* /setup/run/ \
    && rm -rf /setup/docker setup/tmp

# Set the workdir to mountpoint, the volume and the user
USER docker
WORKDIR ${DOCKER_BASE_DIR}
VOLUME ${DOCKER_BASE_DIR}

# Expose ports
EXPOSE 80 443 9000

# Run the default script on startup
CMD [ "/setup/run/start.sh" ]
