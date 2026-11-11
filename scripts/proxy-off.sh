#!/bin/sh
rm -f /etc/profile.d/proxy.sh /etc/docker/daemon.json
rc-service docker restart
