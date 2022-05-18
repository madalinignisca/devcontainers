#!/usr/bin/env bash

echo "services:

" > docker-compose.yaml

echo "PHP: [8.1]"
read PHP
if [[ -z $PHP ]]; then
  PHP="8.1"
fi

echo "NODEJS: [18]"
read NODEJS
if [[ -z $NODEJS ]]; then
  NODEJS=18
fi

echo "  dev:
    image: 16nsk/devcontainers:$PHP-$NODEJS
    command: sleep infinity
    volumes:
      - projects:/projects
    ports:
      - \"${BACKEND_PORT:-8000}:8000\"
      - \"${FRONTEND_PORT:-3000}:3000\"
" >> docker-compose.yaml

echo "POSTGRESQL: (only if defined, like 14)"
read POSTGRESQL

if [[ -n $POSTGRESQL ]]; then
VOLUMES=true
echo "  pgsql:
    image: postgres:$POSTGRESQL
    environment:
      - POSTGRES_PASSWORD=developer
      - POSTGRES_USER=developer
      - POSTGRES_DB=developer
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - postgres:/var/lib/postgresql/data
    ports:
      - \"${FORWARD_DB_PORT:-5432}:5432\"
" >> docker-compose.yaml
fi


echo "MARIADB: (only if defined, like 10.7)"
read MARIADB

if [[ -n $MARIADB ]]; then
VOLUMES=true
echo "  mariadb:
    image: mariadb:$MARIADB
    environment:
      - MARIADB_ROOT_PASSWORD=root
      - MARIADB_DATABASE=developer
      - MARIADB_USER=developer
      - MARIADB_PASSWORD=developer
    volumes:
      - mariadb:/var/lib/mysql
    ports:
      - \"${FORWARD_DB_PORT:-3306}:3306\"
" >> docker-compose.yaml
fi

if [[ -n $POSTGRESQL || -n $MARIADB ]]; then
echo "  adminer:
    image: adminer
    ports:
      - \"${FORWARD_ADMINER_PORT:-8080}:8080\"
" >> docker-compose.yaml
fi

echo "Want mailhog? (cat catch smtp sent emails):"
read MAILHOG
if [[ -n $MAILHOG ]]; then
echo "  mailhog:
    image: mailhog/mailhog
    ports:
      - \"${FORWARD_MAILHOG_PORT:-8025}:8025\"
" >> docker-compose.yaml
fi

if [[ $VOLUMES ]]; then
echo "volumes:" >> docker-compose.yaml
fi

if [[ -n $POSTGRESQL ]]; then
echo "  postgres:" >> docker-compose.yaml
fi

if [[ -n $MARIADB ]]; then
echo "  mariadb:" >> docker-compose.yaml
fi

curl -LO https://raw.githubusercontent.com/madalinignisca/devcontainers/master/.devcontainer.json
