#!/bin/sh

telegraf &
php-fpm7
nginx -g 'daemon off;'
#php -S 0.0.0.0:5000 -t /usr/share/phpmyadmin