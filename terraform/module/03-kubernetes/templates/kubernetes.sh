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
## Traefik
###########
cat > /root/traefik.yaml << EOL
${TRAEFIK}
EOL
kubectl apply -f /root/traefik.yaml

###########
## Secrets
###########
cat > /root/secrets.yaml << EOL
${SECRETS}
EOL

kubectl apply -f /root/secrets.yaml
rm /root/secrets.yaml

###########
## Helm
###########
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm repo add vm https://victoriametrics.github.io/helm-charts/
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo add authentik https://charts.goauthentik.io
helm repo add gitea-charts https://dl.gitea.io/charts/
helm repo add uptime-kuma https://dirsigler.github.io/uptime-kuma-helm
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

###########
## ArgoCD
###########
cat > /root/argocd.values.yaml << EOL
${ARGOCD}
EOL
helm upgrade --install argo argo/argo-cd -f /root/argocd.values.yaml

###########
## VM
###########
cat > /root/vm-stack.values.yaml << EOL
${VM_STACK}
EOL

kubectl apply -f https://raw.githubusercontent.com/VictoriaMetrics/helm-charts/master/charts/victoria-metrics-k8s-stack/crds/crd.yaml
kubectl create ns vm-stack
helm --kubeconfig /etc/rancher/k3s/k3s.yaml upgrade --install vm-stack vm/victoria-metrics-k8s-stack -f /root/vm-stack.values.yaml -n vm-stack

###########
## Authentik
###########
cat > /root/authentik.values.yaml << EOL
${AUTHENTIK}
EOL

helm --kubeconfig /etc/rancher/k3s/k3s.yaml upgrade --install authentik authentik/authentik -f /root/authentik.values.yaml

###########
## Dashboard
###########
cat > /root/dashboard.values.yaml << EOL
${DASHBOARD}
EOL

helm --kubeconfig /etc/rancher/k3s/k3s.yaml upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -f /root/dashboard.values.yaml

###########
## Gitea
###########
cat > /root/gitea.values.yaml << EOL
${GITEA}
EOL

helm --kubeconfig /etc/rancher/k3s/k3s.yaml upgrade --install gitea gitea-charts/gitea -f /root/gitea.values.yaml

###########
## Uptime Kuma
###########
cat > /root/uptime-kuma.values.yaml << EOL
${UPTIME_KUMA}
EOL

helm --kubeconfig /etc/rancher/k3s/k3s.yaml upgrade --install uptime-kuma uptime-kuma/uptime-kuma -f /root/uptime-kuma.values.yaml


###########
## echoip
###########
cat > /root/echoip.yaml << EOL
${ECHOIP}
EOL

kubectl apply -f /root/echoip.yaml

###########
## ntfy
###########
cat > /root/ntfy.yaml << EOL
${NTFY}
EOL

kubectl apply -f /root/ntfy.yaml
