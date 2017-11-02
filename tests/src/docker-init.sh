#!/bin/bash
echo "docker-init.sh called !"

[[ -n "$(type -t php)" ]]       && php -v
[[ -n "$(type -t composer)" ]]  && composer --version
[[ -n "$(type -t phpunit62)" ]] && phpunit62 --version
[[ -n "$(type -t phpunit57)" ]] && phpunit57 --version
[[ -n "$(type -t phpunit48)" ]] && phpunit48 --version
[[ -n "$(type -t phpcs)" ]]     && phpcs --version
[[ -n "$(type -t phpcbf)" ]]    && phpcbf --version
[[ -n "$(type -t pdepend)" ]]   && pdepend --version
[[ -n "$(type -t phpmd)" ]]     && phpmd --version
[[ -n "$(type -t phpcpd)" ]]    && phpcpd --version

[[ -n "$(type -t node)" ]]      && echo -n "Node.js " && node -v
[[ -n "$(type -t npm)" ]]       && echo -n "NPM v" && npm -v