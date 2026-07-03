#!/usr/bin/env bash
set -eu

# Darwin (macOS) 系共通の platform hook 実装。
# デフォルト（no-op）を上書きして brew を用いた実装を提供する。
# Phase 2 で実装を追加すること。

source "${MYENV_ROOT}/lib/util.bash"

# ===== core =====
platform_refresh_packages()    { :; }  # Phase 2: brew update && brew upgrade
platform_update_mirrorlist()   { :; }
platform_ensure_build_deps()   { :; }  # Phase 2: xcode-select --install
platform_install_git()         { :; }  # Phase 2: brew install git
platform_install_delta()       { :; }  # Phase 2: brew install git-delta
platform_install_yay()         { :; }  # Phase 2: N/A
platform_install_mise()        { :; }  # Phase 2: brew install mise

# ===== maintenance =====
platform_clean_package_cache()   { :; }  # Phase 2: brew cleanup
platform_clean_yay_cache()       { :; }  # Phase 2: N/A
platform_clean_system_logs()     { :; }  # Phase 2: log rotate / vacuum
platform_remove_orphan_packages(){ :; }  # Phase 2: brew autoremove

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
platform_install_zsh()         { :; }
platform_install_p10k()        { :; }  # Phase 2: brew install powerlevel10k
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
platform_install_neovim()      { :; }

# ===== ime =====
platform_install_fcitx5_mozc() { :; }

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
