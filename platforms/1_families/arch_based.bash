#!/usr/bin/env bash
set -eu

# Arch 系ディストリビューション共通の platform hook 実装。
# デフォルト（no-op）を上書きして pacman / yay を用いた実装を提供する。
# Phase 2 で実装を追加すること。

source "${MYENV_ROOT}/lib/util.bash"

# ===== core =====
platform_refresh_packages()    { :; }  # Phase 2: sudo pacman -Syu ...
platform_update_mirrorlist()   { :; }  # Phase 2: ホワイトリストベースのミラー更新
platform_ensure_build_deps()   { :; }  # Phase 2: sudo pacman -S base-devel curl vim
platform_install_git()         { :; }  # Phase 2: sudo pacman -S git
platform_install_delta()       { :; }  # Phase 2: sudo pacman -S git-delta
platform_install_yay()         { :; }  # Phase 2: AUR helper のインストール
platform_install_mise()        { :; }  # Phase 2: yay -S mise

# ===== util =====
platform_install_tree()        { :; }  # Phase 2: sudo pacman -S tree
platform_install_xclip()       { :; }  # Phase 2: sudo pacman -S xclip
platform_install_unzip()       { :; }  # Phase 2: sudo pacman -S unzip
platform_install_ghq()         { :; }  # Phase 2: sudo pacman -S ghq
platform_install_fzf()         { :; }  # Phase 2: sudo pacman -S fzf
platform_install_zoxide()      { :; }  # Phase 2: sudo pacman -S zoxide
platform_install_eza()         { :; }  # Phase 2: sudo pacman -S eza
platform_install_ripgrep()     { :; }  # Phase 2: sudo pacman -S ripgrep
platform_install_bat()         { :; }  # Phase 2: sudo pacman -S bat
platform_install_fd()          { :; }  # Phase 2: sudo pacman -S fd
platform_install_bottom()      { :; }  # Phase 2: sudo pacman -S bottom
platform_install_jq()          { :; }  # Phase 2: sudo pacman -S jq
platform_install_fastfetch()   { :; }  # Phase 2: sudo pacman -S fastfetch
platform_install_yazi()        { :; }  # Phase 2: sudo pacman -S yazi

# ===== shell =====
platform_install_zsh()         { :; }  # Phase 2: sudo pacman -S zsh
platform_install_p10k()        { :; }  # Phase 2: yay -S zsh-theme-powerlevel10k-git
platform_pre_install_p10k()    { :; }  # Phase 2: no-op (必要なら distro が上書き)

# ===== terminal =====
platform_install_alacritty()   { :; }  # Phase 2: sudo pacman -S alacritty
platform_install_wezterm()     { :; }  # Phase 2: sudo pacman -S wezterm

# ===== multiplexer =====
platform_install_tmux()        { :; }  # Phase 2: sudo pacman -S tmux

# ===== devel =====
platform_install_shellcheck()          { :; }  # Phase 2: sudo pacman -S shellcheck
platform_install_shfmt()               { :; }  # Phase 2: sudo pacman -S shfmt
platform_install_selene()              { :; }  # Phase 2: sudo pacman -S selene
platform_install_stylua()              { :; }  # Phase 2: sudo pacman -S stylua
platform_install_staticcheck()         { :; }  # Phase 2: sudo pacman -S staticcheck
platform_install_eslint_d()            { :; }  # Phase 2: sudo pacman -S eslint_d
platform_install_prettier()            { :; }  # Phase 2: sudo pacman -S prettier
platform_install_markdownlint_cli2()   { :; }  # Phase 2: sudo pacman -S markdownlint-cli2
platform_install_actionlint()          { :; }  # Phase 2: sudo pacman -S actionlint
platform_install_typos()               { :; }  # Phase 2: sudo pacman -S typos
platform_install_lazygit()             { :; }  # Phase 2: sudo pacman -S lazygit

# ===== editor =====
platform_install_neovim()      { :; }  # Phase 2: sudo pacman -S neovim

# ===== ime =====
platform_install_fcitx5_mozc() { :; }  # Phase 2: sudo pacman -S fcitx5-mozc fcitx5-im

# ===== desktop =====
platform_install_xfce4_systemload() { :; }  # Phase 2: sudo pacman -S xfce4-systemload-plugin

# ===== browser =====
platform_install_chromium()    { :; }  # Phase 2: sudo pacman -S chromium
platform_install_firefox()     { :; }  # Phase 2: sudo pacman -S firefox

# ===== extra =====
platform_install_docker()             { :; }  # Phase 2: sudo pacman -S docker docker-compose
platform_install_virtualbox()         { :; }  # Phase 2: sudo pacman -S virtualbox ...
platform_install_virtualbox_guest()   { :; }  # Phase 2: sudo pacman -S virtualbox-guest-utils
platform_install_vscode()             { :; }  # Phase 2: yay -S visual-studio-code-bin
platform_install_obsidian()           { :; }  # Phase 2: sudo pacman -S obsidian
