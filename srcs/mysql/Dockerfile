FROM alpine:latest

RUN apk -U upgrade

RUN apk add vim mysql mysql-client

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache
RUN mkdir -p /etc/telegraf
COPY telegraf.conf /etc/telegraf/telegraf.conf

COPY my.cnf /etc/
COPY start.sh .

COPY init.sql .

EXPOSE 3306

CMD /bin/sh /start.sh
