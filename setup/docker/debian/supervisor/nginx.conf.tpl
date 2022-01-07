[supervisord]
nodaemon = true

[program:php-fpm]
command = /usr/sbin/php-fpm${PHP_VERSION_APT} -F
user = root
autostart = false
stdout_events_enabled=true
stderr_events_enabled=true

[program:nginx]
command = /usr/sbin/nginx
user = root
autostart = false
stdout_events_enabled=true
stderr_events_enabled=true
