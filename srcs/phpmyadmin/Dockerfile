FROM	alpine:latest

RUN	apk	add openssl openssh	nginx openrc openssl php7 php7-fpm php7-iconv php7-json php7-mbstring php7-mysqli php7-phar php7-session 
RUN rc-update add php-fpm7 default

RUN	wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.zip -O phpmyadmin.zip &&\
    unzip phpmyadmin.zip &&\
    rm -rf phpmyadmin.zip &&\
    mv phpMyAdmin-4.9.5-all-languages phpmyadmin
RUN mkdir /phpmyadmin/tmp
RUN	chmod 777 /phpmyadmin/tmp
RUN mkdir /run/nginx
RUN mkdir /var/run/php
COPY config.inc.php /phpmyadmin/
COPY default.conf /etc/nginx/conf.d/default.conf 

RUN adduser -D user
RUN echo "user:password" | chpasswd
RUN mkdir /etc/nginx/ssl
RUN ssh-keygen -A
RUN openssl req -x509 -nodes -days 7300 -subj "/C=FR/ST=Paris/O=21/OU=lmoulin/CN=www.localhost" -newkey rsa:2048 -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

RUN apk add	telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache 
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

ADD ./start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 5000 443

CMD ["./start.sh"]
