#!/usr/bin/env bash
set -eu

# Debian 系ディストリビューション共通の platform hook 実装。
# デフォルト（no-op）を上書きして apt を用いた実装を提供する。
# Phase 2 で実装を追加すること。

source "${MYENV_ROOT}/lib/util.bash"

# ===== core =====
platform_refresh_packages()    { :; }  # Phase 2: sudo apt update && sudo apt upgrade -y
platform_update_mirrorlist()   { :; }
platform_ensure_build_deps()   { :; }  # Phase 2: sudo apt install -y build-essential curl vim
platform_install_git()         { :; }  # Phase 2: sudo apt install -y git
platform_install_delta()       { :; }  # Phase 2: sudo apt install -y git-delta
platform_install_yay()         { :; }  # Phase 2: N/A (no AUR equivalent)
platform_install_mise()        { :; }  # Phase 2: curl 経由でインストール

# ===== util =====
platform_install_tree()        { :; }
platform_install_xclip()       { :; }
platform_install_unzip()       { :; }
platform_install_ghq()         { :; }
platform_install_fzf()         { :; }
platform_install_zoxide()      { :; }
platform_install_eza()         { :; }
platform_install_ripgrep()     { :; }
platform_install_bat()         { :; }
platform_install_fd()          { :; }
platform_install_bottom()      { :; }
platform_install_jq()          { :; }
platform_install_fastfetch()   { :; }
platform_install_yazi()        { :; }

# ===== shell =====
platform_install_zsh()         { :; }  # Phase 2: sudo apt install -y zsh
platform_install_p10k()        { :; }  # Phase 2: git clone 経由
platform_pre_install_p10k()    { :; }

# ===== terminal =====
platform_install_alacritty()   { :; }
platform_install_wezterm()     { :; }

# ===== multiplexer =====
platform_install_tmux()        { :; }

# ===== devel =====
platform_install_shellcheck()          { :; }
platform_install_shfmt()               { :; }
platform_install_selene()              { :; }
platform_install_stylua()              { :; }
platform_install_staticcheck()         { :; }
platform_install_eslint_d()            { :; }
platform_install_prettier()            { :; }
platform_install_markdownlint_cli2()   { :; }
platform_install_actionlint()          { :; }
platform_install_typos()               { :; }
platform_install_lazygit()             { :; }

# ===== editor =====
platform_install_neovim()      { :; }  # Phase 2: sudo apt install -y neovim

# ===== ime =====
platform_install_fcitx5_mozc() { :; }  # Phase 2: sudo apt install -y fcitx5-mozc

# ===== desktop =====
platform_install_xfce4_systemload() { :; }

# ===== browser =====
platform_install_chromium()    { :; }
platform_install_firefox()     { :; }

# ===== extra =====
platform_install_docker()             { :; }
platform_install_virtualbox()         { :; }
platform_install_virtualbox_guest()   { :; }
platform_install_vscode()             { :; }
platform_install_obsidian()           { :; }
