#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S zsh xterm alacritty
ln -s "$REPO_DIR/configurations/alacritty" ~/.config/alacritty

# Setup zsh
sudo chsh -s $(which zsh)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
