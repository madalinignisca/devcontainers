ARG IMAGE=ubuntu
ARG VERSION=20.04

FROM ${IMAGE}:${VERSION}

ARG DISTRO=ubuntu
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=1000
ARG DEBIAN_FRONTEND=noninteractive
ARG NODE_VERSION=19
ARG PHP_VERSION=8.1
ENV LC_ALL=C.UTF-8

LABEL maintainer="Madalin Ignisca"
LABEL version="5.2.0"
LABEL description="Development environment for the joy and pleasure of web developers"
LABEL repo="https://github.com/madalinignisca/devcontainers"

ADD unminimize /tmp/unminimize
RUN chmod 700 /tmp/unminimize \
    && /tmp/unminimize

ADD https://getcomposer.org/composer-stable.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --create-home --shell /bin/bash --uid ${USER_UID} --gid ${USER_GID} ${USERNAME}

ADD .editorconfig /home/${USERNAME}

RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.editorconfig

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
      bind9-dnsutils \
      ca-certificates \
      curl \
      gnupg \
      lsb-release \
      openssl \
      software-properties-common \
      bash-completion \
      build-essential \
      ffmpeg \
      gettext-base \
      git \
      htop \
      jq \
      language-pack-en \
      less \
      lsof \
      man-db \
      manpages \
      mariadb-client \
      mc \
      nano \
      net-tools \
      openssh-client \
      postgresql-client \
      procps \
      psmisc \
      redis-tools \
      rsync \
      sqlite3 \
      sudo \
      time \
      unzip \
      wget \
      whois \
      zip
      
RUN curl 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' | apt-key add - \
    && echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list

RUN add-apt-repository -n ppa:ondrej/php
RUN add-apt-repository -n ppa:openswoole/ppa

RUN apt update \
    && apt-get install -y \
      nodejs \
      php${PHP_VERSION}-apcu \
      php${PHP_VERSION}-bcmath \
      php${PHP_VERSION}-cli \
      php${PHP_VERSION}-curl \
      php${PHP_VERSION}-decimal \
      php${PHP_VERSION}-ds \
      php${PHP_VERSION}-gd \
      php${PHP_VERSION}-gmp \
      php${PHP_VERSION}-intl \
      php${PHP_VERSION}-mbstring \
      php${PHP_VERSION}-mcrypt \
      php${PHP_VERSION}-memcached \
      php${PHP_VERSION}-mongodb \
      php${PHP_VERSION}-mysql \
      php${PHP_VERSION}-openswoole \
      php${PHP_VERSION}-pgsql \
      php${PHP_VERSION}-redis \
      php${PHP_VERSION}-sqlite3 \
      php${PHP_VERSION}-xdebug \
      php${PHP_VERSION}-xhprof \
      php${PHP_VERSION}-xml \
      php${PHP_VERSION}-zip

RUN corepack enable

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN mkdir -p /workspace \
    && chown -R ${USER_UID}:${USER_GID} /workspace

# Default location of Jetbrain's IDE for the container
RUN mkdir -p /opt/project \
    && chown -R ${USER_UID}:${USER_GID} /opt/project

RUN mkdir -p /home/${USERNAME}/.local \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.local \
    && echo "export PROMPT_COMMAND='history -a'" >> "/home/${USERNAME}/.bashrc" \
    && echo "export HISTFILE=/home/${USERNAME}/.local/bash_history" >> "/home/${USERNAME}/.bashrc"
    
COPY bashprompt /tmp/bashprompt
RUN cat /tmp/bashprompt >> /home/${USERNAME}/.bashrc

COPY aliases /home/${USERNAME}/.bash_aliases
RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bash_aliases \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bash_aliases

RUN mkdir -p /home/${USERNAME}/.config \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.config

RUN mkdir -p -m 700 /home/${USERNAME}/.ssh \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh
    
RUN chown -R ${USERNAME}:${USERNAME} /opt

VOLUME /home/${USERNAME}/.config
VOLUME /home/${USERNAME}/.local
VOLUME /home/${USERNAME}/.ssh

WORKDIR /workspace
HEALTHCHECK NONE

ENV LANG en_US.utf8

USER ${USERNAME}
