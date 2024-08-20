#!/bin/bash

# Root kontrolü
# if [ "$EUID" -ne 0 ]; then
#   echo "Please run this script as root"
#   exit 1
# fi

BLUE='\033[0;34m'
COLOR_RESET='\033[0m'
USERNAME=$(whoami)
domain=$(hostname)
token=glpat-q1tdxDFFNz_NZ9MtyJxz

set -e  # Hata durumunda işlemi durdur
# set -x  # Adım adım çalıştırma modunu aç

if ! command -v kubectl &> /dev/null; then
  echo -e "${BLUE}kubectl is not installed. Installing...${COLOR_RESET}"
  
  # `kubectl` binary dosyasını indir
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  
  # `kubectl` hash dosyasını indir
  curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
  
  # Hash dosyasını doğrula
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
  
  # chmod +x kubectl
  # mkdir -p ~/.local/bin
  # mv ./kubectl ~/.local/bin/kubectl
  
  # `kubectl`'i yükle
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  alias k=kubectl
  echo -e "${BLUE}kubectl has been installed.${COLOR_RESET}"
else
  echo -e "${BLUE}kubectl is already installed.${COLOR_RESET}"
fi

# Helm kurulumu
if ! command -v helm &> /dev/null; then
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  echo -e "${BLUE}helm has been installed.${COLOR_RESET}"
else
  echo -e "${BLUE}helm is already installed.${COLOR_RESET}"
fi

# K3d kurulumu
if ! command -v k3d &> /dev/null; then
  wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
  echo -e "${BLUE}k3d has been installed.${COLOR_RESET}"
else
  echo -e "${BLUE}k3d is already installed.${COLOR_RESET}"
fi

# k3d cluster create bonus --wait --k3s-arg '--disable=traefik@server:*' --api-port 6550 -p "443:443@loadbalancer" -a 5 #-p "$IP:23:22@loadbalancer" -p "$IP:80:80@LoadBalancer"

# kubectl create namespace gitlab
# kubectl create namespace dev

# # `kubectl` ile Argo CD kurulumunu yap
# kubectl create namespace argocd
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# # ArgocdCLI kurulumunu yap
# curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
# sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
# rm argocd-linux-amd64

# # GitLab Helm deposunu ekleme ve güncelleme
# helm repo add gitlab https://charts.gitlab.io/
# helm repo update

echo -e "${BLUE}Şuanda burdasın $(pwd)${COLOR_RESET}"

# GitLab'ı kurma
helm install gitlab gitlab/gitlab \
    --set certmanager-issuer.email="metekhann@gmail.com" \
    --set global.hosts.https=false \
    --set global.hosts.gitlab.name="gitlab.merkol.com" \
    -f ../confs/values.yaml \
    -n gitlab --create-namespace 
  
#Warning   Unhealthy                      pod/gitlab-sidekiq-all-in-1-v2-675b57747f-lkfzt          Readiness probe failed: Get "http://10.42.5.18:3808/readiness": dial tcp 10.42.5.18:3808: connect: connection refused