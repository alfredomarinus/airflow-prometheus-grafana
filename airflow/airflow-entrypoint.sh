#!/usr/bin/env bash
set -e

echo "Waiting for PostgreSQL"
while ! pg_isready -h postgres -p 5432 -U "$POSTGRES_USER"; do
  sleep 2
done

echo "Migrating Airflow metadata database"
airflow db migrate

# echo "Creating Flask-AppBuilder tables (first time only)…"
# airflow fab create-db

# echo "Syncing FAB permissions…"
# airflow sync-perm

echo "Creating admin user"
airflow users create \
  --username admin \
  --password admin \
  --firstname Airflow \
  --lastname Admin \
  --role Admin \
  --email admin@example.com || true

echo "Starting Airflow webserver"
exec airflow api-server