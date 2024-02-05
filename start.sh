#!/bin/sh

set -e

# Debug print
cat /app/app.env

echo "DB_SOURCE before sourcing: $DB_SOURCE"

echo "run db migrations"
source /app/app.env || { echo "Failed to source app.env"; exit 1; }

# Debug print
echo "DB_SOURCE after sourcing: $DB_SOURCE"

if [ -z "$DB_SOURCE" ]; then
  echo "Error: DB_SOURCE is empty"
  exit 1
fi

/app/migrate -path /app/migrations -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
