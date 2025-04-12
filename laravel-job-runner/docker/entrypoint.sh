#!/bin/sh

set -e

echo "🚀 Starting Laravel Entrypoint..."

# Run Composer if vendor is missing
if [ ! -d "vendor" ]; then
  echo "📆 Installing dependencies..."
  composer install --no-interaction --prefer-dist
fi

# Laravel setup logic
if [ "$APP_ENV" != "production" ]; then
  echo "🔧 Running dev migrations and cache clear..."
  php artisan migrate --force || true
  php artisan config:clear
  php artisan cache:clear
else
  echo "✅ Caching production config..."
  php artisan config:cache
fi

exec "$@"
