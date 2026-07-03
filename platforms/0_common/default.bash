#!/usr/bin/env bash
set -eu

# ======================================================
# ======== Default platform hooks (no-op)              =
# ======================================================
#
# 全 platform hook のデフォルト実装。
# 各 platform ファイル（1_families/*, 2_distros/*）が必要に応じて上書きする。
# host 側が明示的な source 順で chain を構成するため、本ファイルは「何もしない」を保証する。
# Ref: ADR-009

source "${MYENV_ROOT}/lib/util.bash"

# ===== core コンポーネント用 =====
platform_refresh_packages()    { :; }
platform_update_mirrorlist()   { :; }
platform_ensure_build_deps()   { :; }
platform_install_git()         { :; }
platform_install_delta()       { :; }
platform_install_yay()         { :; }
platform_install_mise()        { :; }

# ===== maintenance コンポーネント用 =====
platform_clean_package_cache()   { :; }
platform_clean_yay_cache()       { :; }
platform_clean_system_logs()     { :; }
platform_remove_orphan_packages(){ :; }

# ===== util コンポーネント用 =====
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

# ===== shell コンポーネント用 =====
platform_install_zsh()         { :; }
platform_install_p10k()        { :; }
platform_pre_install_p10k()    { :; }

# ===== terminal コンポーネント用 =====
platform_install_alacritty()   { :; }
platform_install_wezterm()     { :; }

# ===== multiplexer コンポーネント用 =====
platform_install_tmux()        { :; }

# ===== devel コンポーネント用 =====
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

# ===== editor コンポーネント用 =====
platform_install_neovim()      { :; }

# ===== ime コンポーネント用 =====
platform_install_fcitx5_mozc() { :; }

# ===== desktop コンポーネント用 =====
platform_install_xfce4_systemload() { :; }

# ===== browser コンポーネント用 =====
platform_install_chromium()                 { :; }
platform_install_firefox()                  { :; }
platform_install_firefox_ublock_origin()    { :; }

# ===== extra コンポーネント用 =====
platform_install_docker()             { :; }
platform_install_virtualbox()         { :; }
platform_install_virtualbox_guest()   { :; }
platform_install_vscode()             { :; }
platform_install_obsidian()           { :; }
