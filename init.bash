#!/usr/bin/env bash
set -eu

# What is this:
#     Clone myenv repo from https://gitlab.com/rnazmo/myenv to ~/.myenv.
#
# Prerequisites:
#     git
#
# Usage:
#     $ ./init.sh
#
# Example:
#     $ /bin/bash -c "$(curl -fsSL https://gitlab.com/rnazmo/myenv/-/raw/main/init.bash)"

main() {
    local -r SRC_URL="git@gitlab.com:rnazmo/myenv.git"
    local -r DEST_PARENT_DIR="${HOME}"
    local -r DEST_REPO_NAME=".myenv"
    local -r DEST_REPO_PATH="${DEST_PARENT_DIR}/${DEST_REPO_NAME}"

    # ======================================================
    # ======== myenv                                    =
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
