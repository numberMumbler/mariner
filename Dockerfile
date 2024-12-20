# Dockerfile
FROM python:3.12-slim

# Install dependencies
WORKDIR /app
COPY . /app
RUN apt-get update && apt-get install -y cron && \
    pip install --no-cache-dir -r requirements.txt

# Expose Luigi's default port
EXPOSE 8082

# Add the cron job for running the pipeline daily
RUN echo "PATH=/usr/local/bin:/usr/bin:/bin\n0 */1 * * * /app/daily_fetch.sh" > /etc/cron.d/daily_fetch && \
    chmod 0644 /etc/cron.d/daily_fetch && \
    crontab /etc/cron.d/daily_fetch

# Default command to start the Luigi scheduler
CMD ["sh", "-c", "cron && luigid --port 8082"]
