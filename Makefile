# Makefile for Laravel Job Runner

up:
	docker-compose -f docker-compose.yml -f docker-compose.override.yml up --build

down:
	docker-compose down -v --remove-orphans

logs:
	docker-compose logs -f --tail=100

migrate:
	docker exec -it custom-os-agnostic-background-job-runner-app-1 php artisan migrate --force

shell:
	docker exec -it custom-os-agnostic-background-job-runner-app-1 sh

worker-logs:
	docker-compose logs -f custom-os-agnostic-background-job-runner-worker-1

nginx-logs:
	docker-compose logs -f custom-os-agnostic-background-job-runner-nginx-1

ps:
	docker ps
