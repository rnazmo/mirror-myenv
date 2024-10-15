#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

source "${MYENV_ROOT}/recipes/manjaro_x64/0_core.bash"
source "${MYENV_ROOT}/recipes/manjaro_x64/1_base.bash"
source "${MYENV_ROOT}/recipes/manjaro_x64/2_extra.bash"

main() {
    log_debug "START: ${BASH_SOURCE##*/}"

    setup_core

    setup_base

    log_debug "END  : ${BASH_SOURCE##*/}"
}

main
