#!/bin/bash
set -eu

main() {
    install
    # config
    # install
    # upgrade
    # symlink
    # uninstall
}

install() {
    local -r CMD_NAME="ghq"
    local -r RESOURCE="x-motemen/ghq"
    if !check_if_command_exists "ghq"; then
        install_via_aqua "x-motemen/ghq"
    fi
}

main


