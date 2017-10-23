# Virtua Docker Container - PHP

> `virtuasa/php:5.2`
> `virtuasa/php:5.3`
> `virtuasa/php:5.4`
> `virtuasa/php:5.5`
> `virtuasa/php:5.6`
> `virtuasa/php:7.0`
> `virtuasa/php:7.1`
> `virtuasa/php:7.2`

These images are built and published on Docker Hub : https://hub.docker.com/r/virtuasa/php/

## Build

* Run the script `./docker-build.sh`:
  * `./docker-build.sh <PHP_VERSION>`
  * `./docker-build.sh all`

## Images content

* PHP
  * Composer 1.4.1+
  * PHPUnit 6.2+
  * PHPUnit 5.7+
  * PHPUnit 4.8+
* Node.js 6.11+
  * Bower, Gulp, Grunt, Webpack
* Yarn
* Apache
* Debian

*Some features are not included on too old PHP version (5.2 & 5.3 especially).*

To customize these setup on your projects, changes must only be done to file [`docker-compose.yml`](docker-compose.yml).

## Usage

### Customizable environment variables

> These variable are used on runtime and can change the default behavior of the images.
> Their value can be changed in `docker-compose.yml` file.

| Variable name                   | Default value                             | Description                                                                    |
| ------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------ |
| `APACHE_DOCUMENT_ROOT`          | `web`                                     | Path to the Apache document root folder \*
| `APACHE_LOG_DIR`                | `/data/var/logs/apache`                   | Path of the default Apache log folder \**
| `APACHE_LOG_PATH`               | `var/logs/apache`                         | Path of the website Apache log folder \*
| `APACHE_RUN_GROUP`              | `docker`                                  | Group of user running Apache
| `APACHE_RUN_USER`               | `docker`                                  | User running Apache
| `APACHE_SERVER_ADMIN`           | `webmaster@localhost`                     | Apache server administrator email address
| `APACHE_SERVER_NAME`            | `localhost`                               | Apache server name
| `APACHE_SSL_CERT_KEY`           | `/etc/ssl/private/ssl-cert-snakeoil.key`  | Private key used by Apache for SSL \**
| `APACHE_SSL_CERT_PEM`           | `/etc/ssl/certs/ssl-cert-snakeoil.pem`    | Public key used by Apache for SSL \**
| `DOCKER_BASE_DIR`               | `/data`                                   | Docker mount path inside the container \**
| `DOCKER_COPY_CONFIG_FROM_HOST`  | `false`                                   | Copy the configuration files from the setup folder on the host if set to `true`
| `DOCKER_COPY_CONFIG_TO_HOST`    | `false`                                   | Copy the configuration files to the setup folder on the host if set to `true`
| `DOCKER_CUSTOM_START`           | `docker-start.sh`                         | Execute script just before starting Apache, can be used for chmod if set \*
| `DOCKER_DEBUG`                  | ` ` *(empty)*                             | Enable debug output if any value is set
| `DOCKER_HOST_GID`               | ` ` *(empty)*                             | `chown` the mount path to given GID (see `id -g`) if set \***
| `DOCKER_HOST_SETUP_DIR`         | `setup`                                   | Path of the setup configuration files on the host \*
| `DOCKER_HOST_UID`               | ` ` *(empty)*                             | `chown` the mount path to given UID (see `id -u`) if set \***
| `DOCKER_TIMEZONE`               | `Europe/Zurich`                           | Time zone of the Docker container
| `PHP_LOG_PATH`                  | `var/logs/php`                            | Path of the PHP log folder \*
| `PHP_XDEBUG_APACHE_ENABLE`      | `off`                                     | Force activation of PHP XDebug on Apache if set to `on`
| `PHP_XDEBUG_CLI_ENABLE`         | `off`                                     | Force activation of PHP XDebug on CLI if set to `on`

\* *Path is relative to the Docker container mount path, i.e., to the root of the project.*

\*\* *Path is absolute in the Docker container, don't forget to add the path of the mount path if needed.*

\*\*\* *`DOCKER_HOST_GID` and `DOCKER_HOST_UID` must be both empty or both have a value.*

### Readonly environment variables

> These variables are used to build the images and can be used to adapt behaviors between their different flavors.
> *Changing their value is not recommanded.*

| Variable name                   | Sample value                              | Description                                                                    |
| ------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------ |
| `DOCKER_FROM_IMAGE`             | `debian/stretch`                          | Name of the base image used to build the Docker image
| `PHP_VERSION`                   | `7.1`                                     | PHP version included in the image
| `PHP_VERSION_APT`               | `7.1`                                     | PHP version used in the `apt-get install` instructions
| `PHP_VERSION_DIR`               | `/7.1`                                    | PHP version used in the paths of PHP configuration files

## Changelog

* **v1.0.1 - 20171016**
  * Metadata
      * Version: 1.0.1
      * Tags: `virtuasa/php:*-20171016`
      * Built on commit : [abc50064](https://gitlab.virtua.ch/ddev/tools-docker/commit/abc500643e9fa2b33a3995704a3ba01da96b5dd0)
  * Changes
      * Fixed: php7-snmp now works well on Debian Stretch
      * Changed: DOCKER_HOST_GID and DOCKER_HOST_UID are now empty by default, chown is only done when a value is assigned to both of them
      * Added: DOCKER_CUSTOM_START can contain the name of a script that will be executed just before Apache starts, usefull for custom file permissions
* **v1.0.0 - 20171014**
  * Metadata
      * Version: 1.0.0
      * Tags: `virtuasa/php:*-20171014`
      * Built on commit : [ca14b473](https://gitlab.virtua.ch/ddev/tools-docker/commit/ca14b473dd475ca6462986ab174bac041afedf34)
  * Changes
      * First public release