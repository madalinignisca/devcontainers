#!/usr/bin/env bash
set -euo pipefail

# Set default DEVELOPER_USERID if not exist
: ${DEVELOPER_USERID:=`id -u $(whoami)`}

sudo usermod -u $DEVELOPER_USERID developer
sudo groupmod -g $DEVELOPER_USERID developer

sudo chown -R developer:developer /projects /home/developer

exec "$@"
