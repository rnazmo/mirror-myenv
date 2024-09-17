#!/bin/bash
set -eu

# TDOO: Add tests

_check_if_path_exists() {}

_check_if_path_is_file() {}

_check_if_path_is_dir() {}

_check_if_path_is_symlink() {}

_check_if_file_exists() {}

_check_if_dir_exists() {}

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
# Usage:
#     link_file <source_file> <target_file>
# Example:
#     link_file "${HOME}/.myenv/config/home/.zshrc" "${HOME}/.zshrc"
link_file() {
    # 引数の受け取り
    local -r SOURCE_FILE=$1
    local -r TARGET_FILE=$2
    local -r TARGET_PARENT_DIR="TARGET_FILE の親ディレクトリ"

    # バリデーション
    # パス SOURCE_FILE が存在することを確認する
    # パス SOURCE_FILE がファイルであることを確認する
    # パス SOURCE_FILE がシンボリックリンクでないことを確認する？

    # パス TARGET_PARENT_DIR が存在し無いなら作る
    # パス TARGET_FILE に、ファイル・ディレクトリが存在しないことを確認する
    # パス TARGET_FILE に、シンボリックリンクが存在する場合、消す
    # unlink $TARGET_FILE

    ln -s $SOURCE_FILE $TARGET_FILE
}

# What is this:
#     Create symbolic link to a directory.
# Usage:
#     link_dir <source_dir> <target_dir>
# Example:
#     link_dir "${HOME}/.myenv/config/home/.config/zsh" "${HOME}/.config/zsh"
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
    local -r TARGET_PARENT_DIR="TARGET_DIR の親ディレクトリ"

    # バリデーション
    # パス SOURCE_DIR が存在することを確認する
    # パス SOURCE_DIR がディレクトリであることを確認する
    # パス SOURCE_DIR がシンボリックリンクでないことを確認する？

    # パス TARGET_PARENT_DIR が存在し無いなら作る
    # パス TARGET_DIR に、ファイル・ディレクトリが存在しないことを確認する
    # パス TARGET_DIR に、シンボリックリンクが存在する場合、消す
    # unlink $TARGET_DIR

    ln -s $SOURCE_DIR $TARGET_DIR
}

add_path() {} # Add a new path to `PATH`

_clone_git_repo() {}

clone_git_repo_from_github() {}

clone_git_repo_from_gitlab() {}

_download_git_repo() {}

download_git_repo_from_github() {}

download_git_repo_from_gitlab() {}

install_via_pacman() {}

install_via_yay() {}

install_via_mise() {}

install_via_aqua() {}

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