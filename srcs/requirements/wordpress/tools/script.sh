#!/bin/bash

# Read the database password from Docker secret
DB_USER_PASS="$(cat /run/secrets/db_password)"

# Load database and WordPress configuration variables
. /run/secrets/credentials

# Wait for MariaDB to be ready
sleep 10

# Move to the WordPress installation directory
cd /var/www/html/wordpress

# Download WordPress core files
wp core download --allow-root

# Create the WordPress configuration file
wp core config \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_USER_PASS}" \
    --dbhost="${DB_HOST}" \
    --allow-root

# Install WordPress and create the administrator account
wp core install \
    --allow-root \
    --url="${DOMAIN_NAME}" \
    --title="${WP_WEB_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}"

# Create the regular WordPress user
wp user create \
    "${WP_USER}" \
    "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --allow-root

# Give the www-data user ownership of all WordPress files so that PHP-FPM can access and modify them
chown -R www-data:www-data /var/www/html/wordpress

# Configure PHP-FPM to listen for connections on port 9000
sed -i \
    's#listen = /run/php/php8.2-fpm.sock#listen = 0.0.0.0:9000#g' \
    /etc/php/8.2/fpm/pool.d/www.conf

# Set WordPress as the working directory for PHP-FPM
sed -i \
    's#chdir = /var/www#chdir = /var/www/html/wordpress#g' \
    /etc/php/8.2/fpm/pool.d/www.conf

# Start PHP-FPM in the foreground
php-fpm8.2 -F