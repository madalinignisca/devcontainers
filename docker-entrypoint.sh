#!/usr/bin/env bash
set -euo pipefail

# Set default DEVELOPER_USERID if not exist
# password is limited by 8 characters
: ${DEVELOPER_USERID:=1000}

sudo usermod -u $DEVELOPER_USERID developer
sudo groupmod -g $DEVELOPER_USERID developer

sudo chown -R developer:developer /projects /home/developer

exec "$@"
