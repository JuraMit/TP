#!/bin/sh
# Выключить прокси (дома).
# После запуска выполнить:  unset http_proxy https_proxy no_proxy
rm -f /etc/profile.d/proxy.sh /etc/docker/daemon.json

if rc-service docker status >/dev/null 2>&1; then
    rc-service docker restart
fi

echo "Прокси выключен. Выполните:  unset http_proxy https_proxy no_proxy"
