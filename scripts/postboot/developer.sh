#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S \
    base-devel \
    firefox-developer-edition

# Install yay
cd /opt/
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER yay-git/
cd yay-git
makepkg -si

yay --noconfirm -S vscodium-bin
