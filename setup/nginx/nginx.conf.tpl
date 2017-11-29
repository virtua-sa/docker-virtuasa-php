daemon off;
user ${NGINX_RUN_USER} ${NGINX_RUN_GROUP};
worker_processes 2;
worker_rlimit_nofile  8192;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 1024;
}

http {

	##
	# Basic Settings
	##

	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	# server_tokens off;

	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	log_format  main '$remote_addr - $remote_user [$time_local] "$request" '
				'$status $body_bytes_sent "$http_referer" '
				'"$http_user_agent" "$http_x_forwarded_for"';

	##
	# SSL Settings
	##

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	##
	# Logging Settings
	##

	access_log ${DOCKER_BASE_DIR}/${NGINX_LOG_PATH}/access.log;
	error_log ${DOCKER_BASE_DIR}/${NGINX_LOG_PATH}/error.log;

	##
	# Gzip Settings
	##

	gzip  on;
	gzip_disable  "MSIE [1-6]\.(?!.*SV1)";
	gzip_min_length  100;
	gzip_types  text/plain text/css application/x-javascript application/javascript
				text/xml application/xml application/xml+rss text/javascript
				image/vnd.microsoft.icon;
	gzip_vary  on;
	gzip_comp_level  9;
	gzip_proxied  any;

	##
	# Virtual Host Configs
	##

	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*.conf;
}