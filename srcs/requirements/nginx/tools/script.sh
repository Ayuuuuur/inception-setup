#!/bin/bash

# Check if the SSL certificate already exists
if [ ! -f "$CERTS" ]; then

    # Generate the SSL certificate and private key with openssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$P_KEY" \
        -out "$CERTS" \
        -subj "/CN=$DOMAIN_NAME" \
        2>/dev/null #Send error messages (stderr) to /dev/null, effectively hiding them.

    echo "Certificate and private key have been generated!"

else

    echo "There is already a certificate and private key!"

fi

# Replace the placeholders in the NGINX configuration with data
sed -i \
    -e "s+DOMAIN_NAME+$DOMAIN_NAME+" \
    -e "s+CERTS+$CERTS+" \
    -e "s+P_KEY+$P_KEY+" \
    /etc/nginx/sites-available/default

# Start NGINX in the foreground
exec nginx -g "daemon off;"