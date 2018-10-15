#!/usr/bin/env bash

/setup/run/start.sh > /tmp/server-log.txt &

sleep 3

START_MSG=""

# Start web server
if [[ "${DOCKER_WEB_SERVER}" = "apache" ]]; then
    START_MSG='Started apache web server'
elif [[ "${DOCKER_WEB_SERVER}" = "nginx" ]]; then
    START_MSG='Started nginx web server'
fi

c=0
while ! grep -m1 "${START_MSG}" < /tmp/server-log.txt; do
    ((c++)) && ((c>120)) && break
    sleep 1
done

echo "Server ${DOCKER_WEB_SERVER} is up after ${c} seconds"

sleep 3
