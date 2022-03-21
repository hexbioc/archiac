#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm
