# Airflow + Prometheus + Grafana

A Docker Compose stack running **Apache Airflow 3.0** with **Celery executor**, monitored by **Prometheus** and visualised in **Grafana**. Includes **MinIO** for S3-compatible remote log storage.

## Architecture

| Service | Description |
|---------|-------------|
| **airflow-api-server** | Web UI and REST API (port `8080`) |
| **airflow-scheduler** | Schedules DAG runs |
| **airflow-dag-processor** | Parses DAG files |
| **airflow-worker** | Celery worker that executes tasks |
| **airflow-triggerer** | Handles deferrable operators |
| **postgres** | Metadata database |
| **redis** | Celery message broker |
| **minio** | S3-compatible remote log storage |
| **prometheus** | Metrics time-series database |
| **grafana** | Visualisation and monitoring dashboards |
| **statsd-exporter** | Translates Airflow StatsD metrics to Prometheus format |

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) ≥ 24.0
- [Docker Compose](https://docs.docker.com/compose/install/) ≥ 2.20

## Quick Start

```bash
# 1. Clone the repository and navigate to it
git clone <repo-url> && cd airflow-prometheus-grafana

# 2. Copy the example env file and edit as needed
cp .env.example .env

# 3. Start all services (core + monitoring + dashboard)
make up

# 4. Wait for the init container to finish (~60 s on first run)
docker-compose logs -f airflow-init

# 5. Open the Airflow UI
open http://localhost:8080
```

## Common Operations

```bash
make up          # Start core, monitoring, and dashboard profiles
make down        # Stop all running services
make restart     # Restart all running services
make logs        # Follow all service logs
make reset       # Stop everything, remove volumes, and restart fresh
make status      # Show running containers
make shell       # Open a bash shell in the API server
```

## Service URLs

| Service            | URL                     | Default Credentials     |
|--------------------|-------------------------|-------------------------|
| Airflow UI         | http://localhost:8080    | `airflow` / `airflow`   |
| MinIO Console      | http://localhost:9001    | `minioadmin` / `minioadmin` |
| Prometheus         | http://localhost:9090    | —                       |
| Grafana            | http://localhost:3000    | `admin` / `admin`       |
| StatsD Exporter    | http://localhost:9102    | —                       |
| Flower (optional)  | http://localhost:5555    | —                       |

> Flower uses a separate profile: `docker-compose --profile flower up -d`

## Project Structure

```
.
├── airflow/
│   ├── config/
│   │   ├── airflow.cfg          # Airflow configuration
│   │   └── alerts/              # Prometheus alerting rules
│   └── dags/                    # DAG definitions
├── grafana/
│   └── provisioning/
│       ├── dashboards/          # Dashboard auto-provisioning
│       └── datasources/         # Datasource auto-provisioning (Prometheus)
├── prometheus/
│   ├── prometheus.yml           # Prometheus scrape config
│   └── statsd-mapping.yml       # StatsD → Prometheus metric mapping
├── docker-compose.yml
├── Makefile                     # Common operations
├── .env                         # Environment variables (git-ignored)
├── .env.example                 # Template for .env
└── README.md
```

## Adding DAGs

Place Python files in the `airflow/dags/` directory. They will be automatically picked up by the DAG processor.

## Configuration

All secrets and configurable values are in `.env` (git-ignored). Airflow secrets are injected via `AIRFLOW__SECTION__KEY` environment variable overrides so they never appear in committed config files.

Key variables:

| Variable | Purpose |
|----------|---------|
| `AIRFLOW_UID` | Host user ID for file permissions |
| `POSTGRES_*` | Database credentials |
| `REDIS_PASSWORD` | Redis authentication |
| `MINIO_ROOT_*` | MinIO credentials |
| `AIRFLOW__CORE__FERNET_KEY` | Encrypts connections & variables |
| `AIRFLOW__API__SECRET_KEY` | API session signing |