#!/usr/bin/env bash
set -eu

# CachyOS 固有の platform hook 実装。

source "${MYENV_ROOT}/lib/util.bash"

platform_pre_install_p10k() {
    : # Phase 2: cachyos-zsh-config の削除
}
