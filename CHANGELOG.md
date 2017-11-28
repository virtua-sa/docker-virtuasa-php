# Virtua Docker Container - PHP - CHANGELOG

## V1.3.2 - 20171128

* Metadata
  * Version: 1.3.2
  * Tags: `virtuasa/php:*-20171128`
  * Built on commit : [7ad43e8a](https://gitlab.virtua.ch/ddev/tools-docker/tree/7ad43e8a8d70b90a9fab3759597a6d74752ea2d0/images/php)
* Changes
  * Fixed: `PHP_MEMORY_LIMIT_APACHE`, `PHP_MEMORY_LIMIT_CLI` are now always used by PHP
  * Fixed: No more issue when copying configuration files to / from host
  * Improved: Web server check to use is done before calling custom init script, so it can be overriden

## V1.3.1 - 20171126

* Metadata
  * Version: 1.3.1
  * Tags: `virtuasa/php:*-20171126`
  * Built on commit : [b9e9ada0](https://gitlab.virtua.ch/ddev/tools-docker/tree/b9e9ada0a8eb71f4d464c191ba1866256c7ed123/images/php)
* Changes
  * Added: `PHP_MEMORY_LIMIT_APACHE`, `PHP_MEMORY_LIMIT_CLI` to set maximum memory a PHP script may consumes
  * Removed: `APACHE_LOG_DIR` environment variable (use same path as `APACHE_LOG_PATH`)

## v1.3.0 - 20171123

* Metadata
  * Version: 1.3.0
  * Tags: `virtuasa/php:*-20171123`
  * Built on commit : [7b8e62d1](https://gitlab.virtua.ch/ddev/tools-docker/tree/7b8e62d15e1043aa6a5b3cfba265ecd57c58c6f6/images/php)
* Changes
  * Fixed: no more issues when exporting environment variables to Apache
  * Added: ability to use Nginx instead of Apache (experimental)
  * Added: `envsubst`, `unzip` packages
  * Added: `DOCKER_CUSTOM_STOP` to run script on shutting down
  * Improved: declare volume in `Dockerfile`
  * Improved: `DOCKER_BASE_DIR` now changes working directory too
  * Improved: file permissions are now reset on shutting down too
  * Removed: `phing`, `pdepends` for PHP 5.2
  * Removed: `behat`, `phpdoc` for PHP 5.3
  * Removed: `behat` for PHP 5.4

## v1.2.0 - 20171103

* Metadata
  * Version: 1.2.0
  * Tags: `virtuasa/php:*-20171103`
  * Built on commit : [2a3d706a](https://gitlab.virtua.ch/ddev/tools-docker/tree/2a3d706af671a3437f20e6de9fb3e6a862170476/images/php)
* Changes
  * Changed: use Node.js upgraded from 6.9.1 to 8.9.0 LTS
  * Added: `behat`, `dbunit`, `phing`, `phpdoc`, `phploc`, `phpmetrics`

## v1.1.3 - 20171102

* Metadata
  * Version: 1.1.3
  * Tags: `virtuasa/php:*-20171102`
  * Built on commit : [b699ea1d](https://gitlab.virtua.ch/ddev/tools-docker/tree/b699ea1d0fb52c0283f8ec5b37366e965e6e7354/images/php)
* Changes
  * Fixed: no more warning on PHP 5.6 about `php5-uprofiler` (`profiler.so` missing)
  * Added: `pdepend`, `phpcbf`, `phpcpd`, `phpcs`, `phpmd`, `pm2`
  * Added: short hashcode of git commit used to build images is displayed on startup

## v1.1.2 - 20171026

* Metadata
  * Version: 1.1.2
  * Tags: `virtuasa/php:*-20171026`
  * Built on commit : [f84a27d7](https://gitlab.virtua.ch/ddev/tools-docker/tree/f84a27d7837a309e334603de621343c03934eb7c/images/php)
* Changes
  * Added: `DOCKER_CUSTOM_INIT` environment variable to execute a script at initialization
  * Added: `DOCKER_CHMOD_R666` environment variable to `chmod -R 666` specified files
  * Added: `DOCKER_CHMOD_R777` environment variable to `chmod -R 777` specified files
  * Added: `DOCKER_CHMOD_666` environment variable to `chmod 666` specified files
  * Added: `DOCKER_CHMOD_777` environment variable to `chmod 777` specified files

## v1.1.1 - 20171025

* Metadata
  * Version: 1.1.1
  * Tags: `virtuasa/php:*-20171025`
  * Built on commit : [a41e350f](https://gitlab.virtua.ch/ddev/tools-docker/tree/a41e350f9da31a6202a97ce9d1b595d9f52173db/images/php)
* Changes
  * Changed: installation files moved to `/setup`

## v1.1.0 - 20171023

* Metadata
  * Version: 1.1.0
  * Tags: `virtuasa/php:*-20171023`
  * Built on commit : [c058a980](https://gitlab.virtua.ch/ddev/tools-docker/tree/c058a9809eee884af7abe825efc15ef73493772a/images/php)
* Changes
  * Fixed: php5-snmp now works well on PHP 5.6
  * Fixed: php files are now correctly handled by Apache with PHP 5.5
  * Added: `DOCKER_CUSTOM_START` has now a default value: `docker-start.sh`
  * Improved: removed unnecessary files, so images are smaller
  * Improved: removed display of environment variables on startup, unless `DOCKER_DEBUG` is set
  * Improved: expose ports 80 (http), 443 (https) and 9000 (xdebug) in `Dockerfile`

## v1.0.1 - 20171016

* Metadata
  * Version: 1.0.1
  * Tags: `virtuasa/php:*-20171016`
  * Built on commit : [abc50064](https://gitlab.virtua.ch/ddev/tools-docker/tree/abc500643e9fa2b33a3995704a3ba01da96b5dd0/images/php)
* Changes
  * Fixed: `php7-snmp` now works well on PHP 7.0, 7.1, 7.2
  * Changed: `DOCKER_HOST_GID` and `DOCKER_HOST_UID` are now empty by default, chown is only done when a value is assigned to both of them
  * Added: `DOCKER_CUSTOM_START` can contain the name of a script that will be executed just before Apache starts, usefull for custom file permissions

## v1.0.0 - 20171014

* Metadata
  * Version: 1.0.0
  * Tags: `virtuasa/php:*-20171014`
  * Built on commit : [ca14b473](https://gitlab.virtua.ch/ddev/tools-docker/tree/ca14b473dd475ca6462986ab174bac041afedf34/images/php)
* Changes
  * First public release