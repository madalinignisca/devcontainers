FROM ubuntu:20.04

LABEL maintainer="Madalin Ignisca"
LABEL version="1.3.0"
LABEL description="Development environment for the joy and pleasure of web developers"
LABEL repo="https://github.com/madalinignisca/devcontainers"

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG DEBIAN_FRONTEND=noninteractive

ADD unminimize /tmp/unminimize

RUN chmod 700 /tmp/unminimize \
    && /tmp/unminimize \
    && rm /tmp/unminimize \
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --create-home --shell /bin/bash --uid ${USER_UID} --gid ${USER_GID} ${USERNAME} \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
      bash-completion \
      build-essential \
      composer \
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
      npm \
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
      yarnpkg \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && echo "xdebug.remote_enable=1\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.default_enable=1\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_autostart=1\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.coverage_enable=1\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_connect_back=0\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_log='/tmp/xdebug.log'\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.idekey=\"PHPIDE\"\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
         "xdebug.remote_port=9000\n" >> /etc/php/7.4/cli/conf.d/docker-php-ext-xdebug.ini \
    && mkdir -p /projects/workspace \
    && chown -R ${USER_UID}:${USER_GID} /projects

VOLUME /projects
VOLUME /home/${USERNAME}

WORKDIR /projects/workspace
HEALTHCHECK NONE

ENV LANG en_US.utf8

USER ${USERNAME}
