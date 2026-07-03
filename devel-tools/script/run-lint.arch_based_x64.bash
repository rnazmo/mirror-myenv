#!/usr/bin/env bash
set -eu

# TODO: refactor

# グロブがマッチしない場合にパターン文字列がそのまま残るのを防ぐ
shopt -s nullglob

readonly MYENV_ROOT="${HOME}/.myenv"

source "${MYENV_ROOT}/lib/util.bash"

readonly DEVEL_TOOLS_BIN_DIR="${MYENV_ROOT}/devel-tools/bin"
readonly SHELLCHECK_CMD="shellcheck"
readonly SHELLCHECK_CMD_PATH="${DEVEL_TOOLS_BIN_DIR}/${SHELLCHECK_CMD}"

readonly TARGET_PATTERNS=(
    "${MYENV_ROOT}"/*.bash
    "${MYENV_ROOT}"/components/*.bash
    "${MYENV_ROOT}"/platforms/*/*.bash
    "${MYENV_ROOT}"/devel-tools/script/*.bash
    "${MYENV_ROOT}"/hosts/*/*.bash
    "${MYENV_ROOT}"/lib/*.bash
)

main() {
    log_debug "SHELLCHECK_CMD_PATH: ${SHELLCHECK_CMD_PATH}"

    for PATTERN in "${TARGET_PATTERNS[@]}"; do
        for TARGET in $PATTERN; do
            log_info "TARGET: $TARGET"
            "$SHELLCHECK_CMD_PATH" "$TARGET"
        done
    done
}

main
