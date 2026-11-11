FROM alpine:3.24
# В вузе прокси передаётся через переменную окружения https_proxy (см. README)
ARG https_proxy
ARG http_proxy
RUN apk add --no-cache php85 php85-fpm php85-mysqli php85-pdo_pgsql php85-pecl-redis \
 && mv /etc/php85/conf.d /etc/php85-ext.d
# /etc/php85 монтируется из ./conf, поэтому ini-файлы, подключающие расширения,
# перенесены в отдельную папку, которую php читает через PHP_INI_SCAN_DIR
ENV PHP_INI_SCAN_DIR=/etc/php85-ext.d
WORKDIR /www
EXPOSE 9000
CMD ["php-fpm85", "-F"]
