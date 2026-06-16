#!/usr/bin/env bash
set -eu

# Manjaro 固有の platform hook 実装。

source "${MYENV_ROOT}/lib/util.bash"

platform_pre_install_p10k() {
    : # Phase 2: manjaro-zsh-config の削除
}
