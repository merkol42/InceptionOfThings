#!/bin/bash

sudo apt-get remove -y docker-ce docker-ce-cli containerd.io
sudo apt-get purge docker-ce docker-ce-cli containerd.io -y
sudo rm -rf /var/lib/docker
sudo groupdel docker
sudo apt-get update

sudo k3s-uninstall.sh

sudo rm /usr/local/bin/kubectl

sudo rm /usr/local/bin/k3d

sudo groupdel docker
sudo userdel -r docker


kubectl delete namespace gitlab
sudo rm -rf /usr/local/bin/helm
rm -rf ~/.helm
sudo apt-get remove helm -y
sudo rm -rf ~/.config/helm


sudo rm -rf /etc/apt/sources.list.d/docker.list
sudo rm -rf /etc/docker
sudo rm -rf /usr/local/bin/argocd
sudo apt-get clean
sudo apt-get update
rm -rf .git
