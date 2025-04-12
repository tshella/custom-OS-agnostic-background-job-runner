# Makefile for Laravel Job Runner

APP_NAME := Laravel Job Runner
MAIL_TO := you@example.com
MAIL_SUBJECT := "$(APP_NAME) Deployed"
MAIL_BODY := "$(APP_NAME) successfully deployed at $$(date)"

up:
	docker-compose -f docker-compose.yml -f docker-compose.override.yml up --build

prod:
	docker-compose -f docker-compose.prod.yml up --build -d && make notify

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

cert:
	docker-compose -f docker-compose.prod.yml run --rm certbot

notify:
	echo "$(MAIL_BODY)" | mail -s "$(MAIL_SUBJECT)" $(MAIL_TO)
