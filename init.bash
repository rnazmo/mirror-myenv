#!/bin/bash
set -eu

# What is this:
#   Clone myenv-v3 repo from https://gitlab.com/rnazmo/myenv-v3 to ~/.myenv-v3.
#
# Usage:
#   $ ./init.sh
#
# Example:
#   $ /bin/bash -c "$(curl -fsSL https://gitlab.com/rnazmo/myenv-v3/-/raw/main/init.bash)"


main() {
    local -r GIT_GLOBAL_NAME="rnazmo"
    local -r GIT_GLOBAL_ENAIL="rnazmo@gmail.com"
    local -r SRC_URL="git@gitlab.com:rnazmo/myenv-v3.git"
    local -r DEST_PARENT_DIR="${HOME}"
    local -r DEST_REPO_NAME=".myenv-v3"
    # ===== Setup git

    # Set git global config
    git config --global user.name "rnazmo"
    git config --global user.email "rnazmo@gmail.com"
    # TODO:
    # Register SSH public key to GitLab(/GitHub)

    # ===== Setup myenv-v3

    # Clone myenv-v3
    cd "$DEST_PARENT_DIR"

    # TODO:
}

log_info() {
  local -r PREFIX="INFO :"
  echo "$PREFIX $1"
}

log_warn() {
  local -r PREFIX="WARN :"
  echo "$PREFIX $1"
}

log_err() {
  local -r PREFIX="ERROR:"
  echo "$PREFIX $1"
}

main