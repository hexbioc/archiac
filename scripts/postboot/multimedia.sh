#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

# Setup audio
sudo pacman --noconfirm -S pulseaudio pavucontrol pamixer

# Multimedia applications
validate_credentials
sudo pacman --noconfirm -S \
    geeqie \
    vlc

# Storage, files and phone mounts
validate_credentials
sudo pacman --noconfirm -S udiskie ntfs-3g libmtp \
    thunar glib2 gvfs
yay --noconfirm -S simple-mtpfs

# Screen capture and recording
validate_credentials
sudo pacman --noconfirm -S simplescreenrecorder flameshot
ln --force -s \
    $REPO_DIR/configurations/mimeapps.list \
    ~/.config/mimeapps.list
