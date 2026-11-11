#!/bin/sh
set -e
sed -i 's|^#\(.*/community\)$|\1|' /etc/apk/repositories
apk update
apk add docker docker-cli-compose python3 git nano curl
rc-update add docker default
service docker start
