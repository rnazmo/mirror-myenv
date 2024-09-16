#!/bin/bash
set -eu

# virtualized environment host

source ${MYENV_DIR}/lib/util.bash

main() {
    # =============== docker
    sudo pacman -S docker docker-compose

    # =============== virtualbox (host)
    sudo pacman -S --needed virtualbox virtualbox-host-modules-arch virtualbox-guest-iso
    sudo gpasswd -a $USER vboxusers
    sudo modprobe vboxdrv
}

main
