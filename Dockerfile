FROM php:7.4.2-alpine3.11

COPY install-composer.sh /usr/local/bin/docker-app-install-composer
RUN chmod +x /usr/local/bin/docker-app-install-composer

RUN set -xe \
	&& apk add --no-cache --virtual .fetch-deps \
		openssl \
	&& docker-app-install-composer \
	&& mv composer.phar /usr/local/bin/composer \
	&& apk del .fetch-deps

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1

ENV COMPOSER_HOME /root/.composer
ENV PATH $PATH:$COMPOSER_HOME/vendor/bin

COPY composer.json /root/.composer
COPY php.ini /usr/local/etc/php/

RUN composer global update --prefer-dist --no-progress --no-suggest --optimize-autoloader --classmap-authoritative \
	&& composer clear-cache


