#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S feh

cat <<EOF > ~/.fehbg
#!/bin/sh
feh --no-fehbg --bg-fill '$REPO_DIR/assets/default-wallpaper.jpg'
EOF
chmod 754 ~/.fehbg
