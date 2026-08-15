FROM debian:12-slim

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/* 
    # Delete unnecessary package metadata

COPY config/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3309

ENTRYPOINT ["/usr/local/bin/script.sh"]