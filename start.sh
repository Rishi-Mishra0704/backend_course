#!/bin/sh

set -e

# Debug print
cat /app/app.env

# Change directory to /app where the app.env file is located
cd /app

echo "DB_SOURCE before sourcing: $DB_SOURCE"

echo "run db migrations"
source ./app.env || { echo "Failed to source app.env"; exit 1; }

# Debug print
echo "DB_SOURCE after sourcing: $DB_SOURCE"

if [ -z "$DB_SOURCE" ]; then
  echo "Error: DB_SOURCE is empty"
  exit 1
fi

/app/migrate -path /app/migrations -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
