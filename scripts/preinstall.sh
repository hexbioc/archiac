#/usr/bin/env bash

################################################################################
## PRE-INSTALLATION SCRIPT
##
## This script is meant to be run indirectly in the Archlinux live environment
## via curl, after mounting the root, boot/efi and home partitions.
##
## Before executing this script, ensure that:
##    - The root partition is mounted at /mnt
##    - The EFI partition is mounted at /boot
##    - The home partition, if different, is mounted at /mnt/home
##    - All non-swap mountpoints are formatted as ext4
##    - The system is connected to the internetzzzz
##
## Instructions on creating, formatting and mounting partitions can be found
## in the Archlinux installation guide found at
## https://wiki.archlinux.org/title/Installation_guide. Several portions of
## this setup refer the guide for setting this up.
##
## This script bootstraps the Archlinux installation using pacstrap. It further
## chroots into the mount and proceeds with the next steps in the installation,
## finally unmounting and rebooting.
##
## Finally, in order to run this script, execute the following command from the
## live environment:
## bash -c "$(curl -fsSL https://raw.github.com/hexbioc/archiac/main/scripts/preinstall.sh)"
################################################################################


BOLD=$(tput bold)
REG=$(tput sgr0)


## SANITY CHECKS ###############################################################

# Check mountpoints
function is_mountpoint() {
    findmnt "$1" > /dev/null 2>&1
}

if ! is_mountpoint /mnt; then
    printf "Root is not mounted. Mount root partition to /mnt and try again.\n"
    exit 1
fi

if ! is_mountpoint /mnt/boot; then
    printf "EFI partition is not mounted. Mount EFI partition to /mnt/boot"
    printf " and try again.\n"
    exit 1
fi

# Check internet connectivity
if ! ping -4 -c1 archlinux.org > /dev/null 2>&1; then
    printf "Internet connection is essential, but seems to be unavailable."
    printf " Connect and try again.\n"
    exit 1
fi


## SYSTEM TIME #################################################################
# Set systemtime
timedatectl set-ntp true


## BOOTSTRAP ###################################################################

# Update repositories
pacman -Sy

# Setup Arch mirror list
pacman --noconfirm -S reflector
reflector --latest 20 \
    --sort rate \
    --protocol https \
    --save /etc/pacman.d/mirrorlist

# pacstrap with bare minimum tooling
pacstrap /mnt base linux linux-firmware \
    git vim nano \
    man-db man-pages texinfo

# fstab
genfstab -U /mnt >> /mnt/etc/fstab


## CHROOT ######################################################################

# Capture system name, root password, primary user and corresponding password
printf "Following prompts will request for details necessary for setting up the"
printf " system. Note that the ${BOLD}inputs will not be validated${REG}, so"
printf " ensure that valid inputs are provided for each prompt. Not doing so"
printf "could break the installation and will need to be manually recovered.\n"
printf "\n"
read -p    "Enter a name for the system          : " sysname
read -s -p "Enter a password for root            : " root_passwd
printf "\n"
read -p    "Enter a username for the primary user: " primary_user
read -s -p "Enter a password for $primary_user   : " primary_passwd
printf "\n"

# chroot, clone this setup and prepare for the first boot
arch-chroot /mnt bash <<EOF
    cd /
    git clone https://github.com/hexbioc/archiac.git
    cd archiac/scripts
    bash chroot.sh "$sysname" "$root_passwd" "$primary_user" "$primary_passwd"
EOF

if [ "$?" -ne "0" ]; then
    printf "Seems like something went wrong in the chroot environment.\n"
    printf "Aborting automated setup, proceed manually.\n"
    exit 1
fi


## CLEANUP #####################################################################

# Unmount and reboot
printf "${BOLD}\n\nSetup completed successfully.${REG}\n"
printf "* * *\n"
printf "As the final steps, the mountpoints will be unmounted and the system"
printf " will reboot.\n"
sleep 2  # To allow comprehension

printf "Before proceeding with the final steps, the ${BOLD}script will wait for"
printf " 10 seconds to allow aborting${REG} at this point.\n"
printf "* * *\n"
if read -n1 -t10 -s -p "${BOLD}Press any key to abort.${REG}"; then
    printf "\nAs the script has been aborted, partitions will have to be"
    printf " manually unmounted. Once done, unplug the USB device and reboot.\n"
    exit 0
fi

printf "\n* * *\n"
printf "As no input was received, unmounting partitions.\n"
umount -R /mnt

printf "System will reboot shortly. ${BOLD}Unplug the USB device${REG} to avoid"
printf " booting into the live environment again.\n"
sleep 2
reboot
