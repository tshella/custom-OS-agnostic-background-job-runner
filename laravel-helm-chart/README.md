# Laravel Job Runner Helm Chart

## Overview
This Helm chart deploys a Laravel application with:

- Background worker
- MySQL database
- Optional TLS with Ingress and Cert-Manager

---

##  Components

- **App**: Laravel FPM app
- **Worker**: Background PHP job runner
- **MySQL**: Internal database
- **Ingress**: TLS-enabled access (via `letsencrypt-prod`)
- **Secrets**: DB credentials

---

##  Installation

```bash
helm install jobrunner ./laravel-helm-chart
```

Or with custom values:

```bash
helm install jobrunner ./laravel-helm-chart -f my-values.yaml
```

---

## 🔧 Configuration
See `values.yaml` for defaults:

```yaml
image:
  repository: custom-laravel-job-runner-app
  tag: latest

env:
  APP_ENV: production
  APP_URL: https://your-domain.com
  DB_HOST: laravel-mysql
  DB_DATABASE: laravel
  DB_USERNAME: user
  SESSION_DRIVER: file
```

---

##  TLS Support

Ensure Cert-Manager is installed:
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
```

Add Ingress + annotations:
```yaml
cert-manager.io/cluster-issuer: letsencrypt-prod
```

---

##  Tests

```bash
helm test jobrunner
```

> You can add `tests/` with Kubernetes Jobs for Laravel smoke tests

---

##  Uninstall
```bash
helm uninstall jobrunner
```

---

##  Folder Structure
```
laravel-helm-chart/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    ├── ingress.yaml
    ├── secrets.yaml
    └── service.yaml
```

---


