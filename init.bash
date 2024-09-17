#!/bin/bash
set -eu

# What is this:
#     Clone myenv-v3 repo from https://gitlab.com/rnazmo/myenv-v3 to ~/.myenv-v3.
#
# Prerequisites:
#     git
#
# Options:
#     --without-login
#         No synchronization with remote repositories. So you don't need for initial
#         Git setup (global config and registration of SSH public key to GitLab).
#
# Usage:
#     $ ./init.sh
#
# Example:
#     $ /bin/bash -c "$(curl -fsSL https://gitlab.com/rnazmo/myenv-v3/-/raw/main/init.bash)"
#
#     $ cd "$(mktemp -d)" && \
#         curl -O https://gitlab.com/rnazmo/myenv-v3/-/raw/main/init.bash && \
#         chmod +x install.sh && \
#         ./install.sh --without_login

main() {
    local WITHOUT_LOGIN=false
    local -r GIT_GLOBAL_NAME="rnazmo"
    local -r GIT_GLOBAL_ENAIL="rnazmo@gmail.com"
    local -r SRC_URL="git@gitlab.com:rnazmo/myenv-v3.git"
    local -r DEST_PARENT_DIR="${HOME}"
    local -r DEST_REPO_NAME=".myenv-v3"
    local -r DEST_REPO_PATH="${DEST_PARENT_DIR}/${DEST_REPO_NAME}"

    # Check option
    if [ $# -eq 1 ]; then
        if [ "$1" = "--without-login" ]; then
            echo "オプション '--without-login' が指定されました"
            WITHOUT_LOGIN=true
        else
            echo "Error: Wrong option. Only '--without-login' can use"
            exit 1
        fi
    elif [ $# -ge 2 ]; then
        echo "Error: Too many options. Only one option allowed at most"
        exit 1
    fi

    # Check if the myenv-v3 repo already exists
    if [ -e "$DEST_REPO_PATH" ]; then
        log_err "The path $DEST_REPO_PATH already exists"
        exit 1
    fi

    if ! WITHOUT_LOGIN; then
        # ======================================================
        # ======== git                                         =
        # ======================================================

        # Set git global config
        git config --global user.name "$GIT_GLOBAL_NAME"
        git config --global user.email "$GIT_GLOBAL_ENAIL"

        if ssh -T git@github.com &>/dev/null && ssh -T git@gitlab.com &>/dev/null; then
            : # Do nothing. (The SSH connection settings are already done)
        elif
            # Register SSH public key to GitLab(/GitHub)
            if [ ! -f "${HOME}/.ssh/id_ed25519.pub" ] && ssh-keygen -t ed25519
            cat "${HOME}/.ssh/id_ed25519.pub"
            echo "Open https://github.com/settings/ssh/new and register the SSH public key"
            echo "Open https://gitlab.com/-/user_settings/ssh_keys and register the SSH public key"
            ssh -T git@github.com
            ssh -T git@gitlab.com
        fi
    fi

    # ======================================================
    # ======== myenv-v3                                    =
    # ======================================================

    # Clone myenv-v3
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