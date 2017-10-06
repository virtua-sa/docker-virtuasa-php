#!/bin/bash

case "$1" in
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
*)
    echo "Not supported yet"
    exit 1;
    ;;
esac

docker build --tag virtuasa/php:${df_php_version} \
    --build-arg FROM_IMAGE=${df_from_image} \
    --build-arg PHP_VERSION=${df_php_version} \
    --build-arg PHP_VERSION_APT=${df_php_version_apt} \
    --build-arg PHP_VERSION_DIR=${df_php_version_dir} \
    --file setup/docker/Dockerfile .
