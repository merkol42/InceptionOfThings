#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y net-tools && apt-get install -y curl
sudo apt-get upgrade -y
# sudo swapoff -a
#Reboot ve reload provisioning için
sudo kill $( lsof -i:6443 -t )
sudo /usr/local/bin/k3s-agent-uninstall.sh

if [ "$1" == "control" ]; then
    echo "Installing k3s ..."
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip 192.168.56.110 --write-kubeconfig-mode 0644 --token merkol" sh -s -
    sudo chmod 777 /etc/rancher/k3s/k3s.yaml
    cat /var/lib/rancher/k3s/server/agent-token
    cp /var/lib/rancher/k3s/server/agent-token /vagrant
fi

export TKN=$(cat /vagrant/agent-token)

if [ "$1" == "agent" ]; then
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 --node-ip 192.168.56.111 --token $TKN" sh -s -
fi

#sudo bash -c 'echo "export PATH=\$PATH:/sbin:/usr/sbin" >> /etc/profile.d/k3s.sh'
#sudo bash -c 'echo "alias k=\"kubectl\"" >> /etc/profile.d/k3s.sh'

echo 'export PATH=$PATH:/sbin:/usr/sbin' >> ~/.bashrc # for ifconfig, k3s
echo 'alias k="kubectl"' >> ~/.bashrc
sudo source ~/.bashrc
