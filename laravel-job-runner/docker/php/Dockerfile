FROM php:8.2-fpm-alpine

WORKDIR /var/www

RUN apk add --no-cache \
    git curl unzip libzip-dev zip oniguruma-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && rm -rf /var/cache/apk/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

COPY . .

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
