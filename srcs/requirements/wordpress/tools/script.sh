#!/bin/bash

DB_USER_PASS="$(cat /run/secrets/db_password)"
. /run/secrets/credentials

sleep 10

cd /var/www/html/wordpress

wp core download --allow-root

wp core config \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_USER_PASS}" \
    --dbhost="${DB_HOST}" \
    --allow-root

wp core install \
    --allow-root \
    --url="${DOMAIN_NAME}" \
    --title="${WP_WEB_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}"

wp user create \
    "${WP_USER}" \
    "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --allow-root
#change ownership of all files so that php-fpm can run as www-data
chown -R www-data:www-data /var/www/html/wordpress

#php-fpm listen on 9000
sed -i \ 
    's#listen = /run/php/php8.2-fpm.sock#listen = 0.0.0.0:9000#g' \ 
    /etc/php/8.2/fpm/pool.d/www.conf

# changing the woring dir to my wordpress dir 
sed -i \
    's#chdir = /var/www#chdir = /var/www/html/wordpress#g' \
    /etc/php/8.2/fpm/pool.d/www.conf

php-fpm8.2 -F