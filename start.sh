#!/bin/bash
# Replace Apache's port with Railway's PORT (defaults to 80 if not set)
sed -i "s/Listen 80/Listen ${PORT:-80}/" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT:-80}>/" /etc/apache2/sites-available/000-default.conf

echo "Starting Apache on port ${PORT:-80}"
apache2-foreground
