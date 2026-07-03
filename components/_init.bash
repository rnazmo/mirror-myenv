#!/usr/bin/env bash
# components/ の全ファイルを明示的な順序で読み込む。
# 先に読み込んだ component の関数を後続の component が参照してよい。
# 新たな component を追加する際は、依存関係を考慮して挿入位置を決めること。
set -eu

source "${MYENV_ROOT}/components/core.bash"
source "${MYENV_ROOT}/components/shell.bash"
source "${MYENV_ROOT}/components/terminal.bash"
source "${MYENV_ROOT}/components/multiplexer.bash"
source "${MYENV_ROOT}/components/editor.bash"
source "${MYENV_ROOT}/components/devel.bash"
source "${MYENV_ROOT}/components/ime.bash"
source "${MYENV_ROOT}/components/desktop.bash"
source "${MYENV_ROOT}/components/util.bash"
source "${MYENV_ROOT}/components/browser.bash"
source "${MYENV_ROOT}/components/maintenance.bash"
source "${MYENV_ROOT}/components/extra.bash"
