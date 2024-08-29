# Use an official PHP runtime as a parent image
FROM php:8.1-apache

# Install necessary extensions for Moodle
RUN apt-get update && apt-get install -y \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev libzip-dev unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd zip mysqli pdo pdo_mysql opcache

# Enable Apache mods
RUN a2enmod rewrite

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Set the correct permissions for Moodle
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port 80 to the outside world
EXPOSE 80

# Run Apache in the foreground
CMD ["apache2-foreground"]
