#!/usr/bin/env bash

if [[ $1 = selfupdate ]]; then
  echo "I will update myself"
  cp $(realpath "$0") $(realpath "$0").bak
  curl -o $(realpath "$0") https://raw.githubusercontent.com/madalinignisca/devcontainers/master/generate.sh
  chmod +x $(realpath "$0")
  exit 0
fi

echo "Project name (must be a-z0-9):"
read PRJNAME

if [[ -z $PRJNAME ]]; then
  echo "Must use a project name!"
  exit 1
fi

mkdir $PRJNAME
cd $PRJNAME

echo "services:

" > docker-compose.yaml

echo "Pick a PHP-NodeJS combination":
echo "[0]: PHP 8.2 / NodeJS 18 on Debian"
echo "[1]: PHP 8.1 / NodeJS 18 on Debian"
echo "[2]: PHP 8.1 / NodeJS 18 on Ubuntu (default)"
echo "[3]: PHP 8.1 / NodeJS 16 on Ubuntu"
echo "[4]: PHP 8.0 / NodeJS 16 on Ubuntu"
echo "[5]: PHP 8.0 / NodeJS 14 on Ubuntu"
echo "[6]: PHP 7.4 / NodeJS 14 on Ubuntu"
read VERSION

case $VERSION in

  0)
    PHPNODEJS="8.2-18-debian"
    ;;

  1)
    PHPNODEJS="8.1-18-debian"
    ;;

  2)
    PHPNODEJS="8.1-18"
    ;;

  3)
    PHPNODEJS="8.1-16"
    ;;

  4)
    PHPNODEJS="8.0-16"
    ;;

  5)
    PHPNODEJS="8.0-14"
    ;;

  6)
    PHPNODEJS="7.4-14"
    ;;

  *)
    PHPNODEJS="8.1-18"
    ;;

esac

echo "  dev:
    image: 16nsk/devcontainers:$PHPNODEJS
    command: sleep infinity
    volumes:
      - workspace:/workspace
    ports:
      - \"${BACKEND_PORT:-8000}:8000\"
      - \"${FRONTEND_PORT:-3000}:3000\"
" >> docker-compose.yaml

echo "POSTGRESQL:"
echo "[1] Postgresql 15"
echo "[2] Postgresql 14"
echo "[3] Postgresql 15 with Postgis 3.3 (!NO ARM64)"
echo "[4] Postgresql 12 with Postgis 2.5 (for old projects | !NO ARM64)"
echo "[ ] Hit enter to skip Postgresql"
read POSTGRESQL

case $POSTGRESQL in

  1)
    POSTGRESQL="postgres:15"
    ;;

  2)
    POSTGRESQL="postgres:14"
    ;;

  3)
    POSTGRESQL="postgis/postgis:15-3.3"
    ;;

  4)
    POSTGRESQL="postgis/postgis:12-2.5"
    ;;

esac

if [[ -n $POSTGRESQL ]]; then
echo "  pgsql:
    image: $POSTGRESQL
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


echo "MARIADB:"
echo "[0] MariaDB 10.10"
echo "[1] MariaDB 10.9"
echo "[2] MariaDB 10.8"
echo "[3] MariaDB 10.7"
echo "[4] MariaDB 10.6 (LTS)"
echo "[5] MariaDB 10.3 (Oldest supported)"
echo "[ ] Hit enter to skip MariaDB"
read MARIADB

case $MARIADB in

  0)
    MARIADB="10.10"
    ;;

  1)
    MARIADB="10.9"
    ;;

  2)
    MARIADB="10.8"
    ;;

  3)
    MARIADB="10.7"
    ;;

  4)
    MARIADB="10.6"
    ;;

  5)
    MARIADB="10.3"
    ;;

esac

if [[ -n $MARIADB ]]; then
echo "  mariadb:
    image: mariadb:$MARIADB
    environment:
      - MARIADB_ROOT_PASSWORD=root
      - MARIADB_DATABASE=developer
      - MARIADB_USER=developer
      - MARIADB_PASSWORD=developer
      - MARIADB_AUTO_UPGRADE=true
      - MARIADB_DISABLE_UPGRADE_BACKUP=true
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

echo "Want mailhog? [ENTER to skip]"
read MAILHOG
if [[ -n $MAILHOG ]]; then
echo "  mailhog:
    image: 16nsk/mailhog
    ports:
      - \"${FORWARD_MAILHOG_PORT:-8025}:8025\"
" >> docker-compose.yaml
fi

echo "Want memcached? [ENTER to skip]"
read MEMCACHED
if [[ -n $MEMCACHED ]]; then
echo "  memcached:
    image: memcached:1.6-alpine
" >> docker-compose.yaml
fi

echo "Want redis?"
read REDIS
if [[ -n $REDIS ]]; then
echo "  redis:
    image: redis:7.0-alpine
    command: redis-server --save 60 1 --loglevel warning
    volumes:
      - redis:/data
" >> docker-compose.yaml
fi

echo "volumes:
  workspace:" >> docker-compose.yaml

if [[ -n $POSTGRESQL ]]; then
echo "  postgres:" >> docker-compose.yaml
fi

if [[ -n $MARIADB ]]; then
echo "  mariadb:" >> docker-compose.yaml
fi

if [[ -n $REDIS ]]; then
echo "  redis:" >> docker-compose.yaml
fi

echo "{
    \"name\": \"$PRJNAME\",
    \"dockerComposeFile\": \"docker-compose.yaml\",
    \"service\": \"dev\",
    \"workspaceFolder\": \"/workspace\",
    \"shutdownAction\": \"stopCompose\",
    \"extensions\": [
        \"EditorConfig.EditorConfig\",
        \"bmewburn.vscode-intelephense-client\",
        \"dbaeumer.vscode-eslint\",
        \"eamodio.gitlens\",
        \"xdebug.php-debug\"
    ]
}" > .devcontainer.json

if hash docker-compose 2>/dev/null; then
        docker-compose pull
    else
        docker compose pull
fi

echo "All done! Open the folder in Visual Studio Code and run in Containers."
