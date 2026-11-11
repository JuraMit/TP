FROM alpine:3.24
ARG https_proxy
ARG http_proxy
RUN apk add --no-cache php85 php85-fpm php85-mysqli php85-pdo_pgsql php85-pecl-redis \
 && mv /etc/php85/conf.d /etc/php85-ext.d
ENV PHP_INI_SCAN_DIR=/etc/php85-ext.d
WORKDIR /www
EXPOSE 9000
CMD ["php-fpm85", "-F"]
