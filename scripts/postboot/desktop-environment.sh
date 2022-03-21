#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

# Qtile
sudo pacman --noconfirm -S qtile rofi volumeicon cbatticon
ln -s "$REPO_DIR/configurations/qtile" ~/.config/qtile

# Notifications
validate_credentials
sudo pacman --noconfirm -S libnotify notification-daemon

sudo bash -c "cat > \
/usr/share/dbus-1/services/org.freedesktop.Notifications.service <<EOF
[D-BUS Service]
Name=org.freedesktop.Notifications
Exec=/usr/lib/notification-daemon-1.0/notification-daemon
EOF"
