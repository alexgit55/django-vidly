#!/bin/bash

# Azure App Service startup script for Django application
# This script handles database migrations, static file collection, and starts the application

echo "Starting Django application setup..."

# Navigate to the application directory
cd /home/site/wwwroot

# Install dependencies (if not already installed)
echo "Installing Python dependencies..."
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

# Set Django settings module
export DJANGO_SETTINGS_MODULE=vidly.settings

# Run database migrations
echo "Running database migrations..."
python vidly_app/manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python vidly_app/manage.py collectstatic --noinput --clear

# Create superuser if it doesn't exist (optional)
# echo "Creating superuser..."
# python vidly_app/manage.py shell -c "
# from django.contrib.auth import get_user_model;
# User = get_user_model();
# if not User.objects.filter(username='admin').exists():
#     User.objects.create_superuser('admin', 'admin@example.com', 'your_secure_password')
# "

# Start the application with Gunicorn
echo "Starting Gunicorn server..."
cd vidly_app
gunicorn --bind 0.0.0.0:8000 --workers 4 --timeout 600 --access-logfile '-' --error-logfile '-' vidly.wsgi:application
