#!/bin/bash
set -eu

# virtualized environment host

source ${MYENV_DIR}/lib/util.bash

main() {
    log_debug "START: ${BASH_SOURCE}"

    # =============== docker
    sudo pacman -S docker docker-compose

    # =============== virtualbox (host)
    sudo pacman -S --needed virtualbox virtualbox-host-modules-arch virtualbox-guest-iso
    sudo gpasswd -a $USER vboxusers
    sudo modprobe vboxdrv

    log_debug "END  : ${BASH_SOURCE}"
}

main
