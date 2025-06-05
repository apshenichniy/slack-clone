#!/usr/bin/env bash
set -euo pipefail

# Start database and Electric SQL containers
# Uses docker-compose.yml in the repo root

docker compose up -d postgres electric

# Wait for Postgres to accept connections
until docker compose exec postgres pg_isready -U postgres >/dev/null 2>&1; do
  echo "Waiting for postgres..."
  sleep 2
done

echo "Applying Prisma schema to database"
bun run db:push

if [ "${SEED_DB:-false}" = "true" ]; then
  echo "Seeding database..."
  bun run db:seed
fi

printf '\nServices started successfully.\n'
