#!/bin/bash
apt update -y && apt upgrade -y
apt install nginx mysql-client-core-8.0 php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip python3-pymysql php-fpm php-mysql -y

#################### NGINX config #########################
rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default

cat <<EOF > /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 1024;
	# multi_accept on;
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

	include /etc/nginx/mime.types;
	default_type application/octet-stream;
	include /etc/nginx/sites-enabled/*.conf;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	##
	# Logging Settings
	##

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	gzip on;
	include /etc/nginx/conf.d/*.conf;
}
EOF



cat <<EOF > /etc/nginx/sites-available/wordpress.conf
server {
    listen ${Listen_Port};
    server_name ${DNS_Name};
    root /var/www/wordpress;

    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php\$is_args\$args;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

}
EOF
#####################################################################


#################### WordPress installation #########################

cd /var/www \
&& curl -LO https://wordpress.org/latest.tar.gz \
&& tar xzvf latest.tar.gz \
&& rm -rf /var/www/wordpress/wp-config-sample.php

cat <<EOF > /var/www/wordpress/wp-config.php
<?php
define( 'DB_NAME', '${rds_name}' );
define( 'DB_USER', '${rds_user_name}' );
define( 'DB_PASSWORD', '${rds_user_password}' );
define( 'DB_HOST', '${rds_db_host}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
define('FS_METHOD', 'direct');
define( 'WP_DEBUG', false );
\$table_prefix = 'wp_';
EOF

curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/wordpress/wp-config.php

cat <<EOF >> /var/www/wordpress/wp-config.php
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
EOF

chown www-data:www-data /var/www/wordpress/wp-config.php
#####################################################################

ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/

nginx -t

service nginx start
