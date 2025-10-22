#!/bin/bash

# Script to fix Laravel storage permissions
echo "Fixing Laravel storage permissions..."

# Set ownership to www-data (the web server user)
chown -R www-data:www-data /var/www/assessment_app/storage
chown -R www-data:www-data /var/www/assessment_app/bootstrap/cache

# Set directory permissions to 775 (drwxrwxr-x)
find /var/www/assessment_app/storage -type d -exec chmod 775 {} \;
chmod -R 775 /var/www/assessment_app/bootstrap/cache

# Set file permissions to 664 (rw-rw-r--)
find /var/www/assessment_app/storage -type f -exec chmod 664 {} \;

# Create any required directories if they don't exist
mkdir -p /var/www/assessment_app/storage/framework/sessions
mkdir -p /var/www/assessment_app/storage/framework/views
mkdir -p /var/www/assessment_app/storage/framework/cache/data

# Set permissions on these directories
chmod -R 775 /var/www/assessment_app/storage/framework/sessions
chmod -R 775 /var/www/assessment_app/storage/framework/views
chmod -R 775 /var/www/assessment_app/storage/framework/cache


echo "Permissions have been fixed."