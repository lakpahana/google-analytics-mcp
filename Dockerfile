# Use Python 3.11 slim base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements files
COPY pyproject.toml ./

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir .

# Copy application code
COPY analytics_mcp/ ./analytics_mcp/

# Copy Google credentials from project root
COPY application_default_credentials.json ./

# Set Google Application Credentials environment variable
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/application_default_credentials.json

# Set Python path to include the current directory
ENV PYTHONPATH=/app

# Expose port 9000
EXPOSE 9000

# Run the MCP server with SSE transport on port 9000
CMD ["fastmcp", "run", "./analytics_mcp/server.py", "--transport", "sse", "--port", "9000", "--host", "0.0.0.0"]
