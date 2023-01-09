#!/bin/bash

cat > /etc/netmaker/docker-compose.yml << EOL
${DOCKER_COMPOSE}
EOL

cat > /etc/netmaker/Caddyfile << EOL
${CADDYFILE}
EOL

cat > /etc/netplan/60-ens5-vpc.yaml << EOL
${ENS5}
EOL
netplan apply

cd /etc/netmaker/
docker-compose up -d 
