; Maximum amount of memory a script may consume
; http://php.net/memory-limit
memory_limit = ${PHP_MEMORY_LIMIT_CLI}

; Log errors to specified file. PHP's default behavior is to leave this value empty.
; http://php.net/error-log
error_log = "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}/php-error.log"

; Defines the default timezone used by the date functions
; http://php.net/date.timezone
date.timezone = "${DOCKER_TIMEZONE}"

display_errors = On
display_startup_errors = On
xdebug.mode=debug
xdebug.discover_client_host = true
xdebug.client_host = ${DOCKER_CLIENT_HOST}
xdebug.output_dir = /var/www/calleo/var
