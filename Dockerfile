FROM ubuntu:20.04

LABEL maintainer="Madalin Ignisca"
LABEL version="1.0"
LABEL description="Development environment for the joy and pleasure of php and nodejs developers"
LABEL repo="https://github.com/madalinignisca/devcontainer-php"

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG DEBIAN_FRONTEND=noninteractive

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --create-home --shell /bin/bash --uid ${USER_UID} --gid ${USER_GID} ${USERNAME} \
    && apt-get update \
    && apt-get install -y \
      composer \
      git \
      git-crypt \
      git-doc \
      git-extras \
      git-flow \
      git-lfs \
      git-publish \
      git-quick-stats \
      git-reintegrate \
      git-remote-gcrypt \
      git-repair \
      git-restore-mtime \
      git-secrets \
      git-sizer \
      language-pack-en \
      libpng-dev \
      mysql-client \
      nano \
      nodejs \
      npm \
      postgresql-client \
      php-cli \
      openssl \
      php-bcmath \
      php-curl \
      php-gd \
      php-mbstring \
      php-mysql \
      php-pgsql \
      php-sqlite3 \
      php-xdebug \
      php-xml \
      vim \
    && echo "xdebug.remote_enable=1\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.default_enable=1\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_autostart=1\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.coverage_enable=1\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_connect_back=0\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_log='/tmp/xdebug.log'\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.idekey=\"PHPIDE\"\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_port=9000\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
    && mkdir /workspace \
    && chown ${USER_UID}:${USER_GID} /workspace

VOLUME /workspace
VOLUME /home/laravel

WORKDIR /workspace
HEALTHCHECK NONE

EXPOSE 3000
EXPOSE 8000

USER ${USERNAME}
