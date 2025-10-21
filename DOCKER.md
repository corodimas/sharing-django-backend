# Docker Compose Setup Guide

## 📁 Docker Files Created

- **Dockerfile**: Django application container image
- **docker-compose.yml**: Orchestrates Django + MySQL services
- **.dockerignore**: Excludes unnecessary files from build
- **entrypoint.sh**: Container startup script (migrations + server)

## 🚀 Quick Start with Docker Compose

### 1. Build and Start Services
```bash
docker-compose up -d
```

**What happens:**
- Builds Django image
- Starts MySQL database
- Runs migrations automatically
- Starts Django development server

### 2. Check Services Status
```bash
docker-compose ps
```

### 3. Access Your Application
- **Django App**: http://localhost:8000
- **Admin Panel**: http://localhost:8000/admin
- **MySQL**: localhost:3306

### 4. Create Superuser (Optional)
```bash
docker-compose exec web python manage.py createsuperuser
```

### 5. View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f web
docker-compose logs -f db
```

## 📋 Common Docker Compose Commands

### Stop Services
```bash
docker-compose down
```

### Stop and Remove Volumes (Clean State)
```bash
docker-compose down -v
```

### Restart Services
```bash
docker-compose restart
```

### Run Django Commands
```bash
# Migrations
docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py migrate

# Shell
docker-compose exec web python manage.py shell

# Django admin
docker-compose exec web python manage.py createsuperuser
```

### Database Access
```bash
# MySQL CLI
docker-compose exec db mysql -u root -pCdhitman245565 sharing

# Run SQL
docker-compose exec db mysql -u root -pCdhitman245565 -e "SHOW DATABASES;"
```

### View Container Output
```bash
docker-compose logs web
docker-compose logs db
```

## 🔧 Environment Variables

The `.env` file contains:

```
# Django Settings
SECRET_KEY=your-secret-key
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1,web

# MySQL Configuration
DB_NAME=sharing
DB_USER=root
DB_PASSWORD=Cdhitman245565
DB_HOST=db          # Docker service name
DB_PORT=3306
MYSQL_ROOT_PASSWORD=Cdhitman245565
```

### For Production
Update `.env` before deployment:
- Set `DEBUG=False`
- Generate strong `SECRET_KEY`
- Change `MYSQL_ROOT_PASSWORD`
- Update `DB_PASSWORD`
- Set proper `ALLOWED_HOSTS`

## 🗄️ Database Persistence

Data is stored in a named volume `db_data`:
```bash
# View volumes
docker volume ls

# Inspect volume
docker volume inspect scgp-sharing-django-backend_db_data

# Remove volume (deletes data!)
docker volume rm scgp-sharing-django-backend_db_data
```

## 🌐 Network

Services communicate via `django_network` bridge network:
- `web` service: accessible on port 8000
- `db` service: accessible on port 3306
- Internal DNS: `web` ↔ `db` hostnames work within network

## 📊 Service Architecture

```
┌─────────────────────────────────────┐
│      Host Machine                   │
├─────────────────────────────────────┤
│  ┌───────────────────────────────┐  │
│  │    django_network (bridge)    │  │
│  ├───────────────────────────────┤  │
│  │ ┌─────────────────────────┐   │  │
│  │ │  Django Web Container   │   │  │
│  │ │  - Port 8000            │   │  │
│  │ │  - DB_HOST: db          │   │  │
│  │ └─────────────────────────┘   │  │
│  │            ↓↑ (DB queries)    │  │
│  │ ┌─────────────────────────┐   │  │
│  │ │  MySQL DB Container     │   │  │
│  │ │  - Port 3306            │   │  │
│  │ │  - Volume: db_data      │   │  │
│  │ └─────────────────────────┘   │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

## 🆘 Troubleshooting

### Port Already in Use
```bash
# Change ports in docker-compose.yml
# Or stop the service using the port
lsof -i :8000
kill -9 <PID>
```

### Container Fails to Start
```bash
# Check logs
docker-compose logs web

# Rebuild image
docker-compose build --no-cache
docker-compose up
```

### Database Connection Error
```bash
# Verify MySQL is running
docker-compose logs db

# Test connection from web container
docker-compose exec web python manage.py shell
>>> from django.db import connection
>>> connection.ensure_connection()
```

### Rebuild and Restart Fresh
```bash
docker-compose down -v
docker system prune -a
docker-compose up --build
```

## 📦 Production Deployment Tips

1. **Use a production image**: Replace `python:3.10-slim` with optimized base
2. **Don't use volumes**: Remove `volumes:` from web service in production
3. **Environment file**: Keep `.env` separate and secure
4. **Database backups**: Set up regular MySQL backups
5. **Logging**: Configure proper logging (not console output)
6. **Reverse proxy**: Use Nginx/Apache in front of Django
7. **Resource limits**: Add `resources:` limits in docker-compose.yml

Example production additions to docker-compose.yml:
```yaml
services:
  web:
    # ... existing config
    resources:
      limits:
        cpus: '1'
        memory: 512M
      reservations:
        cpus: '0.5'
        memory: 256M
```

## ✅ Next Steps

1. Run `docker-compose up -d`
2. Visit http://localhost:8000
3. Create superuser: `docker-compose exec web python manage.py createsuperuser`
4. Access admin: http://localhost:8000/admin
