#!/usr/bin/env bash
set -eu

# What is this:
#     Provision the machine.
#
# Prerequisites:
#     myenv-v3 repository (~/.myenv-v3)
#
# Usage:
#     foo/bar/myenv-v3/setup.bash "<host_name>"
#
# Example:
#     ~/myenv-v3/setup.bash "soba"

export MYENV_ROOT="${HOME}/.myenv-v3"

source "${MYENV_ROOT}/lib/util.bash"

parse_args() {
    # Parse arguments
    local -r EXPECTED_ARGS=1
    if [ $# -ne $EXPECTED_ARGS ]; then
        echo "Error: Number of arguments must be $EXPECTED_ARGS"
        echo "Usage: $0 <host_name>"
        exit 1
    fi
    readonly HOST_NAME="$1"
}

check_prerequisites() {
    if [ ! -d "$MYENV_ROOT" ]; then
        log_err "The myenv-3 repository not found"
        exit 1
    fi
}

main() {
    log_debug "START: ${BASH_SOURCE}"

    parse_args "$@"

    check_prerequisites

    source "${MYENV_ROOT}/hosts/${HOST_NAME}/setup.bash"

    log_debug "END  : ${BASH_SOURCE}"
    log_info "======== Completed all process successfully ========"
}

main "$@"
