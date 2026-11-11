#!/bin/sh
# Включить прокси (нужно в вузе, где нет прямого доступа к интернету).
# Запуск: sh scripts/proxy-on.sh [адрес]   по умолчанию http://172.27.100.5:4444
# После запуска выполнить:  . /etc/profile.d/proxy.sh
PROXY=${1:-http://172.27.100.5:4444}

# 1) прокси для shell: apk, git, curl, а также для docker compose build
cat > /etc/profile.d/proxy.sh <<EOF
export http_proxy=$PROXY
export https_proxy=$PROXY
export no_proxy=localhost,127.0.0.1
EOF

# 2) прокси для демона docker (скачивание образов с Docker Hub)
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "proxies": {
    "http-proxy": "$PROXY",
    "https-proxy": "$PROXY",
    "no-proxy": "localhost,127.0.0.1"
  }
}
EOF

if rc-service docker status >/dev/null 2>&1; then
    rc-service docker restart
fi

echo "Прокси $PROXY включён. Теперь выполните:  . /etc/profile.d/proxy.sh"
