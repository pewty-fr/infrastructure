#!/usr/bin/bash

###########
## k3s
###########

nodeLabels=()
nodeTaints=()
if [[ ! -z "${NODE_LABELS}" ]]
then
  nodeLabels=(--node-label "${NODE_LABELS}")
fi
if [[ ! -z "${NODE_TAINTS}" ]]
then
  nodeTaints=(--node-taint "${NODE_TAINTS}")
fi

options=()
if [ -z "${SERVER_URL}" ]
then
  options=(server --token "${K3S_TOKEN}" --agent-token "${K3S_AGENT_TOKEN}" --datastore-endpoint "postgres://${SQL_USER}:${SQL_PASS}@${SQL_HOST}:${SQL_PORT}/${SQL_DB}" --tls-san ${TLS_SAN} --cluster-cidr=10.42.0.0/16 --service-cidr=10.43.0.0/16) #--cluster-cidr=10.42.0.0/16,fdfb:53d1:48a8::/56 --service-cidr=10.43.0.0/16,dfb:53d1:48a9::/112)
else
  options=(agent --token "${K3S_AGENT_TOKEN}" --server "${SERVER_URL}")
fi

curl -sfL https://get.k3s.io | sh -s - $${options[@]} \
  $${nodeLabels[@]} \
  $${nodeTaints[@]} \
  --node-name ${NODE_ID} \
  --node-ip ${NODE_IP}
