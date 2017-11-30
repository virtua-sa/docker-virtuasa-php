#!/bin/bash

docker ps -aq --filter "name=virtuasa/php:5.2-dev" | xargs -rn1 docker rm
docker ps -aq --filter "name=virtuasa/php:5.3-dev" | xargs -rn1 docker rm
docker ps -aq --filter "name=virtuasa/php:5.4-dev" | xargs -rn1 docker rm
docker ps -aq --filter "name=virtuasa/php:5.5-dev" | xargs -rn1 docker rm
docker ps -aq --filter "name=virtuasa/php:5.6-dev" | xargs -rn1 docker rm
docker ps -aq --filter "name=virtuasa/php:7.0-dev" | xargs -rn1 docker rm
docker ps -aq --filter "name=virtuasa/php:7.1-dev" | xargs -rn1 docker rm
docker ps -aq --filter "name=virtuasa/php:7.2-dev" | xargs -rn1 docker rm

docker images -q virtuasa/php:5.2-dev | xargs -rn1 docker rmi
docker images -q virtuasa/php:5.3-dev | xargs -rn1 docker rmi
docker images -q virtuasa/php:5.4-dev | xargs -rn1 docker rmi
docker images -q virtuasa/php:5.5-dev | xargs -rn1 docker rmi
docker images -q virtuasa/php:5.6-dev | xargs -rn1 docker rmi
docker images -q virtuasa/php:7.0-dev | xargs -rn1 docker rmi
docker images -q virtuasa/php:7.1-dev | xargs -rn1 docker rmi
docker images -q virtuasa/php:7.2-dev | xargs -rn1 docker rmi

docker system prune --volumes --force