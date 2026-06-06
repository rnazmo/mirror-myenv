#!/usr/bin/env bash
set -eu

# ======================================================
# ======== 設定値                                      =
# ======================================================

# pacman ミラーのホワイトリスト。
# 個人運営は廃止リスクが高いため除外し、法人・研究機関・公式コミュニティのみを採用している。
# ミラーが廃止された場合は該当行を削除する。追加する場合も同じ基準で選定すること。
# 選定の詳細は ADR-003 を参照。
# Ref:
#   https://archlinux.org/mirrors/
#   https://archlinux.org/mirrors/status/
readonly PACMAN_MIRROR_WHITELIST=(
    "https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/"
    "https://mirrors.cat.net/archlinux/"
    "https://ftp.yz.yamagata-u.ac.jp/pub/linux/archlinux/"
)

source "${MYENV_ROOT}/lib/util.bash"

# ======================================================
# ======================================================
# ======== Pre                                         =
# ======================================================
# ======================================================

pre_setup_core() {
    _refresh_packages() {
        sudo pacman -Syu --noconfirm

        # NOTE: yay may not be installed yet at this point.
        # Do not stop the whole script.
        if check_if_command_exists "yay"; then
            yay -Syu --noconfirm
        fi
    }
    _install_some_dependencies() {
        sudo pacman -S --needed --noconfirm base-devel curl vim
    }

    _install_some_dependencies

    # ミラーリストを更新してから _refresh_packages を実行する順序にすること。
    # mirrorlist が古いまま pacman -Syu を実行すると、古いミラーを使い続けてしまうため。
    # ただし update_pacman_mirror の中では pacman -Syu を呼ばない（関心事の分離）。
    # pacman -Syu は _refresh_packages に任せる。
    update_pacman_mirror
    _refresh_packages

    unset -f \
        _refresh_packages \
        _install_some_dependencies
}
readonly -f pre_setup_core

# ======================================================
# ======================================================
# ======== pacman mirror                               =
# ======================================================
# ======================================================

# Ref:
#     https://wiki.archlinux.org/title/Mirrors
#     https://wiki.archlinux.jp/index.php/%E3%83%9F%E3%83%A9%E3%83%BC
#     https://archlinux.org/mirrorlist/
update_pacman_mirror() {
    # エントリーポイント。処理の順序と全体の流れをここで把握できるようにする。
    # 個々の処理は内部関数に委譲する。
    #
    # 設計方針:
    #   - ホワイトリストで信頼済みミラーを静的管理する（動的選定より制御しやすい）
    #   - タイムスタンプで週1程度に頻度を抑える（rankmirrors の遅さを回避する）
    #   - 廃止チェックは警告のみで処理を止めない（1つ廃止されても他が使えるため）
    #   - pacman -Syu はここでは呼ばない（関心事の分離。呼び出し側に任せる）
    # Ref:
    #     https://wiki.archlinux.org/title/Mirrors
    #     https://archlinux.org/mirrors/status/

    if ! _should_update_mirror; then
        log_info "Mirror update skipped (last updated within 7 days)"
        return 0
    fi

    # 廃止チェックはミラー更新と同じタイミングで行う。
    # 毎回チェックしても警告に対応するのは人間なので、週1で十分。
    _check_mirror_availability
    _write_mirrorlist

    # タイムスタンプの更新は最後に行う。
    # 途中で失敗した場合に「次回の myenv apply 実行時に再試行する」ようにするため。
    _update_mirror_timestamp

    log_info "pacman mirror updated"
}
readonly -f update_pacman_mirror

_should_update_mirror() {
    local -r STAMP_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/mirror_last_updated"
    local -r INTERVAL_SEC=$((7 * 24 * 60 * 60))

    # スタンプファイルが存在しない = 初回実行。必ず更新する。
    # スタンプファイルを手動で削除することで強制再実行できる。
    if [[ ! -f "$STAMP_FILE" ]]; then
        return 0 # 更新する
    fi

    local -r NOW=$(date +%s)
    # date -r でファイルの更新時刻を Unix 秒で取得する（内容ではなくメタデータを使う）。
    local -r LAST=$(date -r "$STAMP_FILE" +%s)

    if ((NOW - LAST >= INTERVAL_SEC)); then
        return 0 # 更新する
    else
        return 1 # スキップ
    fi
}
readonly -f _should_update_mirror

_check_mirror_availability() {
    # 公式ミラーリストを取得し、ホワイトリストの各 URL が含まれているか確認する。
    # 含まれていない = 廃止または URL 変更の可能性があるため警告を出す。
    # 警告のみで処理は止めない。1つ廃止されても残りのミラーが使えるため。
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

    # ホワイトリストから mirrorlist の内容を組み立てる。
    local content=""
    for mirror in "${PACMAN_MIRROR_WHITELIST[@]}"; do
        content+="Server = ${mirror}\$repo/os/\$arch"$'\n'
    done

    # sudo tee で root 権限が必要なファイルに書き込む。
    # リダイレクト（>）は sudo の権限が及ばないため tee を使う。
    echo "$content" | sudo tee "$MIRROR_FILE" >/dev/null
}
readonly -f _write_mirrorlist

_update_mirror_timestamp() {
    local -r STAMP_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/mirror_last_updated"
    mkdir -p "$(dirname "$STAMP_FILE")"
    # ファイルの中身は使わない。更新時刻（mtime）だけを利用する。
    touch "$STAMP_FILE"
}
readonly -f _update_mirror_timestamp

# ======================================================
# ======================================================
# ======== Git                                         =
# ======================================================
# ======================================================

setup_git() {
    # dependencies
    _install_delta # better git diff

    _install_git
    _setup_git_config
}
readonly -f setup_git

_install_git() {
    sudo pacman -S --needed --noconfirm git
}
readonly -f _install_git

_install_delta() {
    sudo pacman -S --needed --noconfirm git-delta
}
readonly -f _install_delta

_setup_git_config() {
    remove_unused_config "${HOME}/.gitconfig"
    remove_unused_config "${HOME}/.gitignore"
    remove_unused_config "${HOME}/.gitignore_global"
    link_file "${MYENV_ROOT}/config/home/.config/git/config" "${HOME}/.config/git/config"
    link_file "${MYENV_ROOT}/config/home/.config/git/ignore" "${HOME}/.config/git/ignore"
}
readonly -f _setup_git_config

# ======================================================
# ======================================================
# ======== AUR helper                                  =
# ======================================================
# ======================================================

setup_aur_helper() {
    _install_yay
}
readonly -f setup_aur_helper

_install_yay() {
    if ! check_if_command_exists "yay"; then
        # Install yay (binary)
        # Ref:
        #     https://github.com/Jguer/yay/blob/138c2dd6cdf1a3738ee18f6bf94c1e8c37e15dc4/README.md#binary
        local -r ORIGINAL_DIR="$(pwd)"
        cd "$(mktemp -d)"

        # Ensure that dependencies is installed
        sudo pacman -S --needed git base-devel

        git clone https://aur.archlinux.org/yay-bin.git
        cd "./yay-bin"
        makepkg -si --noconfirm

        cd "$ORIGINAL_DIR"
    fi
}
readonly -f _install_yay

# ======================================================
# ======================================================
# ======== Runtime version manager                     =
# ======================================================
# ======================================================

setup_runtime_version_manager() {
    _install_mise
    _setup_mise_config
}
readonly -f setup_runtime_version_manager

_install_mise() {
    # if ! check_if_command_exists "mise"; then
    #     # Install mise under `~/.local/bin/mise` with the script
    #     # Ref:
    #     #     https://mise.jdx.dev/getting-started.html#alternate-installation-methods
    #     #     https://github.com/jdx/mise/blob/4ac34dac72144f9084b49359dc0181e8f762f0bf/docs/getting-started.md#alternate-installation-methods
    #     local -r ORIGINAL_DIR="$(pwd)"
    #     cd "$(mktemp -d)"
    #     export MISE_INSTALL_PATH="${HOME}/.local/bin/mise"
    #     curl -fsSL https://mise.jdx.dev/install.sh -o install.sh
    #     chmod +x ./install.sh
    #     ./install.sh
    #     cd "$ORIGINAL_DIR"
    # fi

    # # Insatll mise (binary)
    # # Ref:
    # #     https://aur.archlinux.org/packages/mise-bin
    # #     https://aur.archlinux.org/packages/mise
    # #     https://mise.jdx.dev/getting-started.html#alternate-installation-methods
    # # NOTE: See following "NOTE" section
    # yay -S --needed --noconfirm mise-bin

    # Install mise
    # Ref:
    #     https://archlinux.org/packages/extra/x86_64/mise/
    #     https://mise.jdx.dev/installing-mise.html#pacman
    # NOTE: Maintenance of mise has been moved from the AUR
    #     to the official Arch package.
    check_if_command_exists "yay" && yay -S --needed --noconfirm mise
}
readonly -f _install_mise

_setup_mise_config() {
    link_file "${MYENV_ROOT}/config/home/.config/mise/config.toml" "${HOME}/.config/mise/config.toml"
}
readonly -f _setup_mise_config

# ======================================================
# ======================================================
# ======== Programming Languages                       =
# ======================================================
# ======================================================

setup_programming_languages() {
    _install_golang
    _install_nodejs
}
readonly -f setup_programming_languages

_install_golang() {
    mise use --global go@latest
}
readonly -f _install_golang

_install_nodejs() {
    mise use --global node@latest
}
readonly -f _install_nodejs

# ======================================================
# ======================================================
# ======== CLI version manager                         =
# ======================================================
# ======================================================

setup_cli_version_manager() {
    _setup_aqua
}
readonly -f setup_cli_version_manager

_setup_aqua() {
    if ! check_if_command_exists "aqua"; then
        local -r ORIGINAL_DIR="$(pwd)"
        cd "$(mktemp -d)"

        curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.1/aqua-installer
        echo "fb4b3b7d026e5aba1fc478c268e8fbd653e01404c8a8c6284fdba88ae62eda6a  aqua-installer" | sha256sum -c
        chmod +x aqua-installer
        ./aqua-installer

        cd "$ORIGINAL_DIR"
    fi
    link_file "${MYENV_ROOT}/config/home/.config/aquaproj-aqua/aqua.yaml" "${HOME}/.config/aquaproj-aqua/aqua.yaml"
}
readonly -f _setup_aqua

# ======================================================
# ======================================================
# ======== Misc                                        =
# ======================================================
# ======================================================

setup_some_directories() {
    local -r DIRS=(
        "${HOME}/repos"
        "${HOME}/workspace"
        "${HOME}/workspace/sandboxes"
        "${HOME}/workspace/temp"
    )
    for DIR in "${DIRS[@]}"; do
        mkdir -p -v "$DIR"
    done

    # Link ~/.bin to the managed directory in myenv.
    # Place custom scripts in config/home/.bin/ to make them available via PATH.
    # External binaries (e.g. proper7y) should go to ~/.local/bin instead.
    remove_unused_config "${HOME}/.bin"
    link_dir "${MYENV_ROOT}/config/home/.bin" "${HOME}/.bin"
}
readonly -f setup_some_directories

# ======================================================
# ======================================================
# ======== Post                                        =
# ======================================================
# ======================================================

post_setup_core() {
    :
}
readonly -f post_setup_core
