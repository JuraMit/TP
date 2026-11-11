#!/bin/sh
# Установка Docker, docker compose, Python и утилит на Alpine Linux.
# Запуск: sh scripts/install.sh   (от root)
set -e

# включаем community-репозиторий (там лежит docker), если он закомментирован
sed -i 's|^#\(.*/community\)$|\1|' /etc/apk/repositories

apk update
apk add docker docker-cli-compose python3 py3-pip git nano curl

rc-update add docker default
service docker start

docker --version
docker compose version
python3 --version
