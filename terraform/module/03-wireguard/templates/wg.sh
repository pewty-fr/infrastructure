#!/usr/bin/bash
cat > /etc/wireguard/wg-pewty.conf << EOL
${WG_CONF}
EOL

wg-quick up wg-pewty
wg syncconf wg-pewty <(wg-quick strip wg-pewty)

