# Django Backend Setup Guide

## Project Structure
```
scgp-sharing-django-backend/
├── config/              # Project configuration
├── core/               # Main Django app
├── manage.py          # Django management script
├── .env              # Environment variables (create from .env.example)
└── .env.example      # Environment template
```

## Installation & Setup

### 1. Create Virtual Environment (if not exists)
```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 2. Install Dependencies
```bash
pip install -r requirements.txt
```

### 3. Configure Environment Variables
```bash
cp .env.example .env
```
Edit `.env` with your MySQL database credentials:
```
DB_NAME=your_database_name
DB_USER=your_mysql_user
DB_PASSWORD=your_mysql_password
DB_HOST=localhost
DB_PORT=3306
SECRET_KEY=your-secret-key
DEBUG=True  # Set to False in production
```

### 4. Create MySQL Database
```bash
mysql -u root -p
CREATE DATABASE your_database_name CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;
```

### 5. Run Migrations
```bash
python3 manage.py migrate
```

### 6. Create Superuser
```bash
python3 manage.py createsuperuser
```

### 7. Run Development Server
```bash
python3 manage.py runserver
```

Visit: http://localhost:8000/admin

## Key Packages
- **Django** (5.2.7): Web framework
- **mysqlclient** (2.2.7): MySQL adapter for Django
- **python-dotenv** (1.1.1): Load environment variables from .env file

## Database Configuration
The project is configured to use MySQL with environment variables:
- Database engine: `django.db.backends.mysql`
- Connection details loaded from `.env` file
- Default values provided for development

## Important Security Notes
⚠️ **Production Checklist:**
- Set `DEBUG=False` in `.env`
- Generate a new `SECRET_KEY`
- Update `ALLOWED_HOSTS` with your domain
- Use strong database passwords
- Store `.env` file securely (add to `.gitignore`)

## Useful Commands
```bash
# Create migrations
python3 manage.py makemigrations

# Apply migrations
python3 manage.py migrate

# Create superuser
python3 manage.py createsuperuser

# Access Django shell
python3 manage.py shell

# Collect static files
python3 manage.py collectstatic

# Run tests
python3 manage.py test
```
