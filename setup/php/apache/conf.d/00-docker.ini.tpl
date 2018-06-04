; Maximum amount of memory a script may consume
; http://php.net/memory-limit
memory_limit = ${PHP_MEMORY_LIMIT_APACHE}

; Log errors to specified file. PHP's default behavior is to leave this value empty.
; http://php.net/error-log
error_log = "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}/php-error.log"

; Defines the default timezone used by the date functions
; http://php.net/date.timezone
date.timezone = "${DOCKER_TIMEZONE}"

xdebug.var_display_max_depth = 8
xdebug.default_enable = 1

xdebug.remote_enable = 1
xdebug.remote_handler = dbgp
xdebug.remote_mode = req
xdebug.remote_port = 9000
xdebug.remote_host = ${DOCKER_HOST_IP}
xdebug.remote_autostart = ${PHP_XDEBUG_HTTP_AUTOSTART}

xdebug.profiler_enable = 0
xdebug.profiler_enable_trigger = 1
xdebug.profiler_output_dir = "${DOCKER_BASE_DIR}/${PHP_LOG_PATH}/xdebug"
xdebug.profiler_output_name = cachegrind.out.%t
