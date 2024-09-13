#!/bin/bash
set -eu

main() {
    if !check_if_command_exists "ghq"; then
        install_via_aqua
    fi
}

main


# install
# upgrade
# symlink
# uninstall