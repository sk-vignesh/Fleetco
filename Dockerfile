FROM php:8.2-apache

# Enable PostgreSQL extension (required for Supabase)
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy the fleetco app into Apache's web root
COPY fleetco/ /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/

# Railway uses PORT env variable
RUN sed -i 's/80/${PORT}/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

EXPOSE ${PORT}
