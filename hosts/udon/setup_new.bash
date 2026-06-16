#!/usr/bin/env bash
set -eu

# Udon (EndeavourOS) のセットアップ。
# 3層アーキテクチャ版: 明示的な source 順で platform chain を構成する。

source "${MYENV_ROOT}/lib/util.bash"

source "${MYENV_ROOT}/platforms/0_common/default.bash"
source "${MYENV_ROOT}/platforms/1_families/arch_based.bash"
source "${MYENV_ROOT}/platforms/2_distros/endeavouros.bash"

source "${MYENV_ROOT}/components/core.bash"
source "${MYENV_ROOT}/components/shell.bash"
source "${MYENV_ROOT}/components/util.bash"
source "${MYENV_ROOT}/components/terminal.bash"
source "${MYENV_ROOT}/components/multiplexer.bash"
source "${MYENV_ROOT}/components/editor.bash"
source "${MYENV_ROOT}/components/devel.bash"
source "${MYENV_ROOT}/components/ime.bash"
source "${MYENV_ROOT}/components/desktop.bash"
source "${MYENV_ROOT}/components/browser.bash"
source "${MYENV_ROOT}/components/extra.bash"

main() {
    log_info "Starting setup for udon (EndeavourOS)"

    setup_core

    setup_zsh
    setup_p10k
    setup_default_shell

    setup_util_clis
    setup_fastfetch
    setup_yazi
    setup_proper7y

    setup_alacritty
    setup_wezterm
    setup_tmux

    setup_devel_tools
    setup_lazygit

    setup_neovim
    setup_editorconfig

    setup_fcitx5_mozc

    setup_xfce4

    setup_chromium
    setup_firefox

    setup_virtualbox_guest

    log_info "Completed setup for udon (EndeavourOS)"
}

main
