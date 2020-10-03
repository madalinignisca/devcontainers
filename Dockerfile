FROM ubuntu:20.04

LABEL maintainer="Madalin Ignisca"
LABEL version="1.0"
LABEL description="Development environment for the joy and pleasure of web developers"
LABEL repo="https://github.com/madalinignisca/devcontainer-php"

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
      language-pack-en \
      libpng-dev \
      man-db \
      manpages \
      mc \
      nano \
      nodejs \
      npm \
      postgresql-client \
      php-cli \
      openssh-client \
      openssl \
      php-apcu \
      php-bcmath \
      php-bz2 \
      php-curl \
      php-gd \
      php-imagick \
      php-intl \
      php-json \
      php-mbstring \
      php-memcached \
      php-mysql \
      php-pgsql \
      php-redis \
      php-sqlite3 \
      php-xdebug \
      php-xml \
      php-zip \
      redis-tools \
      sudo \
      vim-airline \
      vim-airline-themes \
      vim-command-t \
      vim-ctrlp \
      vim-doc \
      vim-editorconfig \
      vim-fugitive \
      vim-haproxy \
      vim-lastplace \
      vim-nox \
      vim-scripts \
      vim-snippets \
      vim-syntastic \
      vim-syntax-docker \
      wget \
      whois \
      yarnpkg \
      zsh \
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
    && mkdir /workspace \
    && chown ${USER_UID}:${USER_GID} /workspace \
    && chsh -s /bin/zsh developer \
    && git clone https://github.com/ohmyzsh/ohmyzsh.git /usr/local/share/oh-my-zsh \
    && cp /usr/local/share/oh-my-zsh/templates/zshrc.zsh-template /home/developer/.zshrc \
    && chown developer:developer /home/developer/.zshrc \
    && sed -i 's/^export ZSH=.*/export ZSH="/usr/local/share/oh-my-zsh"/g' /home/developer/.zshrc \
    && sed -i 's/^# DISABLE_AUTO_UPDATE="true"/DISABLE_AUTO_UPDATE="true"/g' /home/developer/.zshrc \
    && sed -i 's/^# DISABLE_UPDATE_PROMPT="true"/DISABLE_UPDATE_PROMPT="true"/g' /home/developer/.zshrc \
    && sed -i 's/^plugins.*/plugins=(git git-flow-avh dot-env cake drush laravel npm redis-cli symfony wp-cli yarn yii)/g' /home/developer/.zshrc

VOLUME /workspace
VOLUME /home/${USERNAME}

WORKDIR /workspace
HEALTHCHECK NONE

ENV LANG en_US.utf8

EXPOSE 3000
EXPOSE 8000
EXPOSE 8080

USER ${USERNAME}
