#!/bin/sh

echo "Checking if gunicorn exists..."
which gunicorn
echo "Starting application..."
gunicorn books.wsgi:application --bind 0.0.0.0:8000
