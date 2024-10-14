FROM php:8.2-fpm

# Copy composer.lock and composer.json
COPY ./composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    libpng-dev \
    libwebp-dev \
    libonig-dev \
    libxml2-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libmcrypt-dev \
    libzip-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpq-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions

RUN pecl install -D 'enable-openssl="yes"' swoole
RUN docker-php-ext-enable swoole
RUN docker-php-ext-install  mbstring zip exif pcntl bcmath soap curl sockets


# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www


# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
