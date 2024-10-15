#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

main() {
    log_debug "START: ${BASH_SOURCE##*/}"

    source "${MYENV_ROOT}/recipes/archlinux_x64/_base.bash"
    source "${MYENV_ROOT}/recipes/archlinux_x64/_fonts.bash"
    source "${MYENV_ROOT}/recipes/archlinux_x64/_terminal.bash"
    source "${MYENV_ROOT}/recipes/archlinux_x64/_devel.bash"

    source "${MYENV_ROOT}/recipes/archlinux_x64/_editor.bash"
    source "${MYENV_ROOT}/recipes/archlinux_x64/_browser.bash"

    log_debug "END  : ${BASH_SOURCE##*/}"
}

main
