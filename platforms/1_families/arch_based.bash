#!/usr/bin/env bash
set -eu

# Arch 系ディストリビューション共通の platform hook 実装。

source "${MYENV_ROOT}/lib/util.bash"

# ======================================================
# ===== pacman ミラーのホワイトリスト                  ===
# ======================================================
# 個人運営は廃止リスクが高いため除外し、法人・研究機関・公式コミュニティのみ。
# 選定の詳細は ADR-003 を参照。
readonly PACMAN_MIRROR_WHITELIST=(
    "https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/"
    "https://mirrors.cat.net/archlinux/"
    "https://ftp.yz.yamagata-u.ac.jp/pub/linux/archlinux/"
)

# ======================================================
# ===== core ===========================================
# ======================================================

platform_refresh_packages() {
    local -r STAMP_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/pacman_last_updated"
    local -r INTERVAL_SEC=$((24 * 60 * 60))
    if [[ -f "$STAMP_FILE" ]]; then
        local -r NOW=$(date +%s)
        local -r LAST=$(date -r "$STAMP_FILE" +%s)
        if ((NOW - LAST < INTERVAL_SEC)); then
            log_info "pacman update skipped (last updated within 24 hours)"
            return 0
        fi
    fi

    sudo pacman -Syu --noconfirm

    if check_if_command_exists "yay"; then
        yay -Syu --noconfirm
    fi

    mkdir -p "$(dirname "$STAMP_FILE")"
    touch "$STAMP_FILE"
}
readonly -f platform_refresh_packages

platform_update_mirrorlist() {
    if ! _should_update_mirror; then
        log_info "Mirror update skipped (last updated within 7 days)"
        return 0
    fi

    _check_mirror_availability
    _write_mirrorlist
    _update_mirror_timestamp

    log_info "pacman mirror updated"
}
readonly -f platform_update_mirrorlist

_should_update_mirror() {
    local -r STAMP_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/mirror_last_updated"
    local -r INTERVAL_SEC=$((7 * 24 * 60 * 60))

    if [[ ! -f "$STAMP_FILE" ]]; then
        return 0
    fi

    local -r NOW=$(date +%s)
    local -r LAST=$(date -r "$STAMP_FILE" +%s)

    if ((NOW - LAST >= INTERVAL_SEC)); then
        return 0
    else
        return 1
    fi
}
readonly -f _should_update_mirror

_check_mirror_availability() {
    local -r OFFICIAL_MIRRORLIST_URL="https://archlinux.org/mirrorlist/?country=JP&protocol=https"
    local official_list
    official_list=$(curl -s "$OFFICIAL_MIRRORLIST_URL")

    for mirror in "${PACMAN_MIRROR_WHITELIST[@]}"; do
        if ! echo "$official_list" | grep -qF "$mirror"; then
            log_warn "Mirror '${mirror}' is not in the official mirror list. Consider removing it from PACMAN_MIRROR_WHITELIST."
        fi
    done
}
readonly -f _check_mirror_availability

_write_mirrorlist() {
    local -r MIRROR_FILE="/etc/pacman.d/mirrorlist"

    local content=""
    for mirror in "${PACMAN_MIRROR_WHITELIST[@]}"; do
        content+="Server = ${mirror}\$repo/os/\$arch"$'\n'
    done

    echo "$content" | sudo tee "$MIRROR_FILE" >/dev/null
}
readonly -f _write_mirrorlist

_update_mirror_timestamp() {
    local -r STAMP_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/mirror_last_updated"
    mkdir -p "$(dirname "$STAMP_FILE")"
    touch "$STAMP_FILE"
}
readonly -f _update_mirror_timestamp

platform_ensure_build_deps() {
    sudo pacman -S --needed --noconfirm base-devel curl vim
}
readonly -f platform_ensure_build_deps

platform_install_git() {
    sudo pacman -S --needed --noconfirm git
}
readonly -f platform_install_git

platform_install_delta() {
    sudo pacman -S --needed --noconfirm git-delta
}
readonly -f platform_install_delta

platform_install_yay() {
    if ! check_if_command_exists "yay"; then
        local -r ORIGINAL_DIR="$(pwd)"
        cd "$(mktemp -d)"

        sudo pacman -S --needed git base-devel

        git clone https://aur.archlinux.org/yay-bin.git
        cd "./yay-bin"
        makepkg -si --noconfirm

        cd "$ORIGINAL_DIR"
    fi
}
readonly -f platform_install_yay

platform_install_mise() {
    if ! check_if_command_exists "mise"; then
        if ! check_if_command_exists "yay"; then
            log_err "yay is required to install mise"
            return 1
        fi
        yay -S --needed --noconfirm mise
    fi
}
readonly -f platform_install_mise

# ======================================================
# ===== shell ===========================================
# ======================================================

platform_install_zsh() {
    sudo pacman -S --needed --noconfirm zsh
}
readonly -f platform_install_zsh

platform_install_p10k() {
    if pacman -Qi zsh-theme-powerlevel10k-git &>/dev/null; then
        log_info "powerlevel10k is already installed. Skipping."
        return 0
    fi

    yay -S --needed --noconfirm zsh-theme-powerlevel10k-git
}
readonly -f platform_install_p10k

# ======================================================
# ===== util ============================================
# ======================================================

platform_install_tree()        { sudo pacman -S --needed --noconfirm tree; }
readonly -f platform_install_tree

platform_install_xclip()       { sudo pacman -S --needed --noconfirm xclip; }
readonly -f platform_install_xclip

platform_install_unzip()       { sudo pacman -S --needed --noconfirm unzip; }
readonly -f platform_install_unzip

platform_install_ghq()         { sudo pacman -S --needed --noconfirm ghq; }
readonly -f platform_install_ghq

platform_install_fzf()         { sudo pacman -S --needed --noconfirm fzf; }
readonly -f platform_install_fzf

platform_install_zoxide()      { sudo pacman -S --needed --noconfirm zoxide; }
readonly -f platform_install_zoxide

platform_install_eza()         { sudo pacman -S --needed --noconfirm eza; }
readonly -f platform_install_eza

platform_install_ripgrep()     { sudo pacman -S --needed --noconfirm ripgrep; }
readonly -f platform_install_ripgrep

platform_install_bat()         { sudo pacman -S --needed --noconfirm bat; }
readonly -f platform_install_bat

platform_install_fd()          { sudo pacman -S --needed --noconfirm fd; }
readonly -f platform_install_fd

platform_install_bottom()      { sudo pacman -S --needed --noconfirm bottom; }
readonly -f platform_install_bottom

platform_install_jq()          { sudo pacman -S --needed --noconfirm jq; }
readonly -f platform_install_jq

platform_install_fastfetch()   { sudo pacman -S --needed --noconfirm fastfetch; }
readonly -f platform_install_fastfetch

platform_install_yazi()        { sudo pacman -S --needed --noconfirm yazi; }
readonly -f platform_install_yazi

# ======================================================
# ===== devel ===========================================
# ======================================================

platform_install_shellcheck()          { sudo pacman -S --needed --noconfirm shellcheck; }
readonly -f platform_install_shellcheck

platform_install_shfmt()               { sudo pacman -S --needed --noconfirm shfmt; }
readonly -f platform_install_shfmt

platform_install_selene()              { sudo pacman -S --needed --noconfirm selene; }
readonly -f platform_install_selene

platform_install_stylua()              { sudo pacman -S --needed --noconfirm stylua; }
readonly -f platform_install_stylua

platform_install_staticcheck()         { sudo pacman -S --needed --noconfirm staticcheck; }
readonly -f platform_install_staticcheck

platform_install_eslint_d()            { sudo pacman -S --needed --noconfirm eslint_d; }
readonly -f platform_install_eslint_d

platform_install_prettier()            { sudo pacman -S --needed --noconfirm prettier; }
readonly -f platform_install_prettier

platform_install_markdownlint_cli2()   { sudo pacman -S --needed --noconfirm markdownlint-cli2; }
readonly -f platform_install_markdownlint_cli2

platform_install_actionlint()          { sudo pacman -S --needed --noconfirm actionlint; }
readonly -f platform_install_actionlint

platform_install_typos()               { sudo pacman -S --needed --noconfirm typos; }
readonly -f platform_install_typos

platform_install_lazygit()             { sudo pacman -S --needed --noconfirm lazygit; }
readonly -f platform_install_lazygit

# ======================================================
# ===== terminal ========================================
# ======================================================

platform_install_alacritty()   { sudo pacman -S --needed --noconfirm alacritty; }
readonly -f platform_install_alacritty

platform_install_wezterm()     { sudo pacman -S --needed --noconfirm wezterm; }
readonly -f platform_install_wezterm

# ======================================================
# ===== multiplexer =====================================
# ======================================================

platform_install_tmux()        { sudo pacman -S --needed --noconfirm tmux; }
readonly -f platform_install_tmux

# ======================================================
# ===== editor ==========================================
# ======================================================

platform_install_neovim()      { sudo pacman -S --needed --noconfirm neovim; }
readonly -f platform_install_neovim

# ======================================================
# ===== ime =============================================
# ======================================================

platform_install_fcitx5_mozc() {
    local PKGS=("fcitx-mozc" "fcitx-configtool" "fcitx-qt5" "fcitx")
    for PKG in "${PKGS[@]}"; do
        if pacman -Qi "$PKG" &>/dev/null; then
            sudo pacman -Rns --noconfirm "$PKG"
        fi
    done
    unset PKGS

    sudo pacman -S --needed --noconfirm fcitx5-mozc fcitx5-im
}
readonly -f platform_install_fcitx5_mozc

# ======================================================
# ===== desktop =========================================
# ======================================================

platform_install_xfce4_systemload() { sudo pacman -S --needed --noconfirm xfce4-systemload-plugin; }
readonly -f platform_install_xfce4_systemload

# ======================================================
# ===== browser =========================================
# ======================================================

platform_install_chromium()    { sudo pacman -S --needed --noconfirm chromium; }
readonly -f platform_install_chromium

platform_install_firefox()     { sudo pacman -S --needed --noconfirm firefox; }
readonly -f platform_install_firefox

# ======================================================
# ===== extra ===========================================
# ======================================================

platform_install_docker()             { sudo pacman -S --needed --noconfirm docker docker-compose; }
readonly -f platform_install_docker

platform_install_virtualbox()         {     sudo pacman -S --needed --noconfirm virtualbox virtualbox-host-modules-arch virtualbox-guest-iso; }
readonly -f platform_install_virtualbox

platform_install_virtualbox_guest()   { sudo pacman -S --needed virtualbox-guest-utils; }
readonly -f platform_install_virtualbox_guest

platform_install_vscode() {
    yay -S --needed --noconfirm visual-studio-code-bin
}
readonly -f platform_install_vscode

platform_install_obsidian()           { sudo pacman -S --needed obsidian; }
readonly -f platform_install_obsidian
