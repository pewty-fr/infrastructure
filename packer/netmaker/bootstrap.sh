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
dpkg-reconfigure unattended-upgrades -y

###########
## Netmaker
###########
apt install -y docker.io docker-compose wireguard

mkdir /etc/netmaker
wget -q -O /etc/netmaker/mosquitto.conf https://raw.githubusercontent.com/gravitl/netmaker/master/docker/mosquitto.conf
wget -q -O /etc/netmaker/wait.sh https://raw.githubusercontent.com/gravitl/netmaker/develop/docker/wait.sh
chmod +x /etc/netmaker/wait.sh

wget -q -O /etc/netmaker/Caddyfile https://raw.githubusercontent.com/gravitl/netmaker/master/docker/Caddyfile

