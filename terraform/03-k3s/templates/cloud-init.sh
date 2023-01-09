#!/bin/bash

###########
## Network
###########

cat >> /etc/netplan/60-ens5-vpc.yaml << EOL
      addresses: [${PRIVATE_NET_IP}]
EOL

###########
## Netmaker
###########
netclient join -t eyJhcGljb25uc3RyaW5nIjoiYXBpLm5ldG1ha2VyLnBld3R5Lnh5ejo0NDMiLCJuZXR3b3JrIjoiZGVmYXVsdCIsImtleSI6ImRlYTE1OTQyM2E5MTY2NTIiLCJsb2NhbHJhbmdlIjoiIn0=

###########
## k3s
###########

# init/join
curl -sfL https://get.k3s.io | sh -s - server \
  --token=${K3S_TOKEN} \
  --datastore-endpoint="mysql://username:password@tcp(hostname:3306)/database-name"

      SQL_HOST: "${SQL_HOST}"
      SQL_PORT: "${SQL_PORT}"
      SQL_DB: "${SQL_DB}"
      SQL_USER: "${SQL_USER}"
      SQL_PASS: "${SQL_PASS}"
