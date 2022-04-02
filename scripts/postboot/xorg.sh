#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S xorg xorg-xinit \
	picom \
	brightnessctl

ln -s "$REPO_DIR/dotfiles/.xprofile" ~/.xprofile
ln --force -s "$REPO_DIR/configurations/picom" ~/.config/picom

# Add a udev rule to monitor hotplugs
username=$USER
sudo bash <<EOS
cat <<EOF > /etc/udev/rules.d/40-configure-display.rules
SUBSYSTEM=="drm", \
ACTION=="change", \
ENV{DISPLAY}=":0", \
ENV{XAUTHORITY}="/home/$username/.Xauthority", \
RUN+="/home/$username/archiac/scripts/configure-display.sh"
EOF
EOS

sudo bash <<EOS
cat <<EOF > /etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
	Identifier "devname"
	Driver "libinput"
	MatchIsTouchpad "on"
	Option "Tapping" "on"
	Option "ClickMethod" "clickfinger"
	Option "NaturalScrolling" "true"
EndSection
EOF
EOS
