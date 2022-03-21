#!/usr/bin/env bash

################################################################################
## POST BOOT
##
## This is the main script of a collection of scripts meant to be run on boot. A
## fair number of sections and customizations are inspired from Antonio's
## dotfiles repository: https://github.com/antoniosarosi/dotfiles
##
## This script performs sanity checks, and sets the stage for the execution of
## all scripts listed under 'enabled' file and found in the directory.
##
################################################################################

source "$(dirname $0)/common.sh"

## SANITY CHECKS ###############################################################

if ! is_online; then
    printf "Seems like the system is not connected to the internet.\n"
    printf "Internet is required to proceed. Scanning for available WiFi"
    printf " networks:\n"
    nmcli device wifi list

    # Connect to WiFi
    read -p    "Enter an SSID: " wifi_ssid
    read -s -p "Enter the password for '$wifi_ssid': " wifi_passwd
    printf "\n"
    nmcli device wifi connect "$wifi_ssid" password "$wifi_passwsd"

    # Check connection
    sleep 2
    if ! is_online; then
        printf "No connectivity yet. Script will abort; once connected, either"
        printf " reboot or run the '$scripts_dir'/main.sh' script manually.\n"
    fi
fi


## SETUP #######################################################################
printf "\nSetup will now sequentially execute all scripts listed in the"
printf " $SCRIPTS_DIR/enabled file. There maybe input prompts during execution,"
printf " therefore it is recommended to monitor the entire process as it"
printf " executes.\n\n"

validate_credentials

# Loop over list
for script_name in $(cat $SCRIPTS_DIR/enabled); do
    script_path="$SCRIPTS_DIR/$script_name.sh"
    
    if [[ -f "$script_path" ]]; then
        printf "\n${BOLD}Executing the '$script_name' script...${REG}\n\n"
        bash "$script_path"
    else
        printf "${BOLD}Ignoring script '$script_name' as the script file was"
        printf " not found.${REG}\n"
    fi

    validate_credentials
done

## CLEANUP #####################################################################

# Remove the section added to .bashrc that runs this script on boot
sed -i '/^## POSTBOOT-START/,/^## POSTBOOT-END/d' ~/.bashrc

printf "\n${BOLD}All post boot steps completed!${REG}\n."
printf "Will reboot in 10 seconds to activate all changes.\n"
sleep 2  # For comprehension

if ! read -n1 -t10 -s -p "${BOLD}Press any key to skip reboot.${REG}"; then
    printf "\n"
    reboot
else
    printf "\nThe reboot was skipped. Manually reboot to ensure that the setup"
    printf " was successful.\n"
fi
