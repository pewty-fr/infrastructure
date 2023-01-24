#!/bin/bash

apt update && apt-get upgrade -y

###########
## Disable vpc autoconfig
###########
mv /lib/udev/rules.d/72-scw-vpc-iface.rules /lib/udev/rules.d/.72-scw-vpc-iface.rules

###########
## Unattended upgrade
###########
apt install unattended-upgrades -y
dpkg-reconfigure unattended-upgrades

###########
## Wireguard
###########
apt install wireguard -y

###########
## k3s
###########
apt install helm -y
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true sh -

###########
## minio
###########
apt install jq -y
curl -L https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
chmod +x /usr/local/bin/mc
mc alias set scw https://s3.fr-par.scw.cloud $SCW_ACCESS_KEY $SCW_SECRET_KEY --api S3v4

###########
## haproxy
###########
apt install -y haproxy
systemctl stop haproxy
systemctl disable haproxy

###########
## pewty
###########
mv /tmp/pewty.service /etc/systemd/system/pewty.service
systemctl daemon-reload
systemctl enable pewty
