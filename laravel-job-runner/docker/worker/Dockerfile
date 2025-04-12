FROM php:8.2-cli-alpine

WORKDIR /var/www

RUN apk add --no-cache \
    curl supervisor libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .
COPY docker/worker/supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
