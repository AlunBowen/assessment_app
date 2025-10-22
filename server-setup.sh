#!/bin/bash

# Script to install PHP and required extensions for Laravel
echo "Installing PHP and required extensions for Laravel..."

# Update package lists
sudo apt update

# Install PHP 8.2 and common extensions needed for Laravel
sudo apt install -y php8.2-cli php8.2-fpm php8.2-mysql php8.2-curl php8.2-gd php8.2-mbstring php8.2-xml php8.2-zip php8.2-bcmath

# Verify PHP installation
php -v

# Install Composer (PHP package manager)
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Navigate to your Laravel application directory
cd /var/www/assessment_app

# Install Laravel dependencies
echo "Installing Laravel dependencies with Composer..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# Set proper permissions
echo "Setting proper file permissions..."
sudo chown -R www-data:www-data /var/www/assessment_app/storage /var/www/assessment_app/bootstrap/cache
sudo chmod -R 775 /var/www/assessment_app/storage /var/www/assessment_app/bootstrap/cache

# Copy the environment file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file from example..."
    cp .env.example .env
    # Generate application key
    php artisan key:generate
fi

# Configure the database in .env file
echo "Please update your database credentials in the .env file if needed"
echo "Then run the migrations with: php artisan migrate"

# Run migrations
read -p "Would you like to run migrations now? (y/n): " run_migrations
if [ "$run_migrations" = "y" ]; then
    php artisan migrate --force
fi

echo "PHP installation and setup complete!"
echo "You can now run Laravel commands using the 'php artisan' command."