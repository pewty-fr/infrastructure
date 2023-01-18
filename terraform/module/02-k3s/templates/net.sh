#!/usr/bin/bash

###########
## network
###########
interface=$(ls -1 /sys/class/net/*/address | grep "ens" | grep -v "ens2" | cut -d "/" -f 5)
if [ -z "$${interface}" ]
then
  return
fi
cat > /etc/netplan/60-$${interface}-vpc.yaml << EOL
network:
  version: 2
  ethernets:
    $${interface}:
      addresses: [${PRIVATE_IP}/${PRIVATE_NETMASK}]
%{ if length(MASTER_PRIVATE_IPS) > 0 ~}
      routes:
%{ for n, ip in MASTER_PRIVATE_IPS ~}
        - to: default
          via: ${ip}
          metric: $(( $${RANDOM} % 30 + 10 + ${n} ))
%{ endfor ~}
%{ endif ~}
EOL
netplan apply
