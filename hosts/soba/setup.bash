#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

source "${MYENV_ROOT}/recipes/archlinux_x64/core.bash"
source "${MYENV_ROOT}/recipes/archlinux_x64/base.bash"
source "${MYENV_ROOT}/recipes/archlinux_x64/extra.bash"

main() {
    log_debug "START: ${BASH_SOURCE##*/}"

    setup_core

    setup_fonts
    setup_input_method
    setup_terminal
    setup_devel
    setup_editor
    setup_browser

    log_debug "END  : ${BASH_SOURCE##*/}"
}

main
