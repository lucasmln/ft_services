FROM alpine:latest

RUN apk update
RUN apk add nginx openrc openssl
RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session
RUN rc-update add php-fpm7 default

RUN wget -O wordpress.zip https://wordpress.org/latest.zip
RUN unzip /wordpress.zip -d /
RUN rm -rf wordpress.zip
RUN rm -rf /wordpress/wp-config.php

RUN mkdir /run/nginx
RUN mkdir /var/run/php
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./wp-config.php /wordpress/wp-config.php

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf


ADD ./start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 5050

CMD ["./start.sh"]
