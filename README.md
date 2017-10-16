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