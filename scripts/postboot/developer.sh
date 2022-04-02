#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S \
    base-devel \
    jq \
    docker \
    cronie \
    xsel \
    zip unzip p7zip \
    firefox-developer-edition

validate_credentials
yay --noconfirm -S \
    nvm

# Setup cron
sudo systemctl enable cronie.service
sudo systemctl start cronie

# Setup docker
sudo systemctl enable docker.service
sudo usermod -aG docker $USER
sudo systemctl start docker

# Setup docker compose v2
validate_credentials
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL \
    https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 \
    -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Install yay
validate_credentials
cd /opt/
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER yay-git/
cd yay-git
makepkg -si

yay --noconfirm -S vscodium-bin
