ARG FROM_IMAGE="debian:stretch"
FROM ${FROM_IMAGE}

# Set default environment variables
ARG FROM_IMAGE="debian:stretch"
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
    DOCKER_COPY_CONFIG_FROM_HOST="false" \
    DOCKER_COPY_CONFIG_TO_HOST="false" \
    DOCKER_CUSTOM_START="docker-start.sh" \
    DOCKER_DEBUG="" \
    DOCKER_FROM_IMAGE="${FROM_IMAGE}" \
    DOCKER_HOST_GID="" \
    DOCKER_HOST_SETUP_DIR="setup" \
    DOCKER_HOST_UID="" \
    DOCKER_TIMEZONE="Europe/Zurich" \
    PHP_LOG_PATH="var/logs/php" \
    PHP_VERSION="${PHP_VERSION}" \
    PHP_VERSION_APT="${PHP_VERSION_APT}" \
    PHP_VERSION_DIR="${PHP_VERSION_DIR}" \
    PHP_XDEBUG_APACHE_ENABLE="off" \
    PHP_XDEBUG_CLI_ENABLE="off"

# Copy the needed shell scripts
COPY ./setup/ /home/docker/

# Make sure scripts are executables and run the build script
RUN sed -i 's/\r$//' /home/docker/docker/*.sh \
    && chmod +x /home/docker/docker/*.sh \
    && ls -alhR /home/docker \
    && echo "PHP_VERSION=${PHP_VERSION}" \
    && /home/docker/docker/build.sh \
    && rm -rf /home/docker/docker/apt/* \
    && rm -f /home/docker/docker/build.sh \
    && rm -f /home/docker/docker/Dockerfile

# Set the workdir to mountpoint and the user
USER docker
WORKDIR /data/

# Expose ports
EXPOSE 80 443 9000

# Run the default script on startup
CMD [ "/home/docker/docker/start.sh" ]
