#!/usr/bin/bash

###########
## network
###########
mac_address=$(scw-metadata-json | jq -r '.private_nics[0].mac_address')
interface=$(grep -rl "$${mac_address}" /sys/class/net/*/address | cut -d "/" -f 5)
cat > /etc/netplan/60-$${interface}-vpc.yaml << EOL
network:
  version: 2
  ethernets:
    $${interface}:
      addresses: [${PRIVATE_IP}/${PRIVATE_NETMASK}]
EOL
netplan apply
