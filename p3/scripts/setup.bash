#!/usr/bin/env bash

#Root kontrolü
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root"
  exit 1
fi

set -e  # Hata durumunda işlemi durdur
set -x  # Adım adım çalıştırma modunu aç

# docker
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc # Burada docker.asc bazen hata verebilir, o zaman elle eklemek gerekebilir.
sudo chmod a+r /etc/apt/keyrings/docker.asc # Burada docker.asc bazen hata verebilir, o zaman elle eklemek gerekebilir.

# Add the repository to Apt sources: Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# kubectl ve and k3d
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

k3d cluster create mycluster --wait
kubectl create namespace argocd

# installing argocd in k3s cluster
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml