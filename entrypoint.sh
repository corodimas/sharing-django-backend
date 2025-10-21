#!/bin/bash
set -e

echo "Waiting for MySQL to be ready..."
while ! mysqladmin ping -h "$DB_HOST" --silent; do
    sleep 1
done

echo "MySQL is ready!"
echo "Running migrations..."
python manage.py migrate --noinput

echo "Starting Django development server..."
exec "$@"
