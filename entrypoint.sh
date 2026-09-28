#!/bin/sh
set -e

# Cache config & route
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Jalankan database migration otomatis
php artisan migrate --force

# Start PHP-FPM di background
php-fpm -D

# Start Nginx di foreground
nginx -g "daemon off;"
