#!/usr/bin/env bash
set -eu

export MYENV_ROOT="${HOME}/.myenv"

source ${MYENV_ROOT}/lib/util.bash

main() {
    log_debug "START: ${BASH_SOURCE}"

    # TODO: Clone "gitlab.com/rnazmo/myenv-v3" to `~/.myenv-v3`

    # TODO: Run ../../init.bash ?

    log_debug "END  : ${BASH_SOURCE}"
}

main
