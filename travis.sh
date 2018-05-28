#!/usr/bin/env bash

PHP_VERSION=$1

di_disable_push=1 ./docker-build.sh ${PHP_VERSION}
RESULT=$?

if [ ${RESULT} -eq 0 ] || [ ${TRAVIS_BRANCH} -eq 'master' ] ; then
    echo "Docker Login"
    docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
    RESULT=$?

    if [ ${RESULT} -eq 0 ]  ; then
        echo "Docker Push Image.."
        ./docker-push.sh ${PHP_VERSION};
        RESULT=$?
    fi
fi

exit ${RESULT};
