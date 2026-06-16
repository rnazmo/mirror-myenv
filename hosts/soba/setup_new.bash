#!/usr/bin/env bash
set -eu

# Soba (CachyOS) のセットアップ。
# 3層アーキテクチャ版: 明示的な source 順で platform chain を構成する。

source "${MYENV_ROOT}/lib/util.bash"

source "${MYENV_ROOT}/platforms/0_common/default.bash"
source "${MYENV_ROOT}/platforms/1_families/arch_based.bash"
source "${MYENV_ROOT}/platforms/2_distros/cachyos.bash"

source "${MYENV_ROOT}/components/_init.bash"

readonly HOST_LABEL="soba (CachyOS)"

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
    # setup_wezterm  # not needed on soba
    setup_tmux

    setup_devel_tools
    setup_lazygit

    setup_neovim
    setup_editorconfig

    # setup_fcitx5_mozc  # not needed on soba

    # setup_xfce4  # not needed on soba (headless/server)

    setup_chromium
    setup_firefox

    log_info "Completed setup for ${HOST_LABEL}"
}

main
