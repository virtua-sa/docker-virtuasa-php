# Virtua Docker Container - PHP - CHANGELOG

## V1.3.8 - 20180108

* Metadata
  * Version: 1.3.8
  * Tags: `virtuasa/php:*-20180108`
  * Built on commit : [](https://gitlab.virtua.ch/docker/virtuasa-php/tree/)
* Changes
  * Added: PHP versions upgraded: 5.6.33, 7.0.27, 7.1.13, 7.2.1

## V1.3.7 - 20171213

* Metadata
  * Version: 1.3.7
  * Tags: `virtuasa/php:*-20171213`
  * Built on commit : [3b0cf86d](https://gitlab.virtua.ch/docker/virtuasa-php/tree/3b0cf86d818126fc02e6223a4058cb6d75455c44)
* Changes
  * Added: `DOCKER_MKDIR` to recursively create folders on start
  * Added: Labels compliant to http://label-schema.org/rc1/

## V1.3.6 - 20171208

* Metadata
  * Version: 1.3.6
  * Tags: `virtuasa/php:*-20171208`
  * Built on commit : [31849eea](https://gitlab.virtua.ch/docker/virtuasa-php/tree/31849eea9a7a99633c3e8bd81a27e35d51a99d27)
* Changes
  * Added: Ruby and Capistrano for PHP 5.6, 7.0, 7.1, 7.2

## V1.3.5 - 20171204

* Metadata
  * Version: 1.3.5
  * Tags: `virtuasa/php:*-20171204`
  * Built on commit : [0a1209e2](https://gitlab.virtua.ch/docker/virtuasa-php/tree/0a1209e2890aa0229821babb381804d1ade98b83)
* Changes
  * Added: Nginx is now working and can be selected with `DOCKER_WEB_SERVER=nginx` on PHP 7.0, 7.1, 7.2
  * Added: `sendmail` package
  * Updated: PHP 7.0 is now final

## V1.3.4 - 20171130

* Metadata
  * Version: 1.3.4
  * Tags: `virtuasa/php:*-20171130`
  * Built on commit : [1cf333d9](https://gitlab.virtua.ch/docker/virtuasa-php/tree/1cf333d97a90cb9b25d939e6527be2f584dac89c)
* Changes
  * Changed: Use real structure of tool configuration files instead of the old flat one
  * Fixed: Split PHP configuration files between apache, cli, fpm

## V1.3.3 - 20171129

* Metadata
  * Version: 1.3.3
  * Tags: `virtuasa/php:*-20171129`
  * Built on commit : [d5475ca0](https://gitlab.virtua.ch/docker/virtuasa-php/tree/d5475ca00f9d7423c9373629b3e3f4ba52c7adcf)
* Changes
  * Improved: More tests on images
  * Fixed: Images can work with and without debug mode
  * Fixed: Copy config to host works on PHP 5.2, but it overrides existing files

## V1.3.2 - 20171128

* Metadata
  * Version: 1.3.2
  * Tags: `virtuasa/php:*-20171128`
  * Built on commit : [b4bd8651](https://gitlab.virtua.ch/docker/virtuasa-php/tree/b4bd86513ef741a1df537cecb7b2d654e6160fb5)
* Changes
  * Fixed: `PHP_MEMORY_LIMIT_APACHE`, `PHP_MEMORY_LIMIT_CLI` are now always used by PHP
  * Fixed: No more issue when copying configuration files to / from host
  * Improved: Web server check to use is done before calling custom init script, so it can be overriden
  * Improved: Use templates for PHP configuration files too

## V1.3.1 - 20171126

* Metadata
  * Version: 1.3.1
  * Tags: `virtuasa/php:*-20171126`
  * Built on commit : [fcf7fc3b](https://gitlab.virtua.ch/docker/virtuasa-php/tree/fcf7fc3b45bdeabe3b217013128f52eb1becb87c)
* Changes
  * Added: `PHP_MEMORY_LIMIT_APACHE`, `PHP_MEMORY_LIMIT_CLI` to set maximum memory a PHP script may consumes
  * Removed: `APACHE_LOG_DIR` environment variable (use same path as `APACHE_LOG_PATH`)

## v1.3.0 - 20171123

* Metadata
  * Version: 1.3.0
  * Tags: `virtuasa/php:*-20171123`
  * Built on commit : [03de4045](https://gitlab.virtua.ch/docker/virtuasa-php/tree/03de4045f49660e279bed14a26b42ed946767e26)
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
  * Built on commit : [53312599](https://gitlab.virtua.ch/docker/virtuasa-php/tree/53312599c2af78cacedff62564ca58ea261b2fd6)
* Changes
  * Changed: use Node.js upgraded from 6.9.1 to 8.9.0 LTS
  * Added: `behat`, `dbunit`, `phing`, `phpdoc`, `phploc`, `phpmetrics`

## v1.1.3 - 20171102

* Metadata
  * Version: 1.1.3
  * Tags: `virtuasa/php:*-20171102`
  * Built on commit : [2976a595](https://gitlab.virtua.ch/docker/virtuasa-php/tree/2976a59513035a3dcdd69f8afa531d692800a5cc)
* Changes
  * Fixed: no more warning on PHP 5.6 about `php5-uprofiler` (`profiler.so` missing)
  * Added: `pdepend`, `phpcbf`, `phpcpd`, `phpcs`, `phpmd`, `pm2`
  * Added: short hashcode of git commit used to build images is displayed on startup

## v1.1.2 - 20171026

* Metadata
  * Version: 1.1.2
  * Tags: `virtuasa/php:*-20171026`
  * Built on commit : [3a20b13c](https://gitlab.virtua.ch/docker/virtuasa-php/tree/3a20b13cb4e128189e8e73e6f01bfc707d210de9)
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
  * Built on commit : [d625fa8d](https://gitlab.virtua.ch/docker/virtuasa-php/tree/d625fa8d3e671dc8a0dc83f26cbd238d50f2f05b)
* Changes
  * Changed: installation files moved to `/setup`

## v1.1.0 - 20171023

* Metadata
  * Version: 1.1.0
  * Tags: `virtuasa/php:*-20171023`
  * Built on commit : [0f5dbd79](https://gitlab.virtua.ch/docker/virtuasa-php/tree/0f5dbd79051c4f7af3c990c91f947c2fe53b6e38)
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
  * Built on commit : [8e38c1a3](https://gitlab.virtua.ch/docker/virtuasa-php/tree/8e38c1a37667c1ffd3e22eb4da591bc80fc64a01)
* Changes
  * Fixed: `php7-snmp` now works well on PHP 7.0, 7.1, 7.2
  * Changed: `DOCKER_HOST_GID` and `DOCKER_HOST_UID` are now empty by default, chown is only done when a value is assigned to both of them
  * Added: `DOCKER_CUSTOM_START` can contain the name of a script that will be executed just before Apache starts, usefull for custom file permissions

## v1.0.0 - 20171014

* Metadata
  * Version: 1.0.0
  * Tags: `virtuasa/php:*-20171014`
  * Built on commit : [3c9715e5](https://gitlab.virtua.ch/docker/virtuasa-php/tree/3c9715e56bb76e72c71c8cd435208626e1862e92)
* Changes
  * First public release