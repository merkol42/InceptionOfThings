#!/bin/bash

BLUE='\033[0;34m'
COLOR_RESET='\033[0m'

# Script'in bulunduğu dizine geçiş yap
SCRIPT_DIR=$(dirname "$(realpath "$0")")
cd "$SCRIPT_DIR"

# Docker'ın kurulu olup olmadığını kontrol et
if ! command -v docker &> /dev/null; then
  echo -e "${BLUE}Docker is not installed. Installing Docker...${COLOR_RESET}"

  # Docker konfigürasyon dizinini oluştur
  sudo mkdir -p /etc/docker
  echo "{\"dns\": [\"8.8.8.8\", \"8.8.4.4\"]}" | sudo tee /etc/docker/daemon.json

  # Docker'ın resmi GPG anahtarını ekle
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Docker repository'sini Apt kaynaklarına ekle
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "bookworm") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  # Docker ve ilgili paketleri yükle
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Docker grubuna kullanıcı ekle
  sudo usermod -aG docker $USER
  sudo usermod -aG docker root
else
  echo -e "${BLUE}Docker is already installed.${COLOR_RESET}"
fi

# `new.sh` scriptinin çalıştırılması için docker grubunu kullan
newgrp docker << EOM
if [ -f "./new.sh" ]; then
  echo -e "${BLUE}Running new.sh...${COLOR_RESET}"
  ./new.sh
else
  echo -e "${BLUE}new.sh script not found.${COLOR_RESET}"
fi
EOM