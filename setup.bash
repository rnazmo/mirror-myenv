#!/bin/bash
set -eu

# Usage:
#     foo/bar/myenv-v3/setup.bash "<host_name>"
#
# Example:
#     ~/myenv-v3/setup.bash "soba"

source ${MYENV_ROOT}/lib/util.bash

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

main() {
    parse_args

    # TODO: Setup myenv-v3 (git clone)

    source "${MYENV_ROOT}/hosts/${HOST_NAME}/default.bash"
}

main "$@"
