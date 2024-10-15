#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

source "${MYENV_ROOT}/recipes/archlinux_x64/base.bash"
source "${MYENV_ROOT}/recipes/archlinux_x64/fonts.bash"
source "${MYENV_ROOT}/recipes/archlinux_x64/terminal.bash"
source "${MYENV_ROOT}/recipes/archlinux_x64/devel.bash"
source "${MYENV_ROOT}/recipes/archlinux_x64/editor.bash"
source "${MYENV_ROOT}/recipes/archlinux_x64/browser.bash"

main() {
    log_debug "START: ${BASH_SOURCE##*/}"

    setup_base
    setup_fonts
    setup_terminal
    setup_devel
    setup_editor
    setup_browser

    log_debug "END  : ${BASH_SOURCE##*/}"
}

main
