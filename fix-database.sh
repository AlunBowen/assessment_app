#!/bin/bash

# Script to fix database issues and run migrations

echo "Running Laravel migrations..."
cd /var/www/assessment_app

# Clear Laravel caches
php artisan config:clear
php artisan cache:clear
php artisan view:clear

# Run migrations (with force to run in production)
php artisan migrate --force

echo "Checking if sessions table exists..."
# This command checks if the sessions table exists
php artisan db:table sessions

# If the sessions table doesn't exist, we'll create it manually
if [ $? -ne 0 ]; then
    echo "Creating sessions table manually..."
    
    # Get database credentials from the .env file
    DB_HOST=$(grep DB_HOST .env | cut -d '=' -f2)
    DB_PORT=$(grep DB_PORT .env | cut -d '=' -f2)
    DB_DATABASE=$(grep DB_DATABASE .env | cut -d '=' -f2)
    DB_USERNAME=$(grep DB_USERNAME .env | cut -d '=' -f2)
    DB_PASSWORD=$(grep DB_PASSWORD .env | cut -d '=' -f2)
    
    # SQL to create the sessions table
    SQL="CREATE TABLE IF NOT EXISTS sessions (
        id VARCHAR(255) NOT NULL PRIMARY KEY,
        user_id BIGINT UNSIGNED NULL,
        ip_address VARCHAR(45) NULL,
        user_agent TEXT NULL,
        payload TEXT NOT NULL,
        last_activity INT NOT NULL,
        INDEX sessions_user_id_index (user_id),
        INDEX sessions_last_activity_index (last_activity)
    );"
    
    # Execute the SQL
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_DATABASE" -e "$SQL"
    
    echo "Sessions table created manually."
fi

echo "Setting proper permissions..."
# Fix permissions
chown -R www-data:www-data /var/www/assessment_app/storage
chmod -R 775 /var/www/assessment_app/storage

echo "Database setup complete!"