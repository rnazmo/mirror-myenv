#!/usr/bin/env bash
set -eu

# Udon (EndeavourOS) のセットアップ。
# 3層アーキテクチャ版: 明示的な source 順で platform chain を構成する。

source "${MYENV_ROOT}/lib/util.bash"

source "${MYENV_ROOT}/platforms/0_common/default.bash"
source "${MYENV_ROOT}/platforms/1_families/arch_based.bash"
source "${MYENV_ROOT}/platforms/2_distros/endeavouros.bash"

source "${MYENV_ROOT}/components/core.bash"
source "${MYENV_ROOT}/components/shell.bash"
source "${MYENV_ROOT}/components/util.bash"
source "${MYENV_ROOT}/components/terminal.bash"
source "${MYENV_ROOT}/components/multiplexer.bash"
source "${MYENV_ROOT}/components/editor.bash"
source "${MYENV_ROOT}/components/devel.bash"
source "${MYENV_ROOT}/components/ime.bash"
source "${MYENV_ROOT}/components/desktop.bash"
source "${MYENV_ROOT}/components/browser.bash"
source "${MYENV_ROOT}/components/extra.bash"

main() {
    log_info "Starting setup for udon (EndeavourOS)"

    setup_core
    setup_shell
    setup_util
    setup_terminal
    setup_multiplexer
    setup_editor
    setup_devel
    setup_ime
    setup_desktop
    setup_browser
    setup_extra

    log_info "Completed setup for udon (EndeavourOS)"
}
