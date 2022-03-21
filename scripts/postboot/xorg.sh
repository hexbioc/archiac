#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S xorg xorg-xinit picom

ln -s "$REPO_DIR/dotfiles/.xprofile" ~/.xprofile
