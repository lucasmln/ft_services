FROM alpine:latest

RUN apk -U upgrade

RUN apk add vim mysql mysql-client

#RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.16.3_linux_amd64.tar.gz
RUN mkdir -p /etc/telegraf
COPY telegraf.conf /etc/telegraf/telegraf.conf

COPY my.cnf /etc/
COPY start.sh .

COPY init.sql .

EXPOSE 3306

CMD /bin/sh /start.sh
