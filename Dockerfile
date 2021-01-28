FROM ubuntu:20.04

LABEL maintainer="Madalin Ignisca"
LABEL version="2.0.0"
LABEL description="Development environment for the joy and pleasure of web developers"
LABEL repo="https://github.com/madalinignisca/devcontainers"

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG DEBIAN_FRONTEND=noninteractive
ARG DISTRO=focal
ARG NODE_VERSION=node_12.x
ARG PHP_VERSION=7.4

ADD unminimize /tmp/unminimize
ADD https://getcomposer.org/download/2.0.8/composer.phar /usr/local/bin/composer
ADD https://deb.nodesource.com/gpgkey/nodesource.gpg.key /tmp/nodesource.gpg.key

RUN chmod 700 /tmp/unminimize \
    && /tmp/unminimize

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --create-home --shell /bin/bash --uid ${USER_UID} --gid ${USER_GID} ${USERNAME}

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
      gnupg \
      software-properties-common \
    && apt-key add /tmp/nodesource.gpg.key \
    && echo "deb https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list \
    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get install -y \
      bash-completion \
      build-essential \
      curl \
      default-mysql-client \
      git \
      iproute2 \
      iputils-ping \
      iputils-tracepath \
      jq \
      language-pack-en \
      libpng-dev \
      man-db \
      manpages \
      mc \
      nano \
      nodejs \
      openssh-client \
      openssl \
      postgresql-client \
      php${PHP_VERSION}-amqp \
      php${PHP_VERSION}-apcu \
      php${PHP_VERSION}-bcmath \
      php${PHP_VERSION}-bz2 \
      php${PHP_VERSION}-cli \
      php${PHP_VERSION}-curl \
      php${PHP_VERSION}-gd \
      php${PHP_VERSION}-gmp \
      php${PHP_VERSION}-imagick \
      php${PHP_VERSION}-intl \
      php${PHP_VERSION}-json \
      php${PHP_VERSION}-mbstring \
      php${PHP_VERSION}-memcached \
      php${PHP_VERSION}-mongodb \
      php${PHP_VERSION}-mysql \
      php${PHP_VERSION}-pcov \
      php${PHP_VERSION}-pgsql \
      php${PHP_VERSION}-raphf
      php${PHP_VERSION}-redis \
      php${PHP_VERSION}-soap \
      php${PHP_VERSION}-sqlite3 \
      php${PHP_VERSION}-uuid \
      php${PHP_VERSION}-xdebug \
      php${PHP_VERSION}-xml \
      php${PHP_VERSION}-zip \
      redis-tools \
      sudo \
      wget \
      whois \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && echo "xdebug.remote_enable=1\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.default_enable=1\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_autostart=1\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.coverage_enable=1\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_connect_back=0\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_log='/tmp/xdebug.log'\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.idekey=\"PHPIDE\"\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_port=9000\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/docker-php-ext-xdebug.ini \
    && mkdir -p /projects/workspace \
    && chown -R ${USER_UID}:${USER_GID} /projects \
    && chmod 755 /usr/local/bin/composer

VOLUME /projects
VOLUME /home/${USERNAME}

WORKDIR /projects/workspace
HEALTHCHECK NONE

ENV LANG en_US.utf8

USER ${USERNAME}
