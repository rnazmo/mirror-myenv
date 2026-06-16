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
