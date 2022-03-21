#!/usr/bin/env bash

################################################################################
## COMMON UTILITIES
##
## This script is meant to be sourced in the shell running all other scripts
## from the postboot directory.
##
## It exports the following environment variables:
##   - BOLD: Character sequence to enable bold text on stdout
##   - REG: Character sequence to enable regular text on stdout
##   - SCRIPTS_DIR: Full path to the postboot scripts directory
##   - REPO_DIR: Full path to the archiac repository
##
## It also exports the following functions:
##   - validate_credentials: Stores / updates the credentials of the sudo user
##   - is_online: Returns non-zero when internet connection is unavailable
##
## Additionally, the script navigates to the postboot scripts directory.
##
################################################################################

export BOLD=$(tput bold)
export REG=$(tput sgr0)

# Store directory paths and navigate to the post boot scripts directory
cd "$(dirname $0)"
export SCRIPTS_DIR="$(pwd)"
cd ../../
export REPO_DIR="$(pwd)"
cd "$SCRIPTS_DIR"

function validate_credentials() {
    # Store / update credentials for the session
    sudo -vp "Enter the password for user '%u': "
}
export -f validate_credentials

function is_online() {
    ping -c1 archlinux.org > /dev/null 2>&1
}
export -f is_online
