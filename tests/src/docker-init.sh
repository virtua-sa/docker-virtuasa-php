#!/bin/bash
echo "docker-init.sh called !"

[[ -n "$(type -t php)" ]]           && php -v
[[ -n "$(type -t behat)" ]]         && behat --version
[[ -n "$(type -t composer)" ]]      && composer --version
# [[ -n "$(type -t dbunit)" ]]        && dbunit --version
[[ -n "$(type -t pdepend)" ]]       && pdepend --version
[[ -n "$(type -t phing)" ]]         && phing -version
[[ -n "$(type -t phpcbf)" ]]        && phpcbf --version
[[ -n "$(type -t phpcpd)" ]]        && phpcpd --version
[[ -n "$(type -t phpcs)" ]]         && phpcs --version
[[ -n "$(type -t phpdoc)" ]]        && phpdoc --version
[[ -n "$(type -t phploc)" ]]        && phploc --version
[[ -n "$(type -t phpmetrics)" ]]    && phpmetrics --version
[[ -n "$(type -t phpmd)" ]]         && phpmd --version
[[ -n "$(type -t phpunit)" ]]       && phpunit --version
[[ -n "$(type -t phpunit48)" ]]     && phpunit48 --version
[[ -n "$(type -t phpunit57)" ]]     && phpunit57 --version
[[ -n "$(type -t phpunit62)" ]]     && phpunit62 --version

[[ -n "$(type -t node)" ]]          && echo -n "Node.js " && node -v
[[ -n "$(type -t npm)" ]]           && echo -n "NPM " && npm -v
[[ -n "$(type -t bower)" ]]         && echo -n "bower " && bower --version
[[ -n "$(type -t grunt)" ]]         && echo -n "grunt " && grunt --version
[[ -n "$(type -t gulp)" ]]          && echo -n "gulp " && gulp --version
[[ -n "$(type -t webpack)" ]]       && echo -n "webpack " && webpack --version

[[ -n "$(type -t yarn)" ]]          && echo -n "yarn " && yarn --version