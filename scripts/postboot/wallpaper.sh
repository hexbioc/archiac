#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S feh

feh --bg-fill "$REPO_DIR/assets/default-wallpaper.jpg"
