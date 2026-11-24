# Use Python 3.12 lightweight image
FROM python:3.12-slim

# Prevent Python from creating unnecessary bytecode files
ENV PYTHONDONTWRITEBYTECODE=1

# Display Python logs immediately
ENV PYTHONUNBUFFERED=1

# Set working directory inside container
WORKDIR /app

# Copy dependency file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy Flask application package
COPY app/ ./app/

# Copy WSGI entry point
COPY wsgi.py .

# Copy local development entry point
COPY app.py .

# Expose Flask application port
EXPOSE 5000

# Start Flask application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--access-logfile", "-", "--error-logfile", "-", "wsgi:app"]