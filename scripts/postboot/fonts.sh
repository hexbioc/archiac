#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S \
    ttf-dejavu \
    ttf-liberation \
    noto-fonts

yay --noconfirm -S \
    nerd-fonts-hermit \
    nerd-fonts-fira-code
