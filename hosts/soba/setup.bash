#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

source "${MYENV_ROOT}/recipes/manjaro_x64/0_core.bash"
source "${MYENV_ROOT}/recipes/manjaro_x64/1_base.bash"
source "${MYENV_ROOT}/recipes/manjaro_x64/2_extra.bash"

main() {
    log_debug "START: ${BASH_SOURCE##*/}"

    # 0_core.bash
    # pre_setup_core
    setup_core
    # post_setup_core

    # 1_base.bash
    pre_setup_base
    setup_font
    setup_ime
    setup_util
    setup_shell
    setup_terminal
    setup_multiplexer
    setup_devel
    setup_editor
    setup_browser
    # post_setup_base

    # 2_extra.bash
    pre_setup_extra
    # something here
    # post_setup_extra

    log_debug "END  : ${BASH_SOURCE##*/}"
}

main
