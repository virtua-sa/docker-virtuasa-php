#!/bin/bash

# Make sure we stop building/pushing images if an error happens
set -e

# Configure the build accordingly to the requested PHP version
case "$1" in
5.2)
    df_from_image="debian/eol:lenny"
    df_php_version="5.2"
    df_php_version_apt="5"
    df_php_version_dir="5"
    ;;
5.3)
    df_from_image="debian/eol:squeeze"
    df_php_version="5.3"
    df_php_version_apt="5"
    df_php_version_dir="5"
    ;;
5.4)
    df_from_image="debian:wheezy"
    df_php_version="5.4"
    df_php_version_apt="5"
    df_php_version_dir="5"
    ;;
5.5)
    df_from_image="debian:wheezy"
    df_php_version="5.5"
    df_php_version_apt="5"
    df_php_version_dir="5"
    ;;
5.6)
    df_from_image="debian:jessie"
    df_php_version="5.6"
    df_php_version_apt="5"
    df_php_version_dir="5"
    ;;
7.0)
    df_from_image="debian:stretch"
    df_php_version="7.0"
    df_php_version_apt="7.0"
    df_php_version_dir="/7.0"
    ;;
7.1)
    df_from_image="debian:stretch"
    df_php_version="7.1"
    df_php_version_apt="7.1"
    df_php_version_dir="/7.1"
    ;;
7.2)
    df_from_image="debian:stretch"
    df_php_version="7.2"
    df_php_version_apt="7.2"
    df_php_version_dir="/7.2"
    ;;
all)
    di_disable_push="${di_disable_push}" $0 5.2
    di_disable_push="${di_disable_push}" $0 5.3
    di_disable_push="${di_disable_push}" $0 5.4
    di_disable_push="${di_disable_push}" $0 5.5
    di_disable_push="${di_disable_push}" $0 5.6
    di_disable_push="${di_disable_push}" $0 7.0
    di_disable_push="${di_disable_push}" $0 7.1
    di_disable_push="${di_disable_push}" $0 7.2
    exit 0;
    ;;
*)
    echo "Not supported yet"
    exit 1;
    ;;
esac

# Display build info
echo "df_from_image='${df_from_image}'"
echo "df_php_version=${df_php_version}"
echo "df_php_version_apt=${df_php_version_apt}"
echo "df_php_version_dir=${df_php_version_dir}"

# Build the image and tag it
docker build --tag virtuasa/php:${df_php_version}-dev \
    --build-arg DOCKER_FROM_COMMIT=$(git log --pretty=format:'%h' -n 1) \
    --build-arg FROM_IMAGE=${df_from_image} \
    --build-arg PHP_VERSION=${df_php_version} \
    --build-arg PHP_VERSION_APT=${df_php_version_apt} \
    --build-arg PHP_VERSION_DIR=${df_php_version_dir} \
    --file setup/docker/Dockerfile .

# Test the image built with Apache
rm -rf tests/tmp${df_php_version}
cp -r tests/src tests/tmp${df_php_version}
chmod 775 tests/tmp${df_php_version}
docker ps | grep "virtuasa-php-${df_php_version}-dev-build" > /dev/null && docker stop virtuasa-php-${df_php_version}-dev-build
docker ps -a | grep "virtuasa-php-${df_php_version}-dev-build" > /dev/null && docker rm virtuasa-php-${df_php_version}-dev-build
docker run -d -v `pwd`/tests/tmp${df_php_version}:/data \
    --name virtuasa-php-${df_php_version}-dev-build \
    --env DOCKER_CHMOD_666="read.txt" \
    --env DOCKER_CHMOD_777="." \
    --env DOCKER_DEBUG=1 \
    --env DOCKER_HOST_GID=$(id -g) \
    --env DOCKER_HOST_UID=$(id -u) \
    --env DOCKER_WEB_SERVER="apache" \
    virtuasa/php:${df_php_version}-dev
# docker attach --no-stdin virtuasa-php-${df_php_version}-dev-build
sleep 10s
docker exec virtuasa-php-${df_php_version}-dev-build ls || docker logs -t virtuasa-php-${df_php_version}-dev-build
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build pwd)"
[[ "${di_check}" != "/data" ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build whoami)"
[[ "${di_check}" != "docker" ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
docker exec virtuasa-php-${df_php_version}-dev-build ls -alhR
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build php web/test-io.php)"
[[ ! "${di_check}" =~ ^S+$ ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
di_check="$(curl -sSL "http://$(docker inspect virtuasa-php-${df_php_version}-dev-build | jq '.[].NetworkSettings.Networks.bridge.IPAddress' | sed 's/"//g')/test-io.php")"
[[ ! "${di_check}" =~ ^S+$ ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
docker stop virtuasa-php-${df_php_version}-dev-build
docker logs -t virtuasa-php-${df_php_version}-dev-build
docker rm virtuasa-php-${df_php_version}-dev-build
rm -rf tests/tmp${df_php_version}

# Test the image built with Nginx
rm -rf tests/tmp${df_php_version}
cp -r tests/src tests/tmp${df_php_version}
chmod 775 tests/tmp${df_php_version}
docker ps | grep "virtuasa-php-${df_php_version}-dev-build" > /dev/null && docker stop virtuasa-php-${df_php_version}-dev-build
docker ps -a | grep "virtuasa-php-${df_php_version}-dev-build" > /dev/null && docker rm virtuasa-php-${df_php_version}-dev-build
docker run -d -v `pwd`/tests/tmp${df_php_version}:/data \
    --name virtuasa-php-${df_php_version}-dev-build \
    --env DOCKER_CHMOD_666="read.txt" \
    --env DOCKER_CHMOD_777="." \
    --env DOCKER_DEBUG=1 \
    --env DOCKER_HOST_GID=$(id -g) \
    --env DOCKER_HOST_UID=$(id -u) \
    --env DOCKER_WEB_SERVER="nginx" \
    virtuasa/php:${df_php_version}-dev
# docker attach --no-stdin virtuasa-php-${df_php_version}-dev-build
sleep 10s
docker exec virtuasa-php-${df_php_version}-dev-build ls || docker logs -t virtuasa-php-${df_php_version}-dev-build
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build pwd)"
[[ "${di_check}" != "/data" ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build whoami)"
[[ "${di_check}" != "docker" ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
docker exec virtuasa-php-${df_php_version}-dev-build ls -alhR
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build php web/test-io.php)"
[[ ! "${di_check}" =~ ^S+$ ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
di_check="$(curl -sSL "http://$(docker inspect virtuasa-php-${df_php_version}-dev-build | jq '.[].NetworkSettings.Networks.bridge.IPAddress' | sed 's/"//g')/test-io.php")"
[[ ! "${di_check}" =~ ^S+$ ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
docker stop virtuasa-php-${df_php_version}-dev-build
docker logs -t virtuasa-php-${df_php_version}-dev-build
docker rm virtuasa-php-${df_php_version}-dev-build
rm -rf tests/tmp${df_php_version}

# Push the image to Docker Hub
[[ -z "${di_disable_push}" ]] && docker push virtuasa/php:${df_php_version}-dev

exit 0;