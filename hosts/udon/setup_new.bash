#!/usr/bin/env bash
set -eu

# Udon (EndeavourOS) のセットアップ。
# 3層アーキテクチャ版: 明示的な source 順で platform chain を構成する。

source "${MYENV_ROOT}/lib/util.bash"

source "${MYENV_ROOT}/platforms/0_common/default.bash"
source "${MYENV_ROOT}/platforms/1_families/arch_based.bash"
source "${MYENV_ROOT}/platforms/2_distros/endeavouros.bash"

source "${MYENV_ROOT}/components/_init.bash"

readonly HOST_LABEL="udon (EndeavourOS)"

main() {
    log_info "Starting setup for ${HOST_LABEL}"

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

    log_info "Completed setup for ${HOST_LABEL}"
}

main
