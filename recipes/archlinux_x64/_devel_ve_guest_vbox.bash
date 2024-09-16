#!/bin/bash
set -eu

# virtualized environment guest

source ${MYENV_DIR}/lib/util.bash

main() {
    # =============== virtualbox (guest)
    # Ref: https://wiki.archlinux.org/title/VirtualBox/Install_Arch_Linux_as_a_guest
    sudo pacman -S --needed virtualbox-guest-utils
}

main
