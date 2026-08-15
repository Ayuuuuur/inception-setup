#!/bin/bash
set -e

service mariadb start

until mysqladmin ping --silent; do
    sleep 1
done

mysql -u root <<EOF
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOF

service mariadb stop

exec mysqld \
    --bind-address="${DB_HOST}" \
    --port=3306