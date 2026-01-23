ARG PHP_VERSION="8.5"
ARG ALPINE_VERSION="3.23"
ARG CADDY_VERSION="2.11"

FROM caddy:${CADDY_VERSION}-alpine AS caddy-upstream

FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION} AS builder
ARG DEBUG

ARG COMPOSER_VERSION="2.9.4"

RUN apk --update-cache add \
            git \
            patch \
            gettext-dev \
            jpeg-dev \
            libpng-dev \
            zlib-dev

RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd gettext

WORKDIR /tmp

RUN curl https://getcomposer.org/installer | php -- --version ${COMPOSER_VERSION}

RUN rm -rf /var/www && mkdir /var/www
COPY --from=p2-rep2 . /var/www

WORKDIR /var/www

RUN rm -f composer.lock
RUN /tmp/composer.phar install
RUN rm -r doc
RUN rm -rf `find . -name '.git*' -o -name 'composer.*'`

COPY patch /tmp
RUN patch -p1 < /tmp/p2-php.patch

RUN mv conf conf.orig && ln -s /ext/conf conf
RUN mv data data.orig && ln -s /ext/data data
RUN ln -s /ext/rep2/ic rep2/ic

COPY --from=2chproxy.pl 2chproxy.pl .
RUN chmod 755 2chproxy.pl
RUN mv 2chproxy.pl /usr/local/bin/


FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}
LABEL org.opencontainers.image.authors="Abe Masahiro <pen@thcomp.org>" \
    org.opencontainers.image.source="https://github.com/pen/docker-rep2"
ARG DEBUG

RUN apk --no-cache add \
            sudo \
            gettext \
            libintl \
            libjpeg \
            libpng \
            perl-http-daemon \
            perl-lwp-useragent-determined \
            perl-yaml-tiny \
            perl-io-socket-ssl \
            perl-lwp-protocol-https \
            ca-certificates \
            zlib

COPY --from=caddy-upstream /usr/bin/caddy /usr/bin/caddy

RUN if [ "$DEBUG" = "on" ]; then \
    apk --no-cache add tshark; \
    apk --no-cache add  --virtual .build-deps $PHPIZE_DEPS linux-headers \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del .build-deps; \
    fi

COPY --from=builder /usr/local /usr/local
COPY --from=builder /var/www   /var/www
COPY rootfs /

VOLUME /ext
EXPOSE 443

CMD ["/etc/rc.entry"]
