#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_devel_tools() {
    platform_install_shellcheck
    platform_install_shfmt
    platform_install_selene
    platform_install_stylua
    platform_install_staticcheck
    platform_install_eslint_d
    platform_install_prettier
    platform_install_markdownlint_cli2
    platform_install_actionlint
    platform_install_typos
}
readonly -f setup_devel_tools

setup_lazygit() {
    platform_install_lazygit
    _setup_lazygit_config
}
readonly -f setup_lazygit

_setup_lazygit_config() {
    remove_unused_config "${HOME}/.config/lazygit/config.yml"
    link_file "${MYENV_ROOT}/config/home/.config/lazygit/config.yml" "${HOME}/.config/lazygit/config.yml"
}
readonly -f _setup_lazygit_config
