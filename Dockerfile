FROM php:8.2-cli

# Enable PostgreSQL extension (required for Supabase)
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the fleetco app
COPY fleetco/ /app/

# Set working directory
WORKDIR /app

# Set proper permissions
RUN chown -R www-data:www-data /app/ \
    && chmod -R 755 /app/

# Use PHP's built-in server — simple and reliable
CMD php -S 0.0.0.0:${PORT:-8080} -t /app/
