FROM php:8.2-apache

# Enable PostgreSQL extension (required for Supabase)
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite (mpm_prefork is already the default in php:apache)
RUN a2enmod rewrite

# Copy the fleetco app into Apache's web root
COPY fleetco/ /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/

# Startup script to bind Apache to Railway's dynamic PORT
RUN printf '#!/bin/bash\nsed -i "s/Listen 80/Listen ${PORT:-80}/" /etc/apache2/ports.conf\nsed -i "s/<VirtualHost \\*:80>/<VirtualHost *:${PORT:-80}>/" /etc/apache2/sites-available/000-default.conf\necho "Starting Apache on port ${PORT:-80}"\nexec apache2-foreground\n' > /usr/local/bin/start.sh \
    && chmod +x /usr/local/bin/start.sh

CMD ["start.sh"]
