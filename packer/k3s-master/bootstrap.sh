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
curl -sL 'https://apt.netmaker.org/gpg.key' | sudo tee /etc/apt/trusted.gpg.d/netclient.asc
curl -sL 'https://apt.netmaker.org/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/netclient.list
sudo apt update
sudo apt install netclient -y

###########
## k3s
###########
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true sh -
