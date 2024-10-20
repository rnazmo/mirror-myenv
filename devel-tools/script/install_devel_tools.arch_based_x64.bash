#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

readonly DEVEL_TOOLS_BIN_DIR="${MYENV_ROOT}/devel-tools/bin"

readonly SHELLCHECK_VERSION="v0.10.0"
readonly SHFMT_VERSION="v3.8.0"
readonly BATS_VERSION="v1.11.0"
readonly SHELLCHECK_DL_URL="https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz"
readonly SHFMT_DL_URL="https://github.com/mvdan/sh/releases/download/${SHFMT_VERSION}/shfmt_${SHFMT_VERSION}_linux_amd64"
readonly BATS_REPO_URL="https://github.com/bats-core/bats-core.git"
readonly SHELLCHECK_CMD="shellcheck"
readonly SHFMT_CMD="shfmt"
readonly BATS_CMD="bats"
readonly SHELLCHECK_CMD_PATH="${DEVEL_TOOLS_BIN_DIR}/${SHELLCHECK_CMD}"
readonly SHFMT_CMD_PATH="${DEVEL_TOOLS_BIN_DIR}/${SHFMT_CMD}"
readonly BATS_CMD_PATH="${DEVEL_TOOLS_BIN_DIR}/bin/${BATS_CMD}"

main() {
    install_devel_tools
}

install_devel_tools() {
    _install_shellcheck
    _install_shfmt
    _install_bats
}

_install_shellcheck() {
    local -r TEMP_DIR="$(mktemp -d)"
    cd "$TEMP_DIR"

    curl -OL "$SHELLCHECK_DL_URL"
    tar -xf "./shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz"
    mv -f "./shellcheck-${SHELLCHECK_VERSION}/shellcheck" "$DEVEL_TOOLS_BIN_DIR"

    # check
    "$SHELLCHECK_CMD_PATH" --version
}

_install_shfmt() {
    cd "$DEVEL_TOOLS_BIN_DIR"
    curl -L "$SHFMT_DL_URL" -o shfmt
    chmod +x ./shfmt

    # check
    "$SHFMT_CMD_PATH" --version
}

_install_bats() {
    local -r TEMP_DIR="$(mktemp -d)"
    cd "$TEMP_DIR"

    # Ref: https://bats-core.readthedocs.io/en/stable/installation.html#any-os-installing-bats-from-source
    git clone --single-branch --branch "$BATS_VERSION" "$BATS_REPO_URL"
    cd bats-core
    ./install.sh "$DEVEL_TOOLS_BIN_DIR"

    # check
    "$BATS_CMD_PATH" --version
}

main
