#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

main() {
    log_debug "START: ${BASH_SOURCE##*/}"

    source "${MYENV_ROOT}/recipes/archlinux_x64/setup.bash"

    log_debug "END  : ${BASH_SOURCE##*/}"
}

main
