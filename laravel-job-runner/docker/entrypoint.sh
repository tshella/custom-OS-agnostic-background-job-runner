#!/bin/sh

set -e

echo "Starting Laravel Entrypoint..."

# Run Composer if vendor is missing
if [ ! -d "vendor" ]; then
  echo "Installing dependencies..."
  composer install --no-interaction --prefer-dist
fi

# Wait for DB to be ready
echo "Waiting for database to be ready..."
until nc -z "$DB_HOST" "$DB_PORT"; do
  echo "Database not available at $DB_HOST:$DB_PORT — sleeping..."
  sleep 3
done

# Run Laravel setup
if [ "$APP_ENV" != "production" ]; then
  echo "Running migrations (with retry)..."
  until php artisan migrate --force; do
    echo "Migration failed — retrying in 5s..."
    sleep 5
  done

  php artisan config:clear || true
  php artisan cache:clear || true
else
  echo "Caching production config..."
  php artisan config:cache || true
fi

exec "$@"
