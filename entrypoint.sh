#!/bin/bash
set -e

# Default Airflow variables (can be overridden with ENV)
AIRFLOW_HOME=${AIRFLOW_HOME:-/opt/airflow}
AIRFLOW_PORT=${AIRFLOW_PORT:-8081}
AIRFLOW_USER=${AIRFLOW_USER:-admin}
AIRFLOW_PASSWORD=${AIRFLOW_PASSWORD:-admin}
AIRFLOW_EMAIL=${AIRFLOW_EMAIL:-admin@example.com}
AIRFLOW_FIRSTNAME=${AIRFLOW_FIRSTNAME:-Admin}
AIRFLOW_LASTNAME=${AIRFLOW_LASTNAME:-User}

echo "Initializing Airflow metadata DB..."
airflow db upgrade

echo "Creating Airflow admin user..."
airflow users create \
    --username "$AIRFLOW_USER" \
    --password "$AIRFLOW_PASSWORD" \
    --firstname "$AIRFLOW_FIRSTNAME" \
    --lastname "$AIRFLOW_LASTNAME" \
    --role Admin \
    --email "$AIRFLOW_EMAIL"

echo "Starting Airflow standalone server..."
exec "$@"

