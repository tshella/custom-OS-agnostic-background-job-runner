FROM php:8.2-fpm-alpine

WORKDIR /var/www

# Install system dependencies
RUN apk add --no-cache \
    git curl unzip libzip-dev zip oniguruma-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && rm -rf /var/cache/apk/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# ✅ Copy full Laravel app FIRST (including your helper file)
COPY . .

# ✅ Then run Composer
RUN composer install --no-dev --optimize-autoloader

# Copy entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
