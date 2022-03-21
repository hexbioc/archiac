#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S zsh xterm alacritty neofetch
ln --force -s "$REPO_DIR/configurations/alacritty" ~/.config/alacritty

# Setup zsh and neofetch
sudo usermod --shell $(which zsh) $USER
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ln --force -s "$REPO_DIR/dotfiles/.zshrc" ~/.zshrc
ln --force -s "$REPO_DIR/configurations/neofetch" ~/.config/neofetch
