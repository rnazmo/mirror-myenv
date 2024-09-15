#!/bin/bash
set -eu

main() {
    source ${MYENV_ROOT}/setup/archlinux_x64/_base.bash
    source ${MYENV_ROOT}/setup/archlinux_x64/_fonts.bash
    source ${MYENV_ROOT}/setup/archlinux_x64/_devel.bash
    source ${MYENV_ROOT}/setup/archlinux_x64/_terminal.bash

    source ${MYENV_ROOT}/setup/archlinux_x64/_editor.bash
    source ${MYENV_ROOT}/setup/archlinux_x64/_browser.bash

    is_virtualbox_guest && source "${MYENV_ROOT}/setup/archlinux_x64/_devel.ve_guest_vbox.bash"
    is_not_virtualized_environment && source "${MYENV_ROOT}/setup/archlinux_x64/_devel.ve_host.bash"

    source ${MYENV_ROOT}/setup/archlinux_x64/_japanese_input.bash
    # source ${MYENV_ROOT}/setup/archlinux_x64/_apps.bash
}

main
