#!/bin/bash

set -e

echo "Starting Laravel Entrypoint..."

# Run Composer if vendor is missing
if [ ! -d "vendor" ]; then
  echo " Installing dependencies..."
  composer install --no-interaction --prefer-dist
fi

# Run Laravel-specific prep (migrations, caching)
if [ "$APP_ENV" != "production" ]; then
  echo "⚙ Running migrations and cache clear..."
  php artisan migrate --force
  php artisan config:clear
  php artisan cache:clear
else
  echo "⚙ Caching Laravel config..."
  php artisan config:cache
fi

# Run final command passed to container (php-fpm, worker, etc.)
exec "$@"
