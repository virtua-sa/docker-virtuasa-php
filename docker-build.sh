#!/usr/bin/env bash

# Make sure we stop building/pushing images if an error happens
set -xe

# Configure the build accordingly to the requested PHP version
case "$1" in
7.0)
    df_from_image="debian:buster"
    df_from_distribution="debian"
    df_from_version="buster"
    df_php_version="7.0"
    df_php_version_apt="7.0"
    df_php_version_dir="/7.0"
    ;;
7.1)
    df_from_image="debian:buster"
    df_from_distribution="debian"
    df_from_version="buster"
    df_php_version="7.1"
    df_php_version_apt="7.1"
    df_php_version_dir="/7.1"
    ;;
7.2)
    df_from_image="debian:buster"
    df_from_distribution="debian"
    df_from_version="buster"
    df_php_version="7.2"
    df_php_version_apt="7.2"
    df_php_version_dir="/7.2"
    ;;
7.3)
    df_from_image="debian:buster"
    df_from_distribution="debian"
    df_from_version="buster"
    df_php_version="7.3"
    df_php_version_apt="7.3"
    df_php_version_dir="/7.3"
    ;;
7.4)
    df_from_image="debian:buster"
    df_from_distribution="debian"
    df_from_version="buster"
    df_php_version="7.4"
    df_php_version_apt="7.4"
    df_php_version_dir="/7.4"
    ;;
8.0)
    df_from_image="debian:buster"
    df_from_distribution="debian"
    df_from_version="buster"
    df_php_version="8.0"
    df_php_version_apt="8.0"
    df_php_version_dir="/8.0"
    ;;
8.1)
    df_from_image="debian:buster"
    df_from_distribution="debian"
    df_from_version="buster"
    df_php_version="8.1"
    df_php_version_apt="8.1"
    df_php_version_dir="/8.1"
    ;;
all)
    $0 7.0
    $0 7.1
    $0 7.2
    $0 7.3
    $0 7.4
    $0 8.0
    $0 8.1
    exit 0;
    ;;
*)
    echo "Not supported yet"
    exit 1;
    ;;
esac

rm -Rf setup/tmp
mkdir -p setup/tmp

# Run distribution version hook
if [ -f "./setup/docker/${df_from_distribution}/master-build.d/${df_from_distribution}-${df_from_version}.sh" ]; then
   ./setup/docker/${df_from_distribution}/master-build.d/${df_from_distribution}-${df_from_version}.sh || exit 1
fi
# Run php version hook
if [ -f "/setup/docker/${df_from_distribution}/master-build.d/php-${df_php_version}.sh" ]; then
   ./setup/docker/${df_from_distribution}/master-build.d/php-${df_php_version}.sh || exit 1
fi

# Display build info
echo "df_from_image='${df_from_image}'"
echo "df_from_distribution='${df_from_distribution}'"
echo "df_from_version='${df_from_version}'"
echo "df_php_version=${df_php_version}"
echo "df_php_version_apt=${df_php_version_apt}"
echo "df_php_version_dir=${df_php_version_dir}"

# Log all build details
db_build_date="$(date --iso-8601=seconds)"
db_build_path="builds/${df_php_version}-$(date +%Y%m%d)"
rm -rf ${db_build_path} || sudo rm -rf ${db_build_path}
mkdir -p ${db_build_path}

# Build the image and tag it
cat <<"EOF"
  ____        _ _     _
 | __ ) _   _(_) | __| |
 |  _ \| | | | | |/ _` |
 | |_) | |_| | | | (_| |
 |____/ \__,_|_|_|\__,_|
EOF

docker build --tag virtuasa/php:${df_php_version}-dev \
    --build-arg DOCKER_BUILD_DATE="${db_build_date}" \
    --build-arg DOCKER_FROM_COMMIT=$(git log --pretty=format:'%h' -n 1) \
    --build-arg FROM_IMAGE=${df_from_image} \
    --build-arg FROM_DISTRIBUTION=${df_from_distribution} \
    --build-arg FROM_VERSION=${df_from_version} \
    --build-arg PHP_VERSION=${df_php_version} \
    --build-arg PHP_VERSION_APT=${df_php_version_apt} \
    --build-arg PHP_VERSION_DIR=${df_php_version_dir} \
    --build-arg GITHUB_TOKEN=${GITHUB_TOKEN} \
    --file setup/docker/Dockerfile . | tee ${db_build_path}/build.log
grep -q "Successfully tagged virtuasa/php:${df_php_version}-dev" ${db_build_path}/build.log || exit 1;

copyTestSrc() {
    rm -rf tests/tmp${1} > /dev/null 2>&1 || sudo rm -rf tests/tmp${1}
    cp -r tests/src tests/tmp${1}
    if [ -d "tests/src.d/${1}/" ]; then
       cp -r tests/src.d/${1}/* tests/tmp${1}/
    fi
    chmod -R a+rwX tests/tmp${1}
}

err_docker_log() {
    echo "FINISH WITH ERROR !!!"
    # docker logs virtuasa-php-${df_php_version}-dev-build
}
trap 'err_docker_log' ERR

# Test the image built with Apache
cat <<"EOF"
  _____         _                _                     _
 |_   _|__  ___| |_             / \   _ __   __ _  ___| |__   ___
   | |/ _ \/ __| __|  _____    / _ \ | '_ \ / _` |/ __| '_ \ / _ \
   | |  __/\__ \ |_  |_____|  / ___ \| |_) | (_| | (__| | | |  __/
   |_|\___||___/\__|         /_/   \_\ .__/ \__,_|\___|_| |_|\___|
                                     |_|
EOF
copyTestSrc ${df_php_version}
docker ps | grep "virtuasa-php-${df_php_version}-dev-build" > /dev/null && docker stop virtuasa-php-${df_php_version}-dev-build
docker ps -a | grep "virtuasa-php-${df_php_version}-dev-build" > /dev/null && docker rm virtuasa-php-${df_php_version}-dev-build
docker run -d -v `pwd`/tests/tmp${df_php_version}:/data \
    --name virtuasa-php-${df_php_version}-dev-build \
    --env DOCKER_CHMOD_666="read.txt" \
    --env DOCKER_CHMOD_777="." \
    --env DOCKER_COPY_CONFIG_FROM_HOST="true" \
    --env DOCKER_COPY_CONFIG_TO_HOST="true" \
    --env DOCKER_DEBUG=1 \
    --env DOCKER_WEB_SERVER="apache" \
    --env HOSTNAME_LOCAL_ALIAS="alias1.test,alias2.test" \
    --env SMTP_MAILHUB="smtp.docker" \
    virtuasa/php:${df_php_version}-dev
sleep 20s
docker logs -t virtuasa-php-${df_php_version}-dev-build > ${db_build_path}/run-apache.log 2>&1
cp -r tests/tmp${df_php_version}/setup ${db_build_path}/setup
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build pwd)"
[[ "${di_check}" != "/data" ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build whoami)"
[[ "${di_check}" != "docker" ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
docker exec virtuasa-php-${df_php_version}-dev-build ls -alhR > ${db_build_path}/ls-data.log || docker logs -t virtuasa-php-${df_php_version}-dev-build
docker exec virtuasa-php-${df_php_version}-dev-build ls -alhR /setup > ${db_build_path}/ls-setup.log || docker logs -t virtuasa-php-${df_php_version}-dev-build
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build php web/test-io.php)"
[[ ! "${di_check}" =~ ^S+$ ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
di_check="$(curl -sSL "http://$(docker inspect virtuasa-php-${df_php_version}-dev-build | jq '.[].NetworkSettings.Networks.bridge.IPAddress' | sed 's/"//g')/test-io.php")"
[[ ! "${di_check}" =~ ^S+$ ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
docker exec virtuasa-php-${df_php_version}-dev-build php web/phpinfo.php > ${db_build_path}/phpinfo-cli.log || docker logs -t virtuasa-php-${df_php_version}-dev-build
curl -sSL "http://$(docker inspect virtuasa-php-${df_php_version}-dev-build | jq '.[].NetworkSettings.Networks.bridge.IPAddress' | sed 's/"//g')/phpinfo.php" > ${db_build_path}/phpinfo-apache.log || docker logs -t virtuasa-php-${df_php_version}-dev-build
docker exec virtuasa-php-${df_php_version}-dev-build sudo apt list --installed > ${db_build_path}/apt.log || docker exec virtuasa-php-${df_php_version}-dev-build sudo dpkg --get-selections | grep -v deinstall > ${db_build_path}/dpkg.log
# Run distribution version hook
if [ -f "${BASE_PATH}/build.d/debian-${FROM_VERSION}.sh" ]; then
   ${BASE_PATH}/build.d/debian-${FROM_VERSION}.sh || exit 1
fi

docker exec virtuasa-php-${df_php_version}-dev-build php /usr/local/bin/composer install
docker exec virtuasa-php-${df_php_version}-dev-build php /usr/local/bin/composer check-platform-reqs

docker stop virtuasa-php-${df_php_version}-dev-build
docker logs -t virtuasa-php-${df_php_version}-dev-build  2>&1 > ${db_build_path}/run-apache.log
docker rm virtuasa-php-${df_php_version}-dev-build
# Test
grep -q "localhost alias1.test alias2.test" ${db_build_path}/setup/etc/hosts || (echo  "HOSTNAME_LOCAL_ALIAS not working" ; exit 1;)

# Test the image built with Apache without DEBUG
cat <<"EOF"
  _____         _                _                     _           __        _______    ____  ____   ____
 |_   _|__  ___| |_             / \   _ __   __ _  ___| |__   ___  \ \      / / / _ \  |  _ \| __ ) / ___|
   | |/ _ \/ __| __|  _____    / _ \ | '_ \ / _` |/ __| '_ \ / _ \  \ \ /\ / / / | | | | | | |  _ \| |  _
   | |  __/\__ \ |_  |_____|  / ___ \| |_) | (_| | (__| | | |  __/   \ V  V / /| |_| | | |_| | |_) | |_| |
   |_|\___||___/\__|         /_/   \_\ .__/ \__,_|\___|_| |_|\___|    \_/\_/_/  \___/  |____/|____/ \____|
                                     |_|
EOF
copyTestSrc ${df_php_version}
docker ps | grep "virtuasa-php-${df_php_version}-dev-build" > /dev/null && docker stop virtuasa-php-${df_php_version}-dev-build
docker ps -a | grep "virtuasa-php-${df_php_version}-dev-build" > /dev/null && docker rm virtuasa-php-${df_php_version}-dev-build
docker run -d -v `pwd`/tests/tmp${df_php_version}:/data \
    --name virtuasa-php-${df_php_version}-dev-build \
    --env DOCKER_CHMOD_666="read.txt" \
    --env DOCKER_CHMOD_777="." \
    --env DOCKER_WEB_SERVER="apache" \
    virtuasa/php:${df_php_version}-dev
sleep 20s
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build pwd)"
[[ "${di_check}" != "/data" ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build whoami)"
[[ "${di_check}" != "docker" ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
di_check="$(docker exec virtuasa-php-${df_php_version}-dev-build php web/test-io.php)"
[[ ! "${di_check}" =~ ^S+$ ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
di_check="$(curl -sSL "http://$(docker inspect virtuasa-php-${df_php_version}-dev-build | jq '.[].NetworkSettings.Networks.bridge.IPAddress' | sed 's/"//g')/test-io.php")"
[[ ! "${di_check}" =~ ^S+$ ]] && echo "${LINE_NO} Unexpected value: ${di_check}" && exit 1;
docker stop virtuasa-php-${df_php_version}-dev-build
docker rm virtuasa-php-${df_php_version}-dev-build

# Test the image built with Nginx
cat <<"EOF"
  _____         _             _   _  ____ ___ _   ___  __
 |_   _|__  ___| |_          | \ | |/ ___|_ _| \ | \ \/ /
   | |/ _ \/ __| __|  _____  |  \| | |  _ | ||  \| |\  /
   | |  __/\__ \ |_  |_____| | |\  | |_| || || |\  |/  \
   |_|\___||___/\__|         |_| \_|\____|___|_| \_/_/\_\
EOF
copyTestSrc ${df_php_version}
docker ps | grep "virtuasa-php-${df_php_version}-dev-build" > /dev/null && docker stop virtuasa-php-${df_php_version}-dev-build
docker ps -a | grep "virtuasa-php-${df_php_version}-dev-build" > /dev/null && docker rm virtuasa-php-${df_php_version}-dev-build
docker run -d -v `pwd`/tests/tmp${df_php_version}:/data \
    --name virtuasa-php-${df_php_version}-dev-build \
    --env DOCKER_CHMOD_666="read.txt" \
    --env DOCKER_CHMOD_777="." \
    --env DOCKER_DEBUG=1 \
    --env DOCKER_WEB_SERVER="nginx" \
    virtuasa/php:${df_php_version}-dev
sleep 20s
docker logs -t virtuasa-php-${df_php_version}-dev-build > ${db_build_path}/run-nginx.log 2>&1
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
curl -sSL "http://$(docker inspect virtuasa-php-${df_php_version}-dev-build | jq '.[].NetworkSettings.Networks.bridge.IPAddress' | sed 's/"//g')/phpinfo.php" > ${db_build_path}/phpinfo-nginx.log
docker exec virtuasa-php-${df_php_version}-dev-build sudo chown -R docker:docker /data
docker stop virtuasa-php-${df_php_version}-dev-build
docker logs -t virtuasa-php-${df_php_version}-dev-build > ${db_build_path}/run-nginx.log
docker rm virtuasa-php-${df_php_version}-dev-build
rm -rf tests/tmp${df_php_version} > /dev/null 2>&1 || sudo rm -rf tests/tmp${df_php_version}

echo "Build finished :-)"

exit 0;
