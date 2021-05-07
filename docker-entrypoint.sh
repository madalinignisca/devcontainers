#!/usr/bin/env bash
set -euo pipefail

# Set default DEVELOPER_USERID if not exist
# password is limited by 8 characters
: ${DEVELOPER_USERID:=1000}

usermod -u $DEVELOPER_USERID developer
groupmod -g $DEVELOPER_USERID developer

chown -R developer:developer /workspace

exec "$@"
