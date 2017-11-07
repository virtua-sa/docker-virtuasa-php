ARG FROM_IMAGE="debian:stretch"
FROM ${FROM_IMAGE}

# Set default environment variables
ARG FROM_IMAGE="debian:stretch"
ARG DOCKER_FROM_COMMIT=""
ARG PHP_VERSION="7.1"
ARG PHP_VERSION_APT="7.1"
ARG PHP_VERSION_DIR="/7.1"
ENV APACHE_DOCUMENT_ROOT="web" \
    APACHE_LOG_DIR="/data/var/logs/apache" \
    APACHE_LOG_PATH="var/logs/apache" \
    APACHE_RUN_GROUP="docker" \
    APACHE_RUN_USER="docker" \
    APACHE_SERVER_ADMIN="webmaster@localhost" \
    APACHE_SERVER_NAME="localhost" \
    APACHE_SSL_CERT_KEY="/etc/ssl/private/ssl-cert-snakeoil.key" \
    APACHE_SSL_CERT_PEM="/etc/ssl/certs/ssl-cert-snakeoil.pem" \
    DOCKER_BASE_DIR="/data" \
    DOCKER_CHMOD_666="" \
    DOCKER_CHMOD_777="" \
    DOCKER_CHMOD_R666="" \
    DOCKER_CHMOD_R777="" \
    DOCKER_COPY_CONFIG_FROM_HOST="false" \
    DOCKER_COPY_CONFIG_TO_HOST="false" \
    DOCKER_COPY_IP_TO_HOST="false" \
    DOCKER_CUSTOM_INIT="docker-init.sh" \
    DOCKER_CUSTOM_START="docker-start.sh" \
    DOCKER_DEBUG="" \
    DOCKER_FROM_COMMIT="${DOCKER_FROM_COMMIT}" \
    DOCKER_FROM_IMAGE="${FROM_IMAGE}" \
    DOCKER_HOST_GID="" \
    DOCKER_HOST_SETUP_DIR="setup" \
    DOCKER_HOST_UID="" \
    DOCKER_TIMEZONE="Europe/Zurich" \
    DOCKER_WEB_SERVER="apache" \
    NGINX_DOCUMENT_ROOT="web" \
    NGINX_LOG_PATH="var/logs/nginx" \
    NGINX_RUN_GROUP="docker" \
    NGINX_RUN_USER="docker" \
    PHP_LOG_PATH="var/logs/php" \
    PHP_VERSION="${PHP_VERSION}" \
    PHP_VERSION_APT="${PHP_VERSION_APT}" \
    PHP_VERSION_DIR="${PHP_VERSION_DIR}" \
    PHP_XDEBUG_APACHE_ENABLE="off" \
    PHP_XDEBUG_CLI_ENABLE="off"

# Copy the needed shell scripts
COPY ./setup/ /setup/

# Make sure scripts are executables and run the build script
RUN sed -i 's/\r$//' /setup/docker/*.sh \
    && chmod +x /setup/docker/*.sh \
    && ls -alhR /setup \
    && echo "PHP_VERSION=${PHP_VERSION}" \
    && /setup/docker/build.sh \
    && rm -rf /setup/docker/apt/* \
    && rm -f /setup/docker/build.sh \
    && rm -f /setup/docker/Dockerfile

# Set the workdir to mountpoint, the volume and the user
USER docker
WORKDIR /data
VOLUME /data

# Expose ports
EXPOSE 80 443 9000

# Run the default script on startup
CMD [ "/setup/docker/start.sh" ]
