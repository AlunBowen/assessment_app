# Dockerfile

FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/assessment_app

# Copy existing application directory contents
COPY . .

# Install Laravel dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Set permissions - ensure www-data has full access to storage and cache
RUN chown -R www-data:www-data /var/www/assessment_app/storage /var/www/assessment_app/bootstrap/cache && \
    chmod -R 775 /var/www/assessment_app/storage /var/www/assessment_app/bootstrap/cache && \
    find /var/www/assessment_app/storage -type d -exec chmod 775 {} \; && \
    find /var/www/assessment_app/storage -type f -exec chmod 664 {} \;

EXPOSE 9000
CMD ["php-fpm"]
