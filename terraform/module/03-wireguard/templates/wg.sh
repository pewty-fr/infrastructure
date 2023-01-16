#!/usr/bin/bash
cat > /etc/wireguard/wg-k3s.conf << EOL
${WG_CONF}
EOL

wg-quick up wg-k3s
wg syncconf wg-k3s <(wg-quick strip wg-k3s)

