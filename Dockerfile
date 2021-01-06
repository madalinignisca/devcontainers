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
      default-mysql-client \
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
      php-amqp \
      php-apcu \
      php-bcmath \
      php-bz2 \
      php-cli \
      php-curl \
      php-gd \
      php-gmp \
      php-imagick \
      php-intl \
      php-json \
      php-mbstring \
      php-memcached \
      php-mongodb \
      php-mysql \
      php-pcov \
      php-pgsql \
      php-redis \
      php-soap \
      php-sqlite3 \
      php-uuid \
      php-xdebug \
      php-xml \
      php-zip \
      redis-tools \
      sudo \
      wget \
      whois \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && echo "xdebug.remote_enable=1\n" >> /etc/php/8.0/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.default_enable=1\n" >> /etc/php/8.0/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_autostart=1\n" >> /etc/php/8.0/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.coverage_enable=1\n" >> /etc/php/8.0/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_connect_back=0\n" >> /etc/php/8.0/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_log='/tmp/xdebug.log'\n" >> /etc/php/8.0/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.idekey=\"PHPIDE\"\n" >> /etc/php/8.0/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_port=9000\n" >> /etc/php/8.0/cli/conf.d/docker-php-ext-xdebug.ini \
    && mkdir -p /projects/workspace \
    && chown -R ${USER_UID}:${USER_GID} /projects \
    && chmod 755 /usr/local/bin/composer

VOLUME /projects
VOLUME /home/${USERNAME}

WORKDIR /projects/workspace
HEALTHCHECK NONE

ENV LANG en_US.utf8

USER ${USERNAME}
