# Virtua Docker Image - PHP

> `virtuasa/php:5.2`
> `virtuasa/php:5.3`
> `virtuasa/php:5.4`
> `virtuasa/php:5.5`
> `virtuasa/php:5.6`
> `virtuasa/php:7.0`
> `virtuasa/php:7.1`
> `virtuasa/php:7.2`

These images are built and published on [VirtuaSA Docker Hub](https://hub.docker.com/r/virtuasa/php/).

## Build

* Run the script `./docker-build.sh`:
  * `./docker-build.sh <PHP_VERSION>`
  * `./docker-build.sh all`
* Images can be pushed from GitlabCI if all tests are OK

## Images content

| [Tags (`virtuasa/php:`)](https://hub.docker.com/r/virtuasa/php/tags/)                             | 5.2      | 5.3       | 5.4      | 5.5      | 5.6      | 7.0       | 7.1       | 7.2       |
| ------------------------------------------------------------------------------------------------- | :------: | :-------: | :------: | :------: | :------: | :-------: | :-------: | :-------: |
| [PHP (`php`)](http://php.net/manual/en/)                                                          | *5.2.6*  | *5.3.3*   | *5.4.45* | *5.5.38* | *5.6.30* | *7.0.25*  | *7.1.11*  | *7.2.0RC5*|
| [Behat (`behat`)](http://behat.org/en/latest/quick_start.html)                                    |          |           |          | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [Composer (`composer`)](https://getcomposer.org/doc/01-basic-usage.md)                            |          | &#x2714;  | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [DbUnit (`dbunit`)](https://github.com/sebastianbergmann/dbunit)                                  |          |           |          |          |          | &#x2714;  | &#x2714;  | &#x2714;  |
| [Phing (`phing`)](https://www.phing.info/docs/guide/stable/)                                      |          | &#x2714;  | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHP_CodeSniffer (`phpcs`, `phpcbf`)](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Usage)    |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHP Copy/Paste Detector (`phpcpd`)](https://github.com/sebastianbergmann/phpcpd)                 |          |           |          |          | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHP_Depend (`pdepend`)](https://pdepend.org/documentation/getting-started.html)                  |          | &#x2714;  | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [PhpDocumentor (`phpdoc`)](https://docs.phpdoc.org/)                                              |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHPLOC (`phploc`)](https://github.com/sebastianbergmann/phploc)                                  |          |           |          |          | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [PhpMetrics (`phpmetrics`)](http://www.phpmetrics.org/documentation/index.html)                   |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHP Mess Detector (`phpmd`)](https://phpmd.org/documentation/index.html)                         |          | &#x2714;  | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHPUnit (Current Stable Release) (`phpunit`)](https://phpunit.de/manual/current/en/index.html)   |          |           |          |          |          | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHPUnit 6.2+ (`phpunit62`)](https://phpunit.de/manual/6.2/en/index.html)                         |          |           |          |          |          | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHPUnit 5.7+ (`phpunit57`)](https://phpunit.de/manual/5.7/en/index.html)                         |          |           |          |          | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHPUnit 4.8+ (`phpunit48`)](https://phpunit.de/manual/4.8/en/index.html)                         |          | &#x2714;  | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [Node.js (`node`, `npm`)](https://nodejs.org/dist/latest-v8.x/docs/api/)                          |          |           | *6.9.1*  | *6.9.1*  | *6.9.1*  | *8.9.0*   | *8.9.0*   | *8.9.0*   |
| [Bower (`bower`)](https://bower.io/)                                                              |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [Gulp (`gulp`)](https://github.com/gulpjs/gulp/blob/master/docs/API.md)                           |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [Grunt (`grunt`)](https://gruntjs.com/getting-started)                                            |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [PM2 (`pm2`)](http://pm2.keymetrics.io/docs/usage/quick-start/)                                   |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [Webpack (`webpack`)](https://webpack.js.org/concepts/)                                           |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [Yarn (`yarn`)](https://yarnpkg.com/en/docs)                                                      |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  |
| [Apache](https://httpd.apache.org/docs/2.4/)                                                      | *2.2.9*  | *2.2.16*  | *2.2.22* | *2.2.22* | *2.4.10* | *2.4.25*  | *2.4.25*  | *2.4.25*  |
| [NGINX](https://nginx.org/en/docs/)                                                               | *0.6.32* | *0.7.67*  | *1.2.1*  | *1.2.1*  | *1.6.2*  | *1.10.3*  | *1.10.3*  | *1.10.3*  |
| [Debian](https://www.debian.org/doc/)                                                             | *lenny*  | *squeeze* | *wheezy* | *wheezy* | *jessie* | *stretch* | *stretch* | *stretch* |

To customize these setup on your projects, changes must only be done to file [`docker-compose.yml`](https://docs.docker.com/compose/compose-file/compose-file-v1/).

*Apache* calls PHP with *mod_php*. *Nginx* calls PHP with

## Usage

### Customizable environment variables

> These variable are used on runtime and can change the default behavior of the images.
> Their value can be changed in `docker-compose.yml` file.

| Variable name                   | Default value                             | Description                                                                    |
| ------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------ |
| `APACHE_DOCUMENT_ROOT`          | `web`                                     | Path to the Apache document root folder \*
| `APACHE_LOG_PATH`               | `var/logs/apache`                         | Path of the website Apache log folder \*
| `APACHE_RUN_GROUP`              | `docker`                                  | Group of user running Apache
| `APACHE_RUN_USER`               | `docker`                                  | User running Apache
| `APACHE_SERVER_ADMIN`           | `webmaster@localhost`                     | Apache server administrator email address
| `APACHE_SERVER_NAME`            | `localhost`                               | Apache server name
| `APACHE_SSL_CERT_KEY`           | `/etc/ssl/private/ssl-cert-snakeoil.key`  | Private key used by Apache for SSL \**
| `APACHE_SSL_CERT_PEM`           | `/etc/ssl/certs/ssl-cert-snakeoil.pem`    | Public key used by Apache for SSL \**
| `DOCKER_BASE_DIR`               | `/data`                                   | Docker mount path inside the container \**
| `DOCKER_CHMOD_666`              | ` ` *(empty)*                             | Execute a `chmod 666` on given files if set \*
| `DOCKER_CHMOD_777`              | ` ` *(empty)*                             | Execute a `chmod 777` on given files if set \*
| `DOCKER_CHMOD_R666`             | ` ` *(empty)*                             | Execute a `chmod -R 666` on given files if set \*
| `DOCKER_CHMOD_R777`             | ` ` *(empty)*                             | Execute a `chmod -R 777` on given files if set \*
| `DOCKER_COPY_CONFIG_FROM_HOST`  | `false`                                   | Copy the configuration files from the setup folder on the host if set to `true`
| `DOCKER_COPY_CONFIG_TO_HOST`    | `false`                                   | Copy the configuration files to the setup folder on the host if set to `true`
| `DOCKER_COPY_IP_TO_HOST`        | `false`                                   | Copy the container's ip to the setup folder on the host if set to `true`
| `DOCKER_CUSTOM_INIT`            | `docker-init.sh`                          | Execute script before doing anything else \*
| `DOCKER_CUSTOM_START`           | `docker-start.sh`                         | Execute script just before starting web server \*
| `DOCKER_CUSTOM_STOP`            | `docker-stop.sh`                          | Execute script before shutting down \*
| `DOCKER_DEBUG`                  | ` ` *(empty)*                             | Enable debug output if any value is set
| `DOCKER_HOST_GID`               | ` ` *(empty)*                             | `chown` the mount path to given GID (see `id -g`) if set \***
| `DOCKER_HOST_SETUP_DIR`         | `setup`                                   | Path of the setup configuration files on the host \*
| `DOCKER_HOST_UID`               | ` ` *(empty)*                             | `chown` the mount path to given UID (see `id -u`) if set \***
| `DOCKER_MKDIR`                  | ` ` *(empty)*                             | Create requested directories if set \*
| `DOCKER_TIMEZONE`               | `Europe/Zurich`                           | Time zone of the Docker container
| `DOCKER_WEB_SERVER`             | `apache`                                  | Web server to use, can be either `apache` or `nginx`
| `NGINX_DOCUMENT_ROOT`           | `web`                                     | Path to the Nginx document root folder \*
| `NGINX_LOG_PATH`                | `var/logs/nginx`                          | Path of the website Nginx log folder \*
| `NGINX_RUN_GROUP`               | `docker`                                  | Group of user running Nginx
| `NGINX_RUN_USER`                | `docker`                                  | User running Nginx
| `PHP_LOG_PATH`                  | `var/logs/php`                            | Path of the PHP log folder \*
| `PHP_MEMORY_LIMIT_APACHE`       | `128M`                                    | Maximum amount of memory a PHP script running on Apache may consume
| `PHP_MEMORY_LIMIT_CLI`          | `512M`                                    | Maximum amount of memory a PHP script running on CLI may consume
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
| `DOCKER_BUILD_DATE`             | `2017-12-13T15:22:29+0100`                | Build date of the image, using ISO-8601 format
| `DOCKER_FROM_COMMIT`            | `f84a27d7`                                | Short hash of the git commit used to build the Docker image in this repository
| `DOCKER_FROM_IMAGE`             | `debian/stretch`                          | Name of the base image used to build the Docker image
| `PHP_VERSION`                   | `7.1`                                     | PHP version included in the image
| `PHP_VERSION_APT`               | `7.1`                                     | PHP version used in the `apt-get install` instructions
| `PHP_VERSION_DIR`               | `/7.1`                                    | PHP version used in the paths of PHP configuration files

### Limitations with old PHP versions

* `PHP 5.2`:
  * Using `DOCKER_COPY_CONFIG_TO_HOST=true` will override host local files sharring the same names on each startup of the container.
  * Using `DOCKER_WEB_SERVER=nginx` is not allowed, and `apache` will be used instead, this can be overriden by setting the value of `DOCKER_WEB_SERVER` with a script loaded by `DOCKER_CUSTOM_INIT`.
* `PHP 5.3`:
  * Using `DOCKER_WEB_SERVER=nginx` is not allowed, and `apache` will be used instead, this can be overriden by setting the value of `DOCKER_WEB_SERVER` with a script loaded by `DOCKER_CUSTOM_INIT`.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).