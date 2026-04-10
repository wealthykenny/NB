dockerfile
# Dockerfile
# Use official lightweight Python image
FROM python:3.11-slim-buster

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=8080

# Create and set working directory
WORKDIR /app

# Install system dependencies (required for SQLite/Postgres)
RUN apt-get update \
    && apt-get -y install gcc libpq-dev \
    && apt-get clean

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application project files
COPY . .

# Expose the port (8080 is standard for Google Cloud Run, Render, etc.)
EXPOSE 8080

# Initialize the database (if using SQLite locally in the container)
RUN python -c "import sqlite3; sqlite3.connect('nextbuy.db').executescript(open('schema.sql').read())"

# Run the application using Gunicorn for production
CMD gunicorn --bind 0.0.0.0:$PORT --workers 2 --threads 8 --timeout 0 app:app
```
*(Make sure to add `gunicorn==21.2.0` to your `requirements.txt` file).*

---
