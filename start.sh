#!/bin/sh

set -e

# Debug print
cat /app/app.env

echo "DB_SOURCE before sourcing: $DB_SOURCE"

echo "run db migrations"
source /app/app.env

# Debug print
echo "DB_SOURCE after sourcing: $DB_SOURCE"

/app/migrate -path /app/migrations -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
