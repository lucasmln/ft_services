
FROM alpine:latest

RUN apk update \
	&& apk upgrade \
	&& apk add nginx openssl openssh vim

#RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.16.3_linux_amd64.tar.gz
RUN mkdir -p /etc/telegraf
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

RUN adduser -D admin
RUN echo "admin:admin" | chpasswd

RUN rm /etc/nginx/conf.d/default.conf
ADD ./default.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p var/run/nginx
RUN mkdir -p html
ADD ./index.html html/index.html
RUN chmod 666 html/index.html
RUN ssh-keygen -A
RUN openssl req -x509 -nodes -days 7300 -subj "/C=FR/ST=Paris/O=21/OU=lmoulin/CN=www.localhost" -newkey rsa:2048 -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

COPY ./start.sh /start.sh
RUN	 chmod +x ./start.sh

EXPOSE 80 443

CMD ["/start.sh"]
