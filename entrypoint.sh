#!/bin/bash
set -euo pipefail

# Configuration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_MAX_RETRIES="${DB_MAX_RETRIES:-30}"
DB_RETRY_INTERVAL="${DB_RETRY_INTERVAL:-1}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Wait for database function
wait_for_db() {
    local retries=0
    
    log_info "Waiting for MySQL at $DB_HOST:$DB_PORT..."
    
    while [ $retries -lt "$DB_MAX_RETRIES" ]; do
        if mysqladmin ping -h "$DB_HOST" -P "$DB_PORT" --ssl-mode=DISABLED --silent >/dev/null 2>&1; then
            log_info "MySQL is ready!"
            return 0
        fi
        
        retries=$((retries + 1))
        log_warn "MySQL not ready yet... (attempt $retries/$DB_MAX_RETRIES)"
        sleep "$DB_RETRY_INTERVAL"
    done
    
    log_error "Failed to connect to MySQL after $DB_MAX_RETRIES attempts"
    return 1
}

# Main execution
main() {
    log_info "Starting entrypoint script..."
    
    # Wait for database
    if ! wait_for_db; then
        log_error "Database connection failed. Exiting."
        exit 1
    fi
    
    # Run migrations
    log_info "Running Django migrations..."
    if ! python manage.py migrate --noinput; then
        log_error "Migration failed. Exiting."
        exit 1
    fi
    
    log_info "Migrations completed successfully"
    log_info "Starting Django development server..."
    
    # Execute the CMD from docker-compose
    exec "$@"
}

# Trap errors and signals
trap 'log_error "Script interrupted"; exit 130' INT TERM

# Run main function
main "$@"
