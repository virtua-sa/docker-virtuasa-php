[![Build Status](https://travis-ci.org/virtua-sa/docker-virtuasa-php.svg?branch=develop)](https://travis-ci.org/virtua-sa/docker-virtuasa-php)

# Virtua Docker Image - PHP

> [`virtuasa/php:7.0-v2`](https://hub.docker.com/r/virtuasa/php/tags?page=1&name=7.0-v2)
> [`virtuasa/php:7.1-v2`](https://hub.docker.com/r/virtuasa/php/tags?page=1&name=7.1-v2)
> [`virtuasa/php:7.2-v2`](https://hub.docker.com/r/virtuasa/php/tags?page=1&name=7.2-v2)
> [`virtuasa/php:7.3-v2`](https://hub.docker.com/r/virtuasa/php/tags?page=1&name=7.3-v2)
> [`virtuasa/php:7.4-v2`](https://hub.docker.com/r/virtuasa/php/tags?page=1&name=7.4-v2)
> [`virtuasa/php:8.0-v2`](https://hub.docker.com/r/virtuasa/php/tags?page=1&name=8.0-v2)
> [`virtuasa/php:8.1-v2`](https://hub.docker.com/r/virtuasa/php/tags?page=1&name=8.1-v2)

These images are built and published on [VirtuaSA Docker Hub](https://hub.docker.com/r/virtuasa/php/).

## Build

* Run the script `./docker-build.sh`:
  * `./docker-build.sh <PHP_VERSION>`
  * `./docker-build.sh all`
* Images can be pushed from GitlabCI if all tests are OK

## Images content

| [Tags (`virtuasa/php:`)](https://hub.docker.com/r/virtuasa/php/tags/)  |    7.0    |    7.1    |    7.2    |    7.3    |    7.4    |    8.0    |    8.0    |
|------------------------------------------------------------------------|:---------:|:---------:|:---------:|:---------:|:---------:|:---------:|:---------:|
| [PHP (`php`)](http://php.net/manual/en/)                               | *7.0.33*  | *7.1.33*  | *7.2.34*  | *7.3.33*  | *7.4.27*  |  *8.0.14* |  *8.1.1*  |
| [Composer (`composer`)](https://getcomposer.org/doc/01-basic-usage.md) | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  | &#x2714;  |
| [Apache](https://httpd.apache.org/docs/2.4/)                           | *2.4.38*  | *2.4.38*  | *2.4.38*  | *2.4.38*  | *2.4.38*  | *2.4.38*  | *2.4.38*  |
| [NGINX](https://nginx.org/en/docs/)                                    | *1.14.2*  | *1.14.2*  | *1.14.2*  | *1.14.2*  | *1.14.2*  | *1.14.2*  | *1.14.2*  |
| [MSMTP](https://marlam.de/msmtp/)                                      |  *1.8.3*  |  *1.8.3*  |  *1.8.3*  |  *1.8.3*  |  *1.8.3*  |  *1.8.3*  |  *1.8.3*  |
| [NodeJs](https://httpd.apache.org/docs/2.4/)                           |  *16.x*   |  *16.x*   |  *16.x*   |  *16.x*   |  *16.x*   |  *16.x*   |  *16.x*   |
| [Node.js (`npm`)](https://nodejs.org/dist/latest-v16.x/docs/api/)      |  *8.1.2*  |  *8.1.2*  |  *8.1.2*  |  *8.1.2*  |  *8.1.2*  |  *8.1.2*  |  *8.1.2*  |  
| [Yarn (`yarn`)](https://yarnpkg.com/en/docs)                           | *1.22.17* | *1.22.17* | *1.22.17* | *1.22.17* | *1.22.17* | *1.22.17* | *1.22.17* |
| [Debian](https://www.debian.org/doc/)                                  | *buster*  | *buster*  | *buster*  | *buster*  | *buster*  | *buster*  | *buster*  |

To customize this setup on your projects, changes must only be done to file [`docker-compose.yml`](https://docs.docker.com/compose/compose-file/).

*Apache* calls PHP with *mod_php*. *Nginx* calls PHP with *php-fpm*

## Usage

### Customizable environment variables

> These variable are used on runtime and can change the default behavior of the images.
> Their value can be changed in `docker-compose.yml` file.

| Variable name                  | Default value                         | Description                                                                    |
| ------------------------------ | ------------------------------------- | ------------------------------------------------------------------------------ |
| `HOSTNAME_LOCAL_ALIAS`         | ``                                    | List of hosts names alias for machine resolved to 127.0.0.1, separator is coma
| `APACHE_DOCUMENT_ROOT`         | `web`                                 | Path to the Apache document root folder \*
| `APACHE_LOG_PATH`              | `var/logs/apache`                     | Path of the website Apache log folder \*
| `APACHE_RUN_GROUP`             | `docker`                              | Group of user running Apache
| `APACHE_RUN_USER`              | `docker`                              | User running Apache
| `APACHE_SERVER_ADMIN`          | `webmaster@localhost`                 | Apache server administrator email address
| `APACHE_SERVER_NAME`           | `localhost`                           | Apache server name
| `APACHE_SSL_CERT_KEY`          | `/etc/ssl/private/ssl-cert-snakeoil.key` | Private key used by Apache for SSL \**
| `APACHE_SSL_CERT_PEM`          | `/etc/ssl/certs/ssl-cert-snakeoil.pem` | Public key used by Apache for SSL \**
| `DOCKER_BASE_DIR`              | `/data`                               | Docker mount path inside the container \**
| `DOCKER_CHMOD_666`             | ` ` *(empty)*                         | Execute a `chmod 666` on given files if set \*
| `DOCKER_CHMOD_777`             | ` ` *(empty)*                         | Execute a `chmod 777` on given files if set \*
| `DOCKER_CHMOD_R666`            | ` ` *(empty)*                         | Execute a `chmod -R 666` on given files if set \*
| `DOCKER_CHMOD_R777`            | ` ` *(empty)*                         | Execute a `chmod -R 777` on given files if set \*
| `DOCKER_COPY_CONFIG_FROM_HOST` | `false`                               | Copy the configuration files from the setup folder on the host if set to `true`
| `DOCKER_COPY_CONFIG_TO_HOST`   | `false`                               | Copy the configuration files to the setup folder on the host if set to `true`
| `DOCKER_COPY_IP_TO_HOST`       | `false`                               | Copy the container's ip to the setup folder on the host if set to `true`
| `DOCKER_CUSTOM_INIT`           | `docker-init.sh`                      | Execute script before doing anything else \*
| `DOCKER_CUSTOM_START`          | `docker-start.sh`                     | Execute script just before starting web server \*
| `DOCKER_CUSTOM_STOP`           | `docker-stop.sh`                      | Execute script before shutting down \*
| `DOCKER_DEBUG`                 | ` ` *(empty)*                         | Enable debug output if any value is set
| `DOCKER_HOST_SETUP_DIR`        | `setup`                               | Path of the setup configuration files on the host \*
| `DOCKER_MKDIR`                 | ` ` *(empty)*                         | Create requested directories using `mkdir -p` if set \*
| `FIXUID`                       | `1000`                                | docker user UID (see `id -u` in you host) must be set to UID of the developer \***
| `FIXGID`                       | `1000`                                | docker user GID (see `id -g` in you host) must be set to GID of the developer \***
| `DOCKER_TIMEZONE`              | `Europe/Zurich`                       | Time zone of the Docker container
| `DOCKER_WEB_SERVER`            | `apache`                              | Web server to use, can be either `apache` or `nginx`
| `NGINX_DOCUMENT_ROOT`          | `web`                                 | Path to the Nginx document root folder \*
| `NGINX_LOG_PATH`               | `var/logs/nginx`                      | Path of the website Nginx log folder \*
| `NGINX_RUN_GROUP`              | `docker`                              | Group of user running Nginx
| `NGINX_RUN_USER`               | `docker`                              | User running Nginx
| `PHP_LOG_PATH`                 | `var/logs/php`                        | Path of the PHP log folder \*
| `PHP_MEMORY_LIMIT_APACHE`      | `128M`                                | Maximum amount of memory a PHP script running on Apache may consume
| `PHP_MEMORY_LIMIT_CLI`         | `512M`                                | Maximum amount of memory a PHP script running on CLI may consume
| `SMTP_MAILHUB`                | `smtp.docker`                         | The host to send mail to, in the form host IP_addr[:port]. The default port is 25.
| `SMTP_AUTH_USER`              | ` ` *(empty)*                         | The user name to use for SMTP AUTH. The default is blank, in which case SMTP AUTH is not used. sent without
| `SMTP_AUTH_PASS`              | ` ` *(empty)*                         | The password to use for SMTP AUTH.
| `SMTP_SENDER_HOSTNAME`        | ` ` *(empty)*                         | The full qualified name of the host. If not specified, the host is queried for its hostname.
| `BLACKFIRE_CLIENT_ID`          | ` ` *(empty)*                         | Blackfire Client ID
| `BLACKFIRE_CLIENT_TOKEN`       | ` ` *(empty)*                         | Blackfire Client Token
| `BLACKFIRE_SERVER_ID`          | ` ` *(empty)*                         | Blackfire Server ID
| `BLACKFIRE_SERVER_TOKEN`       | ` ` *(empty)*                         | Blackfire Server Token

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

### Blackfire.io Profiling

To profile a PHP script with [Blackfire.io](https://blackfire.io/), you need to create a personal account in website.

After define the following environment variable on your computer, retrieve values from [blackfire.io settings/credentials](https://blackfire.io/my/settings/credentials) :
```bash
BLACKFIRE_CLIENT_ID="<Client ID>"
BLACKFIRE_CLIENT_TOKEN="<Client Token>"
BLACKFIRE_SERVER_ID="<Server ID>"
BLACKFIRE_SERVER_TOKEN="<Server Token>"
```
You can put the following values in file `~/.profile` to keep this information after computer reboot. To do not reboot your computer export the variable and do a docker up.

How to profile :
- [Google Chrome](https://blackfire.io/docs/integrations/chrome)
- [Firefox](https://blackfire.io/docs/integrations/firefox)
- PHP CLI : instance of `php` use `blackfire run` inside the docker

### Special Extra Tools

List of extra command line tools, not exhaustive :

| Command                                           | Description                                                                        |
|---------------------------------------------------|------------------------------------------------------------------------------------|
| `xdisable`                                        | XDebug Disable completely on the container, for performance purpose (http and cli) |     
| `xenable`                                         | XDebug Enable completely on the container, for debug purpose (http and cli)        | 
| `php_xdebug`                                      | Run a PHP CLI command with XDebug active                                           |     
| `php_no_xdebug`                                   | Run a PHP CLI command without extension XDebug                                     |         
| `doctrine`                                        | Calleo Applications ONLY alias of `bin/doctrine.php` from any project directory    |     
| `cbatch`                                          | Calleo Applications ONLY alias of `bin/batch.php` from any project directory       | 
| `cbatch_xdebug`                                   | Calleo Applications ONLY alias of `bin/batch.php` with XDebug active               |         
| `blackfire_disable`                               | Blackfire.io disable module and agent                                              |     
| `blackfire_enable`                                | Blackfire.io enable module and agent (auto disable xdebug)                         |     
| `blackfire run <php script and params>`           | Run Blackfire.io for a CLI script (require Blackfire enabled `blackfire_enable`)   |     

### Readonly environment variables

> These variables are used to build the images and can be used to adapt behaviors between their different flavors.
> *Changing their value is not recommended.*

| Variable name                   | Sample value               | Description                                                                    |
| ------------------------------- |----------------------------| ------------------------------------------------------------------------------ |
| `DOCKER_BUILD_DATE`             | `2017-12-13T15:22:29+0100` | Build date of the image, using ISO-8601 format
| `DOCKER_FROM_COMMIT`            | `f84a27d7`                 | Short hash of the git commit used to build the Docker image in this repository
| `DOCKER_FROM_IMAGE`             | `debian/stretch`           | Name of the base image used to build the Docker image
| `PHP_VERSION`                   | `8.1`                      | PHP version included in the image
