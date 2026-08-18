FROM debian:bullseye

RUN apt-get update

RUN apt-get install -y mariadb-server

COPY ./conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/script.sh .

RUN chmod +x script.sh

ENTRYPOINT ["/bin/bash","./script.sh"]
