#!/usr/bin/env bash
set -eu

# virtualized environment guest

source ${MYENV_DIR}/lib/util.bash

setup_virtualbox() {
    log_debug "START: ${BASH_SOURCE}"

    # =============== docker
    sudo pacman -S docker docker-compose

    # =============== virtualbox (host)
    sudo pacman -S --needed virtualbox virtualbox-host-modules-arch virtualbox-guest-iso
    sudo gpasswd -a $USER vboxusers
    sudo modprobe vboxdrv

    log_debug "END  : ${BASH_SOURCE}"
}

setup_virtualbox_guest() {
    log_debug "START: ${BASH_SOURCE}"

    # =============== virtualbox (guest)
    # Ref: https://wiki.archlinux.org/title/VirtualBox/Install_Arch_Linux_as_a_guest
    sudo pacman -S --needed virtualbox-guest-utils

    log_debug "END  : ${BASH_SOURCE}"
}

main
