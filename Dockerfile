# Use official Python runtime as base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install system dependencies
# before: default-mysql-client gcc
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy entrypoint script with execute permissions
COPY entrypoint.sh /app/entrypoint.sh

# Copy project
COPY . /app/

# Fix line endings and ensure execute permissions
RUN sed -i 's/\r$//' /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

# Expose port
EXPOSE 8000

# Run entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
