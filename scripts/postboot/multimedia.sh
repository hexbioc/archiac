#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

# Setup audio
sudo pacman --noconfirm -S pulseaudio pavucontrol pamixer

# Multimedia applications
validate_credentials
sudo pacman --noconfirm -S \
    geeqie \  # Images
    vlc  # Audio and video

# Storage, files and phone mounts
validate_credentials
sudo pacman --noconfirm -S udiskie ntfs-3g thunar libmtp simple-mtpfs
