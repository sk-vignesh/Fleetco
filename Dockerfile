FROM php:8.2-apache

# Enable PostgreSQL extension (required for Supabase)
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Disable conflicting MPM modules, keep only prefork (required for PHP)
RUN a2dismod mpm_event mpm_worker 2>/dev/null; a2enmod mpm_prefork

# Copy the fleetco app into Apache's web root
COPY fleetco/ /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/

# Create entrypoint script to handle Railway's dynamic PORT
RUN echo '#!/bin/bash\n\
sed -i "s/Listen 80/Listen ${PORT:-80}/" /etc/apache2/ports.conf\n\
sed -i "s/:80/:${PORT:-80}/" /etc/apache2/sites-available/000-default.conf\n\
apache2-foreground' > /usr/local/bin/start.sh \
    && chmod +x /usr/local/bin/start.sh

CMD ["start.sh"]
