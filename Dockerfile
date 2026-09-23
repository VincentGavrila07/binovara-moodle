ARG PHP_VERSION=8.3
FROM php:${PHP_VERSION}-apache-bookworm

ARG PHP_MEMORY_LIMIT=512M

# Moodle 5.1 requires PHP 8.2+ and the extensions below for MySQL.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" gd intl mysqli opcache soap zip \
    && a2enmod expires headers rewrite \
    && rm -rf /var/lib/apt/lists/*

COPY docker/php.ini /usr/local/etc/php/conf.d/moodle.ini
RUN printf 'memory_limit = %s\n' "$PHP_MEMORY_LIMIT" > /usr/local/etc/php/conf.d/memory-limit.ini

COPY . /var/www/moodle/
# The local config.php is excluded by .dockerignore. This Docker-specific one
# obtains its values from the Compose environment at container start.
COPY docker/config.php /var/www/moodle/config.php

RUN sed -ri 's!/var/www/html!/var/www/moodle/public!g' /etc/apache2/sites-available/000-default.conf \
    && printf '%s\n' \
        'ServerName localhost' \
        '<Directory /var/www/moodle/public>' \
        '    AllowOverride All' \
        '    Require all granted' \
        '</Directory>' > /etc/apache2/conf-available/moodle.conf \
    && a2enconf moodle \
    && mkdir -p /var/moodledata \
    && chown -R www-data:www-data /var/www/moodle /var/moodledata

WORKDIR /var/www/moodle/public
