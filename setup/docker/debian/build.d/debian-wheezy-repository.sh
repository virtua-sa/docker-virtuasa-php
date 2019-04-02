#!/usr/bin/env bash
set -xe

cat <<EOT > /etc/apt/sources.list
deb http://archive.debian.org/debian wheezy main contrib non-free
deb http://security.debian.org/debian-security wheezy/updates main
EOT
