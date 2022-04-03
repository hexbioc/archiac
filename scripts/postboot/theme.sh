#!/usr/bin/env bash

source "$(dirname $0)/common.sh"

sudo pacman --noconfirm -S gtk-engine-murrine \
    lxappearance

# Unpack themes
sudo tar xJf "$REPO_DIR/assets/Material-Black-Cherry-3.38.tar.xz" \
    --directory=/usr/share/themes/
sudo tar xJf "$REPO_DIR/assets/Material-Black-Cherry-Suru.tar.xz" \
    --directory=/usr/share/icons/
sudo tar xJf "$REPO_DIR/assets/Bibata-Modern-DarkRed.tar.xz" \
    --directory=/usr/share/icons/

# Set default cursor
sudo mkdir -p /usr/share/icons/default
sudo bash <<EOS
cat <<EOF > /usr/share/icons/default/index.theme
[Icon Theme]
Inherits=Bibata-Modern-DarkRed
EOF
EOS

# Setup theme configuration
ln --force -s "$REPO_DIR/dotfiles/.gtkrc-2.0" ~/
ln --force -s "$REPO_DIR/configurations/gtk-3.0" ~/.config/
sudo bash -c \
    'echo -e "\n\n# Qt theming\nexport QT_STYLE_OVERRIDE=kvantum" >> /etc/profile'

# Add some bookmarks useful in file choosers
cat <<EOF > ~/.config/gtk-3.0/bookmarks
file:///home/$USER/archiac
file:///home/$USER/Downloads
EOF
