#!/usr/bin/env bash

################################################################################
## ARCH-CHROOT ENVIRONMENT
##
## This script is meant to be run from the arch-chroot environment. Largely, it
## is based on the archlinux installation guide found at
## https://wiki.archlinux.org/title/Installation_guide.
##
## This script updates packages, installs the bootloader, and installs common
## utilities that will be needed irrespective of the desktop environment, such
## as vim (for a text editor) and man-db.
##
## The script expects the following arguments:
##  $1 - System hostname
##  $2 - Root password
##  $3 - Primary username
##  $4 - Primary user password
################################################################################


BOLD=$(tput bold)
REG=$(tput sgr0)

sysname="$1"
root_passwd="$2"
primary_user="$3"
primary_passwd="$4"

# Navigate to and store the path to the scripts directory
cd "$(dirname $0)"
scripts_dir="$(pwd)"


## DATE, TIME AND TIMEZONE #####################################################
printf "\nSetting up date, time and timezone...\n"
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc


## LOCALE ######################################################################
printf "\nSetting up locale...\n"
printf "en_IN UTF-8\nen_US.UTF-8 UTF-8\n" > /etc/locale.gen
locale-gen
printf "LANG=en_US.UTF-8\n" > /etc/locale.conf


## NETWORK #####################################################################
printf "\nSetting up the network...\n"
echo "$sysname" > /etc/hostname
pacman --noconfirm -S networkmanager network-manager-applet
systemctl enable NetworkManager


## BOOTLOADER ##################################################################
printf "\nSetting up the bootloader...\n"
pacman --noconfirm -S grub efibootmgr os-prober \
    amd-ucode intel-ucode  # Install both, while the relevant one will be used

# Setup grub
grub-install --target=x86_64-efi --efi-directory=/boot
os-prober
grub-mkconfig -o /boot/grub/grub.cfg


## USER SETUP ##################################################################
printf "\nSetting up root and primary user '$primary_user'...\n"
yes "$root_passwd" | passwd

# Create user
useradd -m $primary_user
yes "$primary_passwd" | passwd $primary_user
usermod -aG wheel,video,audio,storage $primary_user

# Setup sudo
pacman --noconfirm -S sudo
cat <<EOF > /etc/sudoers.d/sudowheel
# Allow sudo access to all users of the wheel group
%wheel ALL=(ALL) ALL
EOF


## PREPARE FIRST BOOT ##########################################################
printf "\nPreparing for the first boot...\n"

# Move the repository to primary user's home
cd /home/$primary_user
mv /archiac ./
chown -R $primary_user:$primary_user archiac

# Setup .bashrc to execute post boot scripts
cat <<EOF >> .bashrc
## POSTBOOT-START
if ! [[ -z \$PS1 ]]; then
    bash ~/archiac/scripts/postboot/main.sh
fi
## POSTBOOT-END
EOF

printf "\nSystem has been prepared for boot. On reboot, login using the"
printf " credentials for '$primary_user' to continue the setup.\n"
