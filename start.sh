#!/bin/sh

set -e

# Directly set DB_SOURCE (for testing purposes only)
DB_SOURCE="postgresql://root:mCHF7frAgCyhgLkVFJe0@simple-bank.clsi8qk24waz.ap-south-1.rds.amazonaws.com:5432/simple_bank"

# Debug print
echo "DB_SOURCE before sourcing: $DB_SOURCE"

# No need to source app.env in this case

# Debug print
echo "DB_SOURCE after sourcing: $DB_SOURCE"

if [ -z "$DB_SOURCE" ]; then
  echo "Error: DB_SOURCE is empty"
  exit 1
fi

/app/migrate -path /app/migrations -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
