#!/bin/bash

set -e

echo "Stopping existing containers (if any)..."
docker-compose down -v --remove-orphans

echo "Building and starting Laravel Job Runner stack..."
docker-compose -f docker-compose.yml -f docker-compose.override.yml up --build -d

echo "Showing logs (Press Ctrl+C to exit)..."
docker-compose logs -f --tail=50
