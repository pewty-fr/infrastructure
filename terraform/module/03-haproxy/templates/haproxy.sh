#!/usr/bin/bash
TRAEFIK_PORT=$(kubectl get svc -n kube-system -o json traefik |jq -r '.spec.ports[] | select(.port == 80).nodePort')
cat > /etc/systemd/system/haproxy.service.d/limits.conf << EOL 
[Service]
LimitNOFILE=infinity
EOL
cat > /etc/haproxy/haproxy.cfg << EOL
${CONFIG}
EOL
cat > /etc/haproxy/domaintobackend-public.map << EOL
${PUBLIC_MAP}
EOL
cat > /etc/haproxy/domaintobackend-private.map << EOL
${PRIVATE_MAP}
EOL
mkdir /etc/ssl/private/pem
mc cat scw/pewty-instance-config/cert.pem | tee /etc/ssl/private/pem/pewty.pem

systemctl enable haproxy
systemctl start haproxy
haproxy -c -f /etc/haproxy/haproxy.cfg
if [ $? == 0 ]
then
    service haproxy reload
fi

