#!/usr/bin/bash

kubectl apply -f https://raw.githubusercontent.com/VictoriaMetrics/helm-charts/master/charts/victoria-metrics-k8s-stack/crds/crd.yaml

curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm repo add vm https://victoriametrics.github.io/helm-charts/
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo add authentik https://charts.goauthentik.io
helm repo add gitea-charts https://dl.gitea.io/charts/
helm repo update

###########
## VM
###########
cat > /root/vm-stack.values.yaml << EOL
${VM_STACK}
EOL

kubectl create ns vm-stack
helm --kubeconfig /etc/rancher/k3s/k3s.yaml upgrade --install vm-stack vm/victoria-metrics-k8s-stack -f /root/vm-stack.values.yaml -n vm-stack

###########
## Authentik
###########
cat > /root/authentik.values.yaml << EOL
${AUTHENTIK}
EOL

helm --kubeconfig /etc/rancher/k3s/k3s.yaml upgrade --install authentik authentik/authentik -f authentik.values.yaml

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
