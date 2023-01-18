#!/usr/bin/bash

###########
## CSI
###########
git clone https://github.com/kubernetes-csi/external-snapshotter.git
cd external-snapshotter
git pull
kubectl kustomize client/config/crd | kubectl create -f -
kubectl apply -f https://raw.githubusercontent.com/scaleway/scaleway-csi/master/deploy/kubernetes/scaleway-csi-v0.2.0.yaml

###########
## Secrets
###########
cat > /root/secrets.yaml << EOL
${SECRETS}
EOL

kubectl apply -f /root/secrets.yaml
rm /root/secrets.yaml
