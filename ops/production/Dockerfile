# FPM: PHP-FPM container
FROM php:8.4-fpm-alpine AS fpm

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

ARG PHP_EXTS="bcmath ctype fileinfo mbstring pdo pdo_mysql gd pcntl zip"
ARG PHP_PECL_EXTS="redis"

WORKDIR /opt/apps/zero-hunger-project

RUN apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} \
        freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev curl-dev oniguruma-dev libxml2-dev \
    && apk add --no-cache freetype libjpeg-turbo libpng libzip curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) ${PHP_EXTS} \
    && pecl install ${PHP_PECL_EXTS} \
    && docker-php-ext-enable ${PHP_PECL_EXTS} \
    && apk del .build-deps

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
 && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 600M/' /usr/local/etc/php/php.ini \
 && sed -i 's/post_max_size = 8M/post_max_size = 600M/' /usr/local/etc/php/php.ini

RUN chown -R www-data:www-data /opt/apps/zero-hunger-project

USER www-data
EXPOSE 9000
CMD ["php-fpm"]

# Frontend: Node.js container to build frontend assets
FROM node:22-alpine AS frontend

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

# Web: Nginx container to serve the application
FROM nginx:1.26-alpine AS web

WORKDIR /opt/apps/zero-hunger-project

COPY ops/production/nginx/nginx.conf.template \
     /etc/nginx/templates/default.conf.template

# hanya hasil build frontend
COPY --from=frontend /app/public /opt/apps/zero-hunger-project/public

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
