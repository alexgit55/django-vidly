# Azure App Service Deployment Guide

## Prerequisites
1. GitHub repository with your Django code
2. Azure subscription
3. Azure App Service created

## Setup Steps

### 1. Push Code to GitHub
```bash
git add .
git commit -m "Initial Django app for Azure deployment"
git push origin main
```

### 2. Create Azure App Service
```bash
# Using Azure CLI
az webapp create \
  --resource-group myResourceGroup \
  --plan myAppServicePlan \
  --name your-app-name \
  --runtime "PYTHON|3.11" \
  --deployment-source-url https://github.com/alexgit55/django-vidly
```

### 3. Configure App Service Settings

#### Option A: Using Azure Portal
1. Go to Azure Portal → App Services → Your App
2. Configuration → Application Settings
3. Add the settings from `azure-app-settings.json`
4. Configuration → General Settings → Startup Command:
   ```
   cd vidly_app && python manage.py migrate --settings=vidly.production_settings --noinput && python manage.py collectstatic --noinput --settings=vidly.production_settings && gunicorn --bind 0.0.0.0:8000 vidly.wsgi:application
   ```

#### Option B: Using Azure CLI
```bash
# Set application settings
az webapp config appsettings set \
  --resource-group myResourceGroup \
  --name your-app-name \
  --settings \
    SECRET_KEY="your-secret-key" \
    DEBUG="False" \
    DJANGO_SETTINGS_MODULE="vidly.production_settings" \
    SCM_DO_BUILD_DURING_DEPLOYMENT="true"

# Set startup command
az webapp config set \
  --resource-group myResourceGroup \
  --name your-app-name \
  --startup-file "cd vidly_app && python manage.py migrate --settings=vidly.production_settings --noinput && python manage.py collectstatic --noinput --settings=vidly.production_settings && gunicorn --bind 0.0.0.0:8000 vidly.wsgi:application"
```

### 4. Setup GitHub Actions (Recommended)

1. In Azure Portal → App Service → Deployment Center
2. Choose "GitHub Actions"
3. Authorize GitHub and select your repository
4. Azure will automatically create the workflow file
5. Or use the provided `.github/workflows/main_deploy.yml`

### 5. Alternative: Simple GitHub Integration

1. Azure Portal → App Service → Deployment Center
2. Source: GitHub
3. Select your repository and branch
4. Azure will automatically deploy on every push

## Environment Variables Needed

Set these in Azure App Service Configuration:
- `SECRET_KEY`: Your Django secret key
- `DEBUG`: False
- `DJANGO_SETTINGS_MODULE`: vidly.production_settings
- `WEBSITE_HOSTNAME`: your-app-name.azurewebsites.net
- `ALLOWED_HOSTS`: your-app-name.azurewebsites.net
- `SCM_DO_BUILD_DURING_DEPLOYMENT`: true

## File Structure for Deployment
```
django-vidly/
├── .github/workflows/main_deploy.yml  # GitHub Actions workflow
├── .deployment                        # Azure deployment config
├── requirements.txt                   # Python dependencies
├── startup.txt                       # Azure startup command
├── azure-app-settings.json           # App settings reference
├── vidly_app/                        # Your Django app
│   ├── manage.py
│   ├── vidly/
│   │   ├── production_settings.py    # Production settings
│   │   └── ...
│   └── ...
└── README.md
```

## Testing the Deployment

1. Push changes to GitHub
2. Check deployment logs in Azure Portal → App Service → Deployment Center
3. Visit your app at: https://your-app-name.azurewebsites.net
4. Check logs: Azure Portal → App Service → Log stream

## Troubleshooting

- Check deployment logs in Azure Portal
- Verify all environment variables are set
- Ensure startup command is correct
- Check Python version compatibility
- Verify requirements.txt includes all dependencies
