#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S \
    xorg-fonts-misc \
    ttf-dejavu \
    ttf-liberation \
    noto-fonts

yay --noconfirm -S \
    nerd-fonts-hermit \
    nerd-fonts-fira-code
