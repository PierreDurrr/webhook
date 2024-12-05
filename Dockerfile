# Base image with Python
FROM python:3.9-slim-buster

# Copy configuration files and scripts
COPY config/ /config/

# Copy crontab file and set permissions
COPY crontab /var/spool/cron/crontabs/root
RUN chmod 0644 /var/spool/cron/crontabs/root

# Install system dependencies and Python packages
# Edit as needed
RUN apt-get update && \
    apt-get install -y --no-install-recommends nano cron && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r /config/requirements.txt

# Set environment variable if needed
#ENV

# Copy entrypoint script and set execute permissions
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Copy the Flask app into the container
COPY app/ /app/

# Install Flask and any additional required packages
RUN pip install --no-cache-dir Flask

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
