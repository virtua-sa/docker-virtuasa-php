#!/usr/bin/env bash
set -e

PHP_VERSION=$1

if ! [[ "${TRAVIS_BRANCH}" =~ master|develop ]]; then
    echo "Docker Login"
    docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
fi

echo "Start build for branch ${TRAVIS_BRANCH}"

if [ "${TRAVIS_BRANCH}" = 'master' ] ; then
    # build no push to dev
    di_disable_push=1 ./docker-build.sh ${PHP_VERSION}
    echo "Docker Push Production images.."
    ./docker-push.sh ${PHP_VERSION};
elif [ "${TRAVIS_BRANCH}" = 'develop' ] ; then
    # build and push to dev tag
    ./docker-build.sh ${PHP_VERSION}
else
    # build no push
    di_disable_push=1 ./docker-build.sh ${PHP_VERSION}
fi

echo "Finish build for branch ${TRAVIS_BRANCH}"

exit 0;
