#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y net-tools curl
set -x
#Reboot ve reload provisioning için
sudo kill $( lsof -i:6443 -t )
/usr/local/bin/k3s-uninstall.sh

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip 192.168.56.110 --write-kubeconfig-mode 0644" sh -s -

export PATH=$PATH:/usr/local/bin/
sudo chmod 777 /etc/rancher/k3s/k3s.yaml

#Kubectl bash completion ayarlamaları ve alias tanımlamaları (isteğe bağlı)
sudo apt install bash-completion
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc
source ~/.bashrc

#Master node'umuzun hazır olmasını bekliyoruz (Ready durumuna gelmesi)
kubectl wait --for=condition=Ready node/merkols

#Pod oluşturma
kubectl apply -f /vagrant/deployments.yaml
#Servis oluşturma
kubectl apply -f /vagrant/services.yaml
#Ingress ayarlamaları
kubectl apply -f /vagrant/ingress.yaml
kubectl get all
