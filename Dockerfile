ARG IMAGE=debian
ARG VERSION=10

FROM ${IMAGE}:${VERSION}

ARG DISTRO=debian
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=1000
ARG DEBIAN_FRONTEND=noninteractive
ARG MARIADB_VERSION=10.6
ARG POSTGRESQL_VERSION=13
ARG MONGODB_VERSION=5.0
ARG NODE_VERSION=14
ARG PHP_VERSION=7.4

ENV MC_HOST_local=http://minio:minio123@minio:9000
ENV LC_ALL=C.UTF-8

LABEL maintainer="Madalin Ignisca"
LABEL version="4.x"
LABEL description="Development environment for the joy and pleasure of web developers"
LABEL repo="https://github.com/madalinignisca/devcontainers"

ADD unminimize /tmp/unminimize
ADD https://getcomposer.org/composer-stable.phar /usr/local/bin/composer
ADD https://dl.min.io/client/mc/release/linux-amd64/mc /usr/local/bin/minio

RUN chmod 700 /tmp/unminimize \
    && /tmp/unminimize

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --create-home --shell /bin/bash --uid ${USER_UID} --gid ${USER_GID} ${USERNAME}

ADD .editorconfig /home/${USERNAME}

RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.editorconfig

RUN apt-get update \
    && apt-get upgrade --no-install-recommends -y \
    && apt-get install --no-install-recommends -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg \
      lsb-release \
      openssl \
      software-properties-common

RUN apt-key adv --fetch-keys 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' \
    && echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x $(lsb_release -sc) main" > /etc/apt/sources.list.d/nodesource.list

RUN apt-key adv --fetch-keys 'https://packages.sury.org/php/apt.gpg' \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
    
RUN apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc' \
    && echo "deb  http://ftp.hosteurope.de/mirror/mariadb.org/repo/${MARIADB_VERSION}/${DISTRO} $(lsb_release -cs) main" > /etc/apt/sources.list.d/mariadb.list

RUN apt-key adv --fetch-keys 'https://www.postgresql.org/media/keys/ACCC4CF8.asc' \
    && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-key adv --fetch-keys "https://www.mongodb.org/static/pgp/server-${MONGODB_VERSION}.asc" \
    && echo "deb https://repo.mongodb.org/apt/${DISTRO} $(lsb_release -cs)/mongodb-org/${MONGODB_VERSION} main multiverse" > /etc/apt/sources.list.d/mongodb.list

RUN curl https://packages.redis.io/gpg | apt-key add - \
    && echo "deb https://packages.redis.io/deb $(lsb_release -cs) main" > /etc/apt/sources.list.d/redis.list


RUN apt update \
    && apt-get install --no-install-recommends -y \
      bash-completion \
      build-essential \
      gifsicle \
      git \
      htop \
      iproute2 \
      iputils-ping \
      iputils-tracepath \
      jq \
      jpegoptim \
      less \
      libpng-dev \
      lsof \
      man-db \
      manpages \
      mariadb-client-${MARIADB_VERSION} \
      mc \
      mongodb-org-shell \
      mongodb-org-tools \
      nano \
      net-tools \
      nodejs \
      openssh-client \
      optipng \
      php${PHP_VERSION}-amqp \
      php${PHP_VERSION}-apcu \
      php${PHP_VERSION}-bcmath \
      php${PHP_VERSION}-bz2 \
      php${PHP_VERSION}-cli \
      php${PHP_VERSION}-curl \
      php${PHP_VERSION}-decimal \
      php${PHP_VERSION}-ds \
      php${PHP_VERSION}-gd \
      php${PHP_VERSION}-gmp \
      php${PHP_VERSION}-grpc \
      php${PHP_VERSION}-http \
      php${PHP_VERSION}-imagick \
      php${PHP_VERSION}-imap \
      php${PHP_VERSION}-intl \
      php${PHP_VERSION}-ldap \
      php${PHP_VERSION}-lz4 \
      php${PHP_VERSION}-mailparse \
      php${PHP_VERSION}-maxminddb \
      php${PHP_VERSION}-mbstring \
      php${PHP_VERSION}-mcrypt \
      php${PHP_VERSION}-memcached \
      php${PHP_VERSION}-mongodb \
      php${PHP_VERSION}-msgpack \
      php${PHP_VERSION}-mysql \
      php${PHP_VERSION}-oauth \
      php${PHP_VERSION}-pcov \
      php${PHP_VERSION}-pgsql \
      php${PHP_VERSION}-protobuf \
      php${PHP_VERSION}-psr \
      php${PHP_VERSION}-raphf \
      php${PHP_VERSION}-redis \
      php${PHP_VERSION}-smbclient \
      php${PHP_VERSION}-snmp \
      php${PHP_VERSION}-soap \
      php${PHP_VERSION}-solr \
      php${PHP_VERSION}-sqlite3 \
      php${PHP_VERSION}-ssh2 \
      php${PHP_VERSION}-tidy \
      php${PHP_VERSION}-uuid \
      php${PHP_VERSION}-vips \
      php${PHP_VERSION}-xdebug \
      php${PHP_VERSION}-xhprof \
      php${PHP_VERSION}-xml \
      php${PHP_VERSION}-xmlrpc \
      php${PHP_VERSION}-yaml \
      php${PHP_VERSION}-zip \
      php${PHP_VERSION}-zstd \
      pngquant \
      postgresql-client-${POSTGRESQL_VERSION} \
      procps \
      psmisc \
      python \
      redis-tools \
      rsync \
      sqlite3 \
      sudo \
      time \
      unzip \
      vim-addon-manager \
      vim-ctrlp \
      vim-editorconfig \
      vim-nox \
      wget \
      whois \
      zip

RUN if [ "$PHP_VERSION" = "7.4" ] || [ "$PHP_VERSION" = "7.3" ] ; then apt install --no-install-recommends -y php"${PHP_VERSION}"-propro; fi

RUN vim-addon-manager -w install ctrlp editorconfig

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN echo "xdebug.mode=debug\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.cli_color=1\n" >> /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini

RUN mkdir -p /projects/workspace \
    && chown -R ${USER_UID}:${USER_GID} /projects \
    && chmod 755 /usr/local/bin/composer \
    && chmod 755 /usr/local/bin/minio

RUN wget https://get.symfony.com/cli/installer -O - | bash \
    && mv ~/.symfony/bin/symfony /usr/local/bin/symfony \
    && rm -rf ~/.symfony

RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/projects/.bash_history" \
    && echo $SNIPPET >> "/home/${USERNAME}/.bashrc"
    
COPY bashprompt /tmp/bashprompt

RUN cat /tmp/bashprompt >> /home/${USERNAME}/.bashrc \
    && echo 'export PROMPT_DIRTRIM=4' >> /home/${USERNAME}/.bashrc \
    && rm /tmp/bashprompt
    
COPY aliases /home/${USERNAME}/.bash_aliases
RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bash_aliases

RUN mkdir -p /home/${USERNAME}/.config \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.config

RUN mkdir -p /home/${USERNAME}/.ssh \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh \
    && chmod 700 /home/${USERNAME}/.ssh

VOLUME /projects
VOLUME /home/${USERNAME}/.config
VOLUME /home/${USERNAME}/.ssh

WORKDIR /projects/workspace
HEALTHCHECK NONE

ENV LANG en_US.utf8

USER ${USERNAME}
