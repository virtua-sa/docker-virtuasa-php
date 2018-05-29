#!/usr/bin/env bash

PHP_VERSION=$1

echo "Docker Login"
docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}

if [ ${TRAVIS_BRANCH} -eq 'master' ] ; then
    # build no push
    di_disable_push=1 ./docker-build.sh ${PHP_VERSION}
    RESULT=$?

    if [ ${RESULT} -eq 0 ]  ; then
        echo "Docker Push Image.."
        ./docker-push.sh ${PHP_VERSION};
        RESULT=$?
    fi
elif [ ${TRAVIS_BRANCH} -eq 'develop' ] ; then
    # build and push to dev tag
    ./docker-build.sh ${PHP_VERSION}
    RESULT=$?
else
    # build no push
    di_disable_push=1 ./docker-build.sh ${PHP_VERSION}
    RESULT=$?
fi

exit ${RESULT};
