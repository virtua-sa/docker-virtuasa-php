[![Build Status](https://travis-ci.org/virtua-sa/docker-virtuasa-php.svg?branch=develop)](https://travis-ci.org/virtua-sa/docker-virtuasa-php)

# Virtua Docker Image - PHP

> [`virtuasa/php:5.2`](https://microbadger.com/images/virtuasa/php:5.2)
> [`virtuasa/php:5.3`](https://microbadger.com/images/virtuasa/php:5.3)
> [`virtuasa/php:5.4`](https://microbadger.com/images/virtuasa/php:5.4)
> [`virtuasa/php:5.5`](https://microbadger.com/images/virtuasa/php:5.5)
> [`virtuasa/php:5.6`](https://microbadger.com/images/virtuasa/php:5.6)
> [`virtuasa/php:7.0`](https://microbadger.com/images/virtuasa/php:7.0)
> [`virtuasa/php:7.1`](https://microbadger.com/images/virtuasa/php:7.1)
> [`virtuasa/php:7.2`](https://microbadger.com/images/virtuasa/php:7.2)
> [`virtuasa/php:7.3`](https://microbadger.com/images/virtuasa/php:7.3)

These images are built and published on [VirtuaSA Docker Hub](https://hub.docker.com/r/virtuasa/php/).

## Build

* Run the script `./docker-build.sh`:
  * `./docker-build.sh <PHP_VERSION>`
  * `./docker-build.sh all`
* Images can be pushed from GitlabCI if all tests are OK

## Images content

| [Tags (`virtuasa/php:`)](https://hub.docker.com/r/virtuasa/php/tags/)                             | 5.2      | 5.3       | 5.4      | 5.5      | 5.6      | 7.0       | 7.1       | 7.2       | 7.3       |
| ------------------------------------------------------------------------------------------------- | :------: | :-------: | :------: | :------: | :------: | :-------: | :-------: | :-------: | :-------: |
| [PHP (`php`)](http://php.net/manual/en/)                                                          | *5.2.6*  | *5.3.3*   | *5.4.45* | *5.5.38* | *5.6.30* | *7.0.31*  | *7.1.20*  | *7.2.9*   | *7.3.0*   |
| [Behat (`behat`)](http://behat.org/en/latest/quick_start.html)                                    |          |           |          | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [Composer (`composer`)](https://getcomposer.org/doc/01-basic-usage.md)                            |          | &#x2714;  | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [DbUnit (`dbunit`)](https://github.com/sebastianbergmann/dbunit)                                  |          |           |          |          |          | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [Phing (`phing`)](https://www.phing.info/docs/guide/stable/)                                      |          | &#x2714;  | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHP_CodeSniffer (`phpcs`, `phpcbf`)](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Usage)    |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHP Copy/Paste Detector (`phpcpd`)](https://github.com/sebastianbergmann/phpcpd)                 |          |           |          |          | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHP_Depend (`pdepend`)](https://pdepend.org/documentation/getting-started.html)                  |          | &#x2714;  | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHP Coding Standards Fixer (`php-cs-fixer`)](https://github.com/friendsofphp/php-cs-fixer)       |          |           | *2.2.20* | *2.2.20* | *2.14.0+*| *2.14.0+* | *2.14.0+* | *2.14.0+* | *2.14.0+* |
| [PHP Static Analysis Tool (`phpstan`)](https://github.com/phpstan/phpstan)                        |          |           |          |          |          |  *0.9.2*  | *0.10.3+* | *0.10.3+* | *0.10.3+* |
| [PhpDocumentor (`phpdoc`)](https://docs.phpdoc.org/)                                              |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PhpDox (`phpdox`)](http://phpdox.de/)                                                            |          |  0.8.1.1  |  0.9.0   |  0.11.2  |  0.11.2  |  0.11.2   | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHPLOC (`phploc`)](https://github.com/sebastianbergmann/phploc)                                  |          |           |          |          | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PhpMetrics (`phpmetrics`)](http://www.phpmetrics.org/documentation/index.html)                   |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHP Mess Detector (`phpmd`)](https://phpmd.org/documentation/index.html)                         |          | &#x2714;  | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHPUnit (Current Stable Release) (`phpunit`)](https://phpunit.readthedocs.io/)                   |          |           |          |          |          |           |           | &#x2714;  | &#x2714;  |
| [PHPUnit 7.5+ (`phpunit75`)](https://phpunit.readthedocs.io/en/7.5/)                              |          |           |          |          |          |           | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHPUnit 6.2+ (`phpunit62`)](https://phpunit.readthedocs.io/en/6.2/)                              |          |           |          |          |          | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHPUnit 5.7+ (`phpunit57`)](https://phpunit.readthedocs.io/en/5.7/)                              |          |           |          |          | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PHPUnit 4.8+ (`phpunit48`)](https://phpunit.readthedocs.io/en/4.8/)                              |          | &#x2714;  | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [Node.js (`node`, `npm`)](https://nodejs.org/dist/latest-v8.x/docs/api/)                          |          |           | *6.9.1*  | *6.9.1*  | *6.9.1*  | *8.9.0*   | *8.9.0*   | *8.9.0*   | *8.9.0*   |
| [Bower (`bower`)](https://bower.io/)                                                              |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [Gulp (`gulp`)](https://github.com/gulpjs/gulp/blob/master/docs/API.md)                           |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [Grunt (`grunt`)](https://gruntjs.com/getting-started)                                            |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [PM2 (`pm2`)](http://pm2.keymetrics.io/docs/usage/quick-start/)                                   |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [Webpack (`webpack`)](https://webpack.js.org/concepts/)                                           |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [XHGUI (`xhgui`)](https://github.com/perftools/xhgui)                                             |          |           |          | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [Yarn (`yarn`)](https://yarnpkg.com/en/docs)                                                      |          |           | &#x2714; | &#x2714; | &#x2714; | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [Apache](https://httpd.apache.org/docs/2.4/)                                                      | *2.2.9*  | *2.2.16*  | *2.2.22* | *2.2.22* | *2.4.10* | *2.4.25*  | *2.4.25*  | *2.4.25*  | *2.4.25*  |
| [NGINX](https://nginx.org/en/docs/)                                                               | *0.6.32* | *0.7.67*  | *1.2.1*  | *1.2.1*  | *1.6.2*  | *1.10.3*  | *1.10.3*  | *1.10.3*  | *1.10.3*  |
| [SSMTP](https://doc.ubuntu-fr.org/ssmtp)                                                          |  *2.64*  |  *2.64*   |  *2.64*  |  *2.64*  |  *2.64*  |  *2.64*   |  *2.64*   |  *2.64*   |  *2.64*   |
| [Debian](https://www.debian.org/doc/)                                                             | *lenny*  | *squeeze* | *wheezy* | *wheezy* | *jessie* | *stretch* | *stretch* | *stretch* | *stretch* |

To customize these setup on your projects, changes must only be done to file [`docker-compose.yml`](https://docs.docker.com/compose/compose-file/compose-file-v1/).

*Apache* calls PHP with *mod_php*. *Nginx* calls PHP with *php-fpm*

## Usage

### Customizable environment variables

> These variable are used on runtime and can change the default behavior of the images.
> Their value can be changed in `docker-compose.yml` file.

| Variable name                   | Default value                             | Description                                                                    |
| ------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------ |
| `HOSTNAME_LOCAL_ALIAS`          | ``                                        | List of hosts names alias for machine resolved to 127.0.0.1, separator is coma
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
| `DOCKER_HOST_SETUP_DIR`         | `setup`                                   | Path of the setup configuration files on the host \*
| `DOCKER_MKDIR`                  | ` ` *(empty)*                             | Create requested directories using `mkdir -p` if set \*
| `FIXUID`                        | `1000`                                    | docker user UID (see `id -u` in you host) must be set to UID of the developer \***
| `FIXGID`                        | `1000`                                    | docker user GID (see `id -g` in you host) must be set to GID of the developer \***
| `DOCKER_TIMEZONE`               | `Europe/Zurich`                           | Time zone of the Docker container
| `DOCKER_WEB_SERVER`             | `apache`                                  | Web server to use, can be either `apache` or `nginx`
| `NGINX_DOCUMENT_ROOT`           | `web`                                     | Path to the Nginx document root folder \*
| `NGINX_LOG_PATH`                | `var/logs/nginx`                          | Path of the website Nginx log folder \*
| `NGINX_RUN_GROUP`               | `docker`                                  | Group of user running Nginx
| `NGINX_RUN_USER`                | `docker`                                  | User running Nginx
| `PHP_LOG_PATH`                  | `var/logs/php`                            | Path of the PHP log folder \*
| `PHP_MEMORY_LIMIT_APACHE`       | `128M`                                    | Maximum amount of memory a PHP script running on Apache may consume
| `PHP_MEMORY_LIMIT_CLI`          | `512M`                                    | Maximum amount of memory a PHP script running on CLI may consume
| `PHP_XDEBUG_APACHE_AUTOSTART`   | `0`                                       | Force activation of PHP XDebug on Apache if set to `1`
| `PHP_XDEBUG_CLI_AUTOSTART`      | `0`                                       | Force activation of PHP XDebug on CLI if set to `1`
| `SSMTP_MAILHUB`                 | `smtp.docker`                             | The host to send mail to, in the form host IP_addr[:port]. The default port is 25.
| `SSMTP_AUTH_USER`               | ` ` *(empty)*                             | The user name to use for SMTP AUTH. The default is blank, in which case SMTP AUTH is not used. sent without
| `SSMTP_AUTH_PASS`               | ` ` *(empty)*                             | The password to use for SMTP AUTH.
| `SSMTP_AUTH_METHOD`             | ` ` *(empty)*                             | The authorization method to use. If unset, plain text is used. May also be set to “cram-md5”.
| `SSMTP_USE_TLS`                 | ` ` *(empty)*                             | Specifies whether ssmtp uses TLS to talk to the SMTP server. The default is “no”.
| `SSMTP_USE_STARTTLS`            | ` ` *(empty)*                             | Specifies whether ssmtp does a EHLO/STARTTLS before starting SSL negotiation. See RFC 2487.
| `SSMTP_SENDER_ROOT`             | ` ` *(empty)*                             | The user that gets all mail for userids less than 1000. If blank, address rewriting is disabled.
| `SSMTP_SENDER_HOSTNAME`         | ` ` *(empty)*                             | The full qualified name of the host. If not specified, the host is queried for its hostname.
| `SSMTP_REWRITE_DOMAIN`          | ` ` *(empty)*                             | The domain from which mail seems to come. for user authentication.
| `SSMTP_FROM_LINE_OVERRIDE`      | ` ` *(empty)*                             | Specifies whether the From header of an email, if any, may override the default domain. The default is `no`.
| `XHGUI_ACTIVE`                  | `false`                                   | Activate of Tideways profiling if set to `true`
| `XHGUI_DB_ENSURE`               | `false`                                   | Ensure MongoDB database creation and configuration if set to `true`
| `XHGUI_DB_HOST`                 | ` ` *(empty)*                             | MongoDB database host to store the profiles
| `XHGUI_DB_NAME`                 | ` ` *(empty)*                             | MongoDB database name to store the profiles
| `XHGUI_SERVER_NAME`             | `xhgui.localhost`                         | XHGUI Apache server name
| `COMPOSER_AUTO_INSTALL`         | `false`                                   | Automatic composer install, on start container if `true` 
| `NPM_AUTO_INSTALL`              | `false`                                   | Automatic npm install, on start container if `true` 

\* *Path is relative to the Docker container mount path, i.e., to the root of the project.*

\*\* *Path is absolute in the Docker container, don't forget to add the path of the mount path if needed.*

\*\*\* *`FIXUID` and `FIXGID` must be set globaly host side.*

### FIXUID and FIXGID

If you host linux user don't have the id 1000 (check with `id`), please set the globals variables to your session :
 ```bash
    printf "FIXUID=`id -u`\nFIXGID=`id -g`" >> ~/.profile
```    
When using docker-compose file, set `user` parameter for the container like that :
```yaml
    user: ${FIXUID:-1000}:${FIXGID:-1000}
```

### Readonly environment variables

> These variables are used to build the images and can be used to adapt behaviors between their different flavors.
> *Changing their value is not recommended.*

| Variable name                   | Sample value                              | Description                                                                    |
| ------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------ |
| `DOCKER_BUILD_DATE`             | `2017-12-13T15:22:29+0100`                | Build date of the image, using ISO-8601 format
| `DOCKER_FROM_COMMIT`            | `f84a27d7`                                | Short hash of the git commit used to build the Docker image in this repository
| `DOCKER_FROM_IMAGE`             | `debian/stretch`                          | Name of the base image used to build the Docker image
| `PHP_VERSION`                   | `7.1`                                     | PHP version included in the image
| `PHP_VERSION_APT`               | `7.1`                                     | PHP version used in the `apt-get install` instructions
| `PHP_VERSION_DIR`               | `/7.1`                                    | PHP version used in the paths of PHP configuration files
| `XHGUI_BASE_DIR`                | `/xhgui`                                  | XHGUI installation directory

### Limitations with old PHP versions

* `PHP 5.2`:
  * Using `DOCKER_COPY_CONFIG_TO_HOST=true` will override host local files sharring the same names on each startup of the container.
  * Using `DOCKER_WEB_SERVER=nginx` is not allowed, and `apache` will be used instead, this can be overriden by setting the value of `DOCKER_WEB_SERVER` with a script loaded by `DOCKER_CUSTOM_INIT`.
* `PHP 5.3`:
  * Using `DOCKER_WEB_SERVER=nginx` is not allowed, and `apache` will be used instead, this can be overriden by setting the value of `DOCKER_WEB_SERVER` with a script loaded by `DOCKER_CUSTOM_INIT`.
* `PHP < 5.5`:
  * Using `XHGUI_ACTIVE=true` is incompatible, on Docker start the variable will be overriden to `XHGUI_ACTIVE=false`.

