# Use an official PHP runtime as a parent image
FROM php:8.1-apache

# Install necessary extensions for Moodle
RUN apt-get update && apt-get install && apt-get install nano -y \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev libzip-dev unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd zip mysqli pdo pdo_mysql opcache

# Enable Apache mods
RUN a2enmod rewrite

# Create a custom php.ini file
RUN echo "extension=intl" > /usr/local/etc/php/php.ini \
    && echo "max_input_vars=5000" >> /usr/local/etc/php/php.ini \
    && echo "[intl]" >>  /usr/local/etc/php/php.ini \
    && echo "intl.default_locale = en_utf8" >> /usr/local/etc/php/php.ini \
    && echo "intl.error_level = E_WARNING" >> /usr/local/etc/php/php.ini 

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Set the correct permissions for Moodle
RUN mkdir -p /var/www/moodledata \
    && chown -R www-data:www-data /var/www/html \
    && chown -R www-data:www-data /var/www/moodledata \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/moodledata

# Expose port 80 to the outside world
EXPOSE 80

# Run Apache in the foreground
CMD ["apache2-foreground"]
