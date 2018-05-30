#!/usr/bin/env bash

PHP_VERSION=$1

echo "Docker Login"
docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"

echo "Start build for branch ${TRAVIS_BRANCH}"

if [ "${TRAVIS_BRANCH}" = 'master' ] ; then
    # build no push
    di_disable_push=1 ./docker-build.sh ${PHP_VERSION}
    RESULT=$?

    if [ ${RESULT} -eq 0 ]  ; then
        echo "Docker Push Production images.."
        ./docker-push.sh ${PHP_VERSION};
        RESULT=$?
    fi
elif [ "${TRAVIS_BRANCH}" = 'develop' ] ; then
    # build and push to dev tag
    ./docker-build.sh ${PHP_VERSION}
    RESULT=$?
else
    # build no push
    di_disable_push=1 ./docker-build.sh ${PHP_VERSION}
    RESULT=$?
fi

echo "Finish build for branch :${TRAVIS_BRANCH}"

exit ${RESULT};
