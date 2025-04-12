# Custom OS-Agnostic Laravel Background Job Runner

Senior Laravel Backend Engineer: Manaka Anthony Raphasha

A scalable, production-ready Laravel app with Docker, custom job execution (no Laravel queues), Nginx + TLS, Let's Encrypt auto SSL, and GitHub Actions CI/CD.

---

##  Features

-  Laravel 10+ with PHP 8.2 FPM (Alpine)
-  MySQL 8.0 via Docker
-  Nginx reverse proxy with TLS (HTTPS)
-  Certbot + Let's Encrypt SSL automation
-  Background job runner (no queue system)
-  Worker process using Supervisor
-  Healthchecks and production boot sequencing
-  GitHub Actions CI/CD pipeline

---

##  Project Structure

```bash
.
├── docker-compose.yml                # Base Docker setup (dev or prod)
├── docker-compose.override.yml       # Dev override (artisan serve + port mappings)
├── docker-compose.prod.yml           # Production TLS + Certbot + php-fpm setup
├── .env                              # Local environment config
├── .env.production                   # Production-ready environment
├── Makefile / up.sh                  # CLI helpers (optional)
├── .github/workflows/laravel.yml     #  GitHub Actions CI pipeline
├── certbot/                          # Let's Encrypt mounted volume
├── laravel-job-runner/               # Laravel application
│   ├── run-job.php / worker.php      # Custom job and optional polling
│   ├── docker/                       # Nginx, php, entrypoints, supervisor
│   └── app/Helpers/BackgroundJobHelper.php
```

---

##  Getting Started

###  Requirements
- Docker & Docker Compose v2+
- Valid DNS pointing to your server (e.g. `yourdomain.com`)

###  Local Dev
```bash
docker compose -f docker-compose.yml -f docker-compose.override.yml up --build
```

Visit:
- http://localhost:8000 (artisan serve)
- http://localhost:8001 (nginx proxy)

---

##  TLS + Let's Encrypt (Production)

### Step 1: Update DNS
Make sure `easypeasy.com` and `www.easypeasy.com` point to your public IP.

### Step 2: First-time Certbot Request
```bash
docker compose -f docker-compose.prod.yml run --rm certbot
```

This will generate and store your SSL keys inside `./certbot/conf/`

### Step 3: Start Production
```bash
docker compose -f docker-compose.prod.yml up --build -d
```

Visit: https://easypeasy.com 

### Step 4: Set Up Auto-Renew
```bash
# Add this to crontab -e
0 0 * * * docker compose run --rm certbot renew --quiet
```

---

##  GitHub Actions CI/CD

CI/CD file: `.github/workflows/laravel.yml`

### What It Does:
-  Spin up MySQL
-  Build Docker images
-  Run Laravel migrations & tests
-  Deploy (optional)

### CI Trigger
```yaml
on:
  push:
    branches: [ "main" ]
```

---

## GitHub Secrets (Required)

| Secret Name       | Description                          |
|-------------------|--------------------------------------|
| `SSH_HOST`        | IP/hostname of your production server |
| `SSH_USER`        | SSH username                         |
| `SSH_PASS`        | SSH password or SSH key              |

Optional for `scp`/`rsync`-based deploy in the pipeline.

---

## Testing Locally
```bash
docker compose exec app php artisan test
```

Or run:
```bash
make test
```
(if Makefile is present)

---

## Production Notes

- `SESSION_DRIVER=file` used for stateless job-based execution
- All logs output to standard output for Docker logging
- Config is cached in production on boot
- `entrypoint.sh` waits for DB and retries migrations

---

## Questions or Contributions?
Feel free to fork and PR improvements. For issues, create a GitHub Issue on this repo.

Enjoy shipping clean background jobs, the Laravel way. 
