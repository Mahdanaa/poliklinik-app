# Stage 1: Build Frontend Assets
FROM node:20-alpine AS frontend
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Application Runner
FROM php:8.3-fpm-alpine

# Install system dependencies & PHP extensions
RUN apk add --no-cache \
    nginx \
    curl \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    oniguruma-dev \
    ca-certificates \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy source code
COPY . .

# Copy hasil build frontend dari Stage 1
COPY --from=frontend /app/public/build ./public/build

# Install dependencies PHP (tanpa dev)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Set permission folder storage & bootstrap/cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Setup Nginx & Entrypoint
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
