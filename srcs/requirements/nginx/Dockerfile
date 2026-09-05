FROM debian:bookworm

RUN apt-get -y update

RUN apt-get -y install nginx openssl

COPY tools/script.sh .

COPY ./conf/nginx.conf /etc/nginx/sites-available/default

RUN chmod +x script.sh

CMD ["bash", "script.sh"]
