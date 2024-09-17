#!/bin/bash
set -eu

# virtualized environment guest

source ${MYENV_DIR}/lib/util.bash

main() {
    log_debug "START: ${BASH_SOURCE}"

    # =============== virtualbox (guest)
    # Ref: https://wiki.archlinux.org/title/VirtualBox/Install_Arch_Linux_as_a_guest
    sudo pacman -S --needed virtualbox-guest-utils

    log_debug "END  : ${BASH_SOURCE}"
}

main
