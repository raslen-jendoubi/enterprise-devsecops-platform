# Use a minimal base image to reduce attack surface
FROM python:3.11-slim

# Create a non-root user
RUN useradd -m secureuser

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

# Switch to non-root user
USER secureuser

# Expose port
EXPOSE 5000

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
