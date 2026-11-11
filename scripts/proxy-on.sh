#!/bin/sh
PROXY=${1:-http://172.27.100.5:4444}

cat > /etc/profile.d/proxy.sh <<END
export http_proxy=$PROXY
export https_proxy=$PROXY
export no_proxy=localhost,127.0.0.1
END

mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<END
{ "proxies": { "http-proxy": "$PROXY", "https-proxy": "$PROXY", "no-proxy": "localhost,127.0.0.1" } }
END

rc-service docker restart
