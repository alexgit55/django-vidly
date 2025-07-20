# Local development startup script for Windows
# Run this from the root of your project (c:\Scripts\GitHub\alexgit55\django-vidly\)

Write-Host "Starting Django application setup (Local Development)..."

# Navigate to the application directory (local path)
Set-Location "c:\Scripts\GitHub\alexgit55\django-vidly"

# Install dependencies
Write-Host "Installing Python dependencies..."
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

# Set Django settings module for local development
$env:DJANGO_SETTINGS_MODULE = "vidly.settings"

# Run database migrations
Write-Host "Running database migrations..."
Set-Location "vidly_app"
python manage.py migrate

# Collect static files
Write-Host "Collecting static files..."
python manage.py collectstatic --noinput

# Start the development server (not Gunicorn for local)
Write-Host "Starting Django development server..."
python manage.py runserver 127.0.0.1:8000
