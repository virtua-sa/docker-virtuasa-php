# Virtua Docker Container - PHP - CHANGELOG

## v1.2.0 - 20171103

* Metadata
  * Version: 1.2.0
  * Tags: `virtuasa/php:*-20171103`
  * Built on commit : [2a3d706a](https://gitlab.virtua.ch/ddev/tools-docker/commit/2a3d706af671a3437f20e6de9fb3e6a862170476)
* Changes
  * Changed: use Node.js upgraded from 6.9.1 to 8.9.0 LTS
  * Added: `behat`, `dbunit`, `phing`, `phpdoc`, `phploc`, `phpmetrics`

## v1.1.3 - 20171102

* Metadata
  * Version: 1.1.3
  * Tags: `virtuasa/php:*-20171102`
  * Built on commit : [b699ea1d](https://gitlab.virtua.ch/ddev/tools-docker/commit/b699ea1d0fb52c0283f8ec5b37366e965e6e7354)
* Changes
  * Fixed: no more warning on PHP 5.6 about php5-uprofiler (profiler.so missing)
  * Added: `pdepend`, `phpcbf`, `phpcpd`, `phpcs`, `phpmd`, `pm2`
  * Added: short hashcode of git commit used to build images is displayed on startup

## v1.1.2 - 20171026

* Metadata
  * Version: 1.1.2
  * Tags: `virtuasa/php:*-20171026`
  * Built on commit : [f84a27d7](https://gitlab.virtua.ch/ddev/tools-docker/commit/f84a27d7837a309e334603de621343c03934eb7c)
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
  * Built on commit : [a41e350f](https://gitlab.virtua.ch/ddev/tools-docker/commit/a41e350f9da31a6202a97ce9d1b595d9f52173db)
* Changes
  * Changed: installation files moved to `/setup`

## v1.1.0 - 20171023

* Metadata
  * Version: 1.1.0
  * Tags: `virtuasa/php:*-20171023`
  * Built on commit : [c058a980](https://gitlab.virtua.ch/ddev/tools-docker/commit/c058a9809eee884af7abe825efc15ef73493772a)
* Changes
  * Fixed: php5-snmp now works well on PHP 5.6
  * Fixed: php files are now correctly handled by Apache with PHP 5.5
  * Added: `DOCKER_CUSTOM_START` has now a default value: `docker-start.sh`
  * Improved: removed unnecessary files, so images are smaller
  * Improved: removed display of environment variables on startup, unless `DOCKER_DEBUG` is set
  * Improved: expose ports 80 (http), 443 (https) and 9000 (xdebug)

## v1.0.1 - 20171016

* Metadata
  * Version: 1.0.1
  * Tags: `virtuasa/php:*-20171016`
  * Built on commit : [abc50064](https://gitlab.virtua.ch/ddev/tools-docker/commit/abc500643e9fa2b33a3995704a3ba01da96b5dd0)
* Changes
  * Fixed: php7-snmp now works well on PHP 7.0, 7.1, 7.2
  * Changed: `DOCKER_HOST_GID` and `DOCKER_HOST_UID` are now empty by default, chown is only done when a value is assigned to both of them
  * Added: `DOCKER_CUSTOM_START` can contain the name of a script that will be executed just before Apache starts, usefull for custom file permissions

## v1.0.0 - 20171014

* Metadata
  * Version: 1.0.0
  * Tags: `virtuasa/php:*-20171014`
  * Built on commit : [ca14b473](https://gitlab.virtua.ch/ddev/tools-docker/commit/ca14b473dd475ca6462986ab174bac041afedf34)
* Changes
  * First public release