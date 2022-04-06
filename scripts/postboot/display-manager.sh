#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S \
    lightdm \
    lightdm-gtk-greeter \
    lightdm-webkit2-greeter
yay -S lightdm-webkit-theme-aether

sudo systemctl enable lightdm

# Configure displays before login
sudo sed -i -r \
    "s|^#(greeter-setup-script=)$|\1$REPO_DIR/scripts/configure-display.sh|" \
    /etc/lightdm/lightdm.conf
