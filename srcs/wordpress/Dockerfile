FROM alpine:latest

#RUN apk update
#RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl  
#RUN rc-update add php-fpm7 default

RUN	apk update && apk add nginx openrc openssl openssh && apk add wget
RUN apk add --no-cache php7 php7-fpm php7-opcache php7-common php7-mbstring
RUN apk add php7-gd php7-mysqli php7-zlib php7-curl php7-json php7-session
RUN	apk add php-json
RUN	apk add php-bz2

RUN apk add curl ; \
		apk add php-phar ; \
		apk add sudo ; \
		apk add php7-iconv ; \
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar ; \
		chmod +x wp-cli.phar ; \
		sudo mv wp-cli.phar /usr/local/bin/wp ; \
		apk add mysql-client

#RUN wget -O wordpress.zip https://wordpress.org/latest.zip
#RUN unzip /wordpress.zip -d /
#RUN rm -rf wordpress.zip
#RUN rm -rf /wordpress/wp-config.php

RUN wget http://wordpress.org/latest.tar.gz \
		&& tar xzvf latest.tar.gz \
		&& rm latest.tar.gz

RUN mkdir -p /var/run/nginx
RUN mkdir /var/run/php
RUN rm /etc/nginx/conf.d/default.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./wp-config.php /wordpress/wp-config.php

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf


ADD ./start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 5050

CMD ["sh", "./start.sh"]
