#!/usr/bin/env bash
# components/ の全ファイルを読み込む。
# hosts/*/setup_new.bash はこのファイルを1行 source するだけでよい。
set -eu

for _component in "${MYENV_ROOT}/components/"*.bash; do
    # _init.bash 自身は source しない
    [[ "$(basename "$_component")" = "_init.bash" ]] && continue
    # shellcheck source=/dev/null
    source "$_component"
done
unset _component
