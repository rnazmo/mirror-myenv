#!/bin/bash
set -eu

# What is this:
#     Clone myenv-v3 repo from https://gitlab.com/rnazmo/myenv-v3 to ~/.myenv-v3.
#
# Prerequisites:
#     git
#
# Usage:
#     $ ./init.sh
#
# Example:
#     $ /bin/bash -c "$(curl -fsSL https://gitlab.com/rnazmo/myenv-v3/-/raw/main/init.bash)"

main() {
    local -r SRC_URL="git@gitlab.com:rnazmo/myenv-v3.git"
    local -r DEST_PARENT_DIR="${HOME}"
    local -r DEST_REPO_NAME=".myenv-v3"
    local -r DEST_REPO_PATH="${DEST_PARENT_DIR}/${DEST_REPO_NAME}"

    # ======================================================
    # ======== myenv-v3                                    =
    # ======================================================

    if [ -e "$DEST_REPO_PATH" ]; then
        log_err "The path $DEST_REPO_PATH already exists"
        exit 1
    fi
    cd "$DEST_PARENT_DIR"
    git clone "$SRC_URL" "$DEST_REPO_NAME"
}

log_info() {
    local -r PREFIX="INFO :"
    echo "$PREFIX $1"
}

log_warn() {
    local -r PREFIX="WARN :" >&2
    echo "$PREFIX $1"
}

log_err() {
    local -r PREFIX="ERROR:" >&2
    echo "$PREFIX $1"
}

main
