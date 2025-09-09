# Base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy app files
COPY app/ /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 80

# Run app
CMD ["python", "main.py"]
