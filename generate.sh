#!/usr/bin/env bash

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
echo "[1]: PHP 8.1 / NodeJS 18"
echo "[2]: PHP 8.1 / NodeJS 16 (default)"
echo "[3]: PHP 8.0 / NodeJS 16"
echo "[4]: PHP 8.0 / NodeJS 14"
echo "[5]: PHP 7.4 / NodeJS 14"
echo "[6]: PHP 7.4 / NodeJS 12"
read VERSION

case $VERSION in

  1)
    PHPNODEJS="8.1-18"
    ;;

  2)
    PHPNODEJS="8.1-16"
    ;;

  3)
    PHPNODEJS="8.0-16"
    ;;

  4)
    PHPNODEJS="8.0-14"
    ;;

  5)
    PHPNODEJS="7.4-14"
    ;;

  6)
    PHPNODEJS="7.4-12"
    ;;

  *)
    PHPNODEJS="8.1-16"
    ;;

esac

echo "  dev:
    image: 16nsk/devcontainers:$PHPNODEJS
    command: sleep infinity
    volumes:
      - projects:/projects
    ports:
      - \"${BACKEND_PORT:-8000}:8000\"
      - \"${FRONTEND_PORT:-3000}:3000\"
" >> docker-compose.yaml

echo "POSTGRESQL:"
echo "[1] Postgresql 14"
echo "[2] Postgresql 14 with Postgis 3.2"
echo "[3] Postgresql 12 with Postgis 2.5 (for old projects)"
echo "[ ] Hit enter to skip Postgresql"
read POSTGRESQL

case $POSTGRESQL in

  1)
    POSTGRESQL="postgres:14"
    ;;

  2)
    POSTGRESQL="postgis/postgis:14-3.2"
    ;;

  3)
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
echo "[1] MariaDB 10.7"
echo "[2] MariaDB 10.6 (LTS)"
echo "[3] MariaDB 10.3 (Oldest supported)"
echo "[ ] Hit enter to skip MariaDB"
read MARIADB

case $MARIADB in

  1)
    MARIADB="10.7"
    ;;

  2)
    MARIADB="10.6"
    ;;

  3)
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

echo "Want mailhog?"
read MAILHOG
if [[ -n $MAILHOG ]]; then
echo "  mailhog:
    image: mailhog/mailhog
    ports:
      - \"${FORWARD_MAILHOG_PORT:-8025}:8025\"
" >> docker-compose.yaml
fi

echo "volumes:
  projects:" >> docker-compose.yaml

if [[ -n $POSTGRESQL ]]; then
echo "  postgres:" >> docker-compose.yaml
fi

if [[ -n $MARIADB ]]; then
echo "  mariadb:" >> docker-compose.yaml
fi

echo "{
    \"name\": \"$PRJNAME\",
    \"dockerComposeFile\": \"docker-compose.yaml\",
    \"service\": \"dev\",
    \"workspaceFolder\": \"/projects/workspace\",
    \"shutdownAction\": \"stopCompose\",
    \"settings\": {
        \"terminal.integrated.defaultProfile.linux\": \"bash (login)\",
        \"terminal.integrated.profiles.linux\": {
            \"bash (login)\": {
                \"path\": \"bash\",
                \"args\": [\"-l\"],
                \"icon\": \"terminal-ubuntu\"
            }
        }
    },
    \"extensions\": [
        \"EditorConfig.EditorConfig\",
        \"bmewburn.vscode-intelephense-client\",
        \"calebporzio.better-phpunit\",
        \"dbaeumer.vscode-eslint\",
        \"eamodio.gitlens\",
        \"octref.vetur\",
        \"xdebug.php-debug\"
    ]
}" > .devcontainer.json

echo "All done! Open the folder in Visual Studio Code and run in Containers."
