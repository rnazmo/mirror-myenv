#!/usr/bin/env bash
set -eu

# What is this:
#     Provision the machine.
#
# Prerequisites:
#     myenv repository (~/.myenv)
#
# Usage:
#     foo/bar/myenv/setup.bash "<host_name>"
#
# Example:
#     ~/myenv/setup.bash "soba"

export MYENV_ROOT="${HOME}/.myenv"

source "${MYENV_ROOT}/lib/util.bash"

# スクリプト全体で参照するグローバル変数
# parse_args() 内で値が設定される
HOST_NAME=""

parse_args() {
    local -r EXPECTED_ARGS=1
    if [ $# -ne $EXPECTED_ARGS ]; then
        echo "Error: Number of arguments must be $EXPECTED_ARGS"
        echo "Usage: $0 <host_name>"
        exit 1
    fi
    HOST_NAME="$1"
    readonly HOST_NAME
}
readonly -f parse_args

check_prerequisites() {
    if [ ! -d "$MYENV_ROOT" ]; then
        log_err "The myenv repository not found"
        exit 1
    fi
}
readonly -f check_prerequisites

main() {
    parse_args "$@"

    check_prerequisites

    # shellcheck source=/dev/null
    source "${MYENV_ROOT}/hosts/${HOST_NAME}/setup.bash"

    log_info "======== Completed all process successfully ========"
}

main "$@"
