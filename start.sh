#!/bin/sh

set -e 

# Load environment variables from app.env
if [ -f app.env ]; then
    echo "Loading environment variables from app.env"
    set -o allexport
    source app.env
    set +o allexport
else
    echo "app.env file not found. Please make sure it exists in the current directory."
    exit 1
fi

echo "DB_SOURCE: $DB_SOURCE"

echo "run db migrations"
/app/migrate -path /app/migrations -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
