ARG IMAGE=ubuntu
ARG VERSION=22.04

FROM ${IMAGE}:${VERSION}

ARG DISTRO=ubuntu
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=1000
ARG DEBIAN_FRONTEND=noninteractive
ARG PHP_VERSION=8.3
ARG NVM_VERSION=0.39.7
ENV LC_ALL=C.UTF-8

LABEL maintainer="Madalin Ignisca"
LABEL version="7.0.0"
LABEL description="Development environment for the joy and pleasure of web developers"
LABEL repo="https://github.com/madalinignisca/devcontainers"

ADD unminimize /tmp/unminimize
RUN chmod 700 /tmp/unminimize \
    && /tmp/unminimize

ADD https://getcomposer.org/composer-stable.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --create-home --shell /bin/bash --uid ${USER_UID} --gid ${USER_GID} ${USERNAME}

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

RUN add-apt-repository -n ppa:ondrej/php \
    && apt-get update -y \
    && apt-get install -y \
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
      php${PHP_VERSION}-memcached \
      php${PHP_VERSION}-mongodb \
      php${PHP_VERSION}-mysql \
      php${PHP_VERSION}-pgsql \
      php${PHP_VERSION}-redis \
      php${PHP_VERSION}-sqlite3 \
      php${PHP_VERSION}-xdebug \
      php${PHP_VERSION}-xhprof \
      php${PHP_VERSION}-xml \
      php${PHP_VERSION}-zip


RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN mkdir -p /workspace \
    && chown ${USERNAME}:${USERNAME} /workspace

HEALTHCHECK NONE

ENV LANG en_US.utf8

USER ${USERNAME}

ADD .editorconfig /home/${USERNAME}

COPY bashprompt /tmp/bashprompt
RUN cat /tmp/bashprompt >> /home/${USERNAME}/.bashrc

RUN mkdir -p /home/${USERNAME}/.local \
    && echo "export PROMPT_COMMAND='history -a'" >> "/home/${USERNAME}/.bashrc" \
    && echo "export HISTFILE=/home/${USERNAME}/.local/bash_history" >> "/home/${USERNAME}/.bashrc"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
    && mkdir /home/${USERNAME}/.nvm/versions

VOLUME /workspace
VOLUME /home/${USERNAME}/.nvm/versions
WORKDIR /workspace