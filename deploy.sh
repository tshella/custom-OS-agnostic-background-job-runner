#!/bin/bash

set -e

APP_NAME="Laravel Job Runner"
ENV=${1:-dev}

printf "\n Deploying %s in [%s] mode...\n" "$APP_NAME" "$ENV"

case $ENV in
  dev)
    echo "Running local development environment..."
    docker compose -f docker-compose.yml -f docker-compose.override.yml up --build -d
    ;;

  prod)
    echo "Running production setup with Nginx + TLS..."
    docker compose -f docker-compose.prod.yml up --build -d
    ;;

  stop)
    echo "Stopping all containers..."
    docker compose down --remove-orphans
    ;;

  restart)
    echo "Restarting containers..."
    docker compose down --remove-orphans
    docker compose -f docker-compose.yml -f docker-compose.override.yml up --build -d
    ;;

  cert)
    echo "Requesting SSL Certificate with Certbot..."
    docker compose -f docker-compose.prod.yml run --rm certbot
    ;;

  logs)
    echo "Showing logs for all containers..."
    docker compose logs -f
    ;;

  *)
    echo "❌ Invalid option. Usage: ./deploy.sh [dev|prod|restart|stop|cert|logs]"
    exit 1
    ;;
esac
