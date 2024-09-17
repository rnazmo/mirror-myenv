#!/bin/bash
set -eu

# TDOO: Add tests

_check_if_path_exists() {
    echo "TODO:"
}

_check_if_path_is_file() {
    echo "TODO:"
}

_check_if_path_is_dir() {
    echo "TODO:"
}

_check_if_path_is_symlink() {
    echo "TODO:"
}

_check_if_file_exists() {
    echo "TODO:"
}

_check_if_dir_exists() {
    echo "TODO:"
}

check_if_command_exists() {
    local -r COMMAND=$1
    return command -v "${COMMAND}" &> /dev/null
}

# What is this:
#     Remove symbolic link if the path is symbolic link.
#     If the path is not symbolic link, do nothing.
# Usage:
#     remove_symlink <PATH>
remove_symlink() {
    local -r TARGET_PATH=$1
    unlink $TARGET_PATH
}

# What is this:
#     Create symbolic link to a file.
#
# Usage:
#     link_file <source_file> <target_file>
#
# Arguments:
#     source_file:
#         must be a regular file. (symbolic link is not allowed)
#         TODO: symbolic link は許してもよいかも？
#     target_file:
#         If it's already a symbolic link, remove and recreate it.
# 
# Example:
#     link_file "${HOME}/.myenv/config/home/.zshrc" "${HOME}/.zshrc"
link_file() {
    # 引数の受け取り
    local -r SOURCE_FILE=$1
    local -r TARGET_FILE=$2
    local -r TARGET_PARENT_DIR="$(dirname "$TARGET_FILE")"

    # バリデーション
    if [[ ! -e "$SOURCE_FILE" ]]; then
        log_err "Source file '$SOURCE_FILE' does not exist."
        return 1
    fi
    if [[ -L "$SOURCE_FILE" ]]; then
        log_err "Source file '$SOURCE_FILE' is symbolic link. Must be a regular file."
    fi
    if [[ ! -f "$SOURCE_FILE" ]]; then
        log_err "Source file '$SOURCE_FILE' must be a regular file."
        return 1
    fi

    if [[ ! -d "$TARGET_PARENT_DIR" ]]; then
        log_info "Created diractory $TARGET_PARENT_DIR"
        mkdir -p "$TARGET_PARENT_DIR"
    fi
    if [[ -e "$TARGET_FILE" ]]; then
        if [[ -L "$TARGET_FILE" ]]; then
            log_warn "Removing existing symbolic link at '$TARGET_FILE'."
            unlink "$TARGET_FILE"
        else
            log_err "A file or directory already exists at '$TARGET_FILE'."
            return 1
        fi
    fi

    ln -s $SOURCE_FILE $TARGET_FILE
    log_info "Symbolic link created: '$TARGET_FILE' -> '$SOURCE_FILE'"
}

# What is this:
#     Create symbolic link to a directory.
#
# Usage:
#     link_dir <source_dir> <target_dir>
#
# Arguments:
#     source_dir:
#         must be a directory. (symbolic link is not allowed)
#         TODO: symbolic link は許してもよいかも？
#     target_dir:
#         If it's already a symbolic link, remove and recreate it.
# 
# Example:
#     link_dir "${HOME}/.myenv/config/home/.config/zsh" "${HOME}/.config/zsh"
# 
# NOTE:
#     循環参照を起こさないように注意する
#         TARGET_DIR について入念なチェックをし、シンボリックリンクがあった場合に消しているのはそのため。
#         Ref:
#             [【ちょっとしたこと】Linux のシンボリックリンクを作成する際にちょっと困ったこと - サーバーワークスエンジニアブログ](https://blog.serverworks.co.jp/ln-s-no-fushigi)
#             [シンボリックリンクの向き先変更（ln -nfs TARGET LINK_NAME） - Qiita](https://qiita.com/takeoverjp/items/bb1576e90a8a495db4b3)
link_dir() {
    # 引数の受け取り
    local -r SOURCE_DIR=$1
    local -r TARGET_DIR=$2
    local -r TARGET_PARENT_DIR="$(dirname "$TARGET_DIR")"

    # バリデーション
    if [[ ! -e "$SOURCE_DIR" ]]; then
        log_err "Source directory '$SOURCE_DIR' does not exist."
        return 1
    fi
    if [[ -L "$SOURCE_DIR" ]]; then
        log_err "Source directory '$SOURCE_DIR' is symbolic link. Must be a directory."
    fi
    if [[ ! -d "$SOURCE_DIR" ]]; then
        log_err "Source directory '$SOURCE_DIR' must be a regular directory."
        return 1
    fi

    if [[ ! -d "$TARGET_PARENT_DIR" ]]; then
        log_info "Created diractory $TARGET_PARENT_DIR"
        mkdir -p "$TARGET_PARENT_DIR"
    fi
    if [[ -e "$TARGET_DIR" ]]; then
        if [[ -L "$TARGET_DIR" ]]; then
            log_warn "Removing existing symbolic link at '$TARGET_DIR'."
            unlink "$TARGET_DIR"
        else
            log_err "A file or directory already exists at '$TARGET_DIR'."
            return 1
        fi
    fi

    ln -s $SOURCE_DIR $TARGET_DIR
    log_info "Symbolic link created: '$TARGET_DIR' -> '$SOURCE_DIR'"
}

# Add a new path to `PATH`
add_path() {
    echo "TODO:"
}

_clone_git_repo() {
    echo "TODO:"
}

clone_git_repo_from_github() {
    echo "TODO:"
}

clone_git_repo_from_gitlab() {
    echo "TODO:"
}

_download_git_repo() {
    echo "TODO:"
}

download_git_repo_from_github() {
    echo "TODO:"
}

download_git_repo_from_gitlab() {
    echo "TODO:"
}

install_via_pacman() {
    echo "TODO:"
}

install_via_yay() {
    echo "TODO:"
}

install_via_mise() {
    echo "TODO:"
}

install_via_aqua() {
    echo "TODO:"
}

# VirtualBoxのゲストマシンかどうかを判別する関数
# 戻り値：
#     VirtualBoxのゲストマシンであれば0,
#     そうでなければ1
is_virtualbox_guest() {
    if systemd-detect-virt --vm | grep -q "oracle"; then
        return 0  # Running in a VirtualBox guest
    else
        return 1  # Not running in a VirtualBox guest
    fi
}

# その環境が仮想化環境(VM やコンテナ)でないことを判別する関数
# 注：
#     virtualized environment ∋ virtual machine, container
# 戻り値：
#     ゲストマシンでない（＝ホストマシン）なら 0,
#     ゲストマシンなら 1
is_not_virtualized_environment() {
    if systemd-detect-virt -q; then
        echo "この環境は仮想化環境またはコンテナです。"
        return 1  # Running in a vm guest
    else
        echo "この環境は仮想化環境ではありません。"
        return 0  # Not running in a vm guest (= host machine)
    fi
}

log_debug() {
  local -r PREFIX="DEBUG:"
  echo "$PREFIX $1"
}

log_info() {
  local -r PREFIX="INFO :"
  echo "$PREFIX $1"
}

log_warn() {
  local -r PREFIX="WARN :" >&2
  echo "$PREFIX $1"
}

log_err() {
  local -r PREFIX="ERROR:" >&2
  echo "$PREFIX $1"
}
