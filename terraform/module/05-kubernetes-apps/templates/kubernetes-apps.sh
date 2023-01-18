#!/usr/bin/bash

kubectl apply -f https://raw.githubusercontent.com/VictoriaMetrics/helm-charts/master/charts/victoria-metrics-k8s-stack/crds/crd.yaml

curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm repo add vm https://victoriametrics.github.io/helm-charts/
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

cat > /root/vm-stack.values.yaml << EOL
${VM_STACK}
EOL

kubectl create ns vm-stack
helm --kubeconfig /etc/rancher/k3s/k3s.yaml install vm-stack vm/victoria-metrics-k8s-stack -f /root/vm-stack.values.yaml -n vm-stack
