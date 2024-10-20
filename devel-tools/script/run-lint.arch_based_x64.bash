#!/usr/bin/env bash
set -eu

# TODO: refactor

readonly MYENV_ROOT="${HOME}/.myenv"

source "${MYENV_ROOT}/lib/util.bash"

readonly DEVEL_TOOLS_BIN_DIR="${MYENV_ROOT}/devel-tools/bin"
readonly SHELLCHECK_CMD="shellcheck"
readonly SHELLCHECK_CMD_PATH="${DEVEL_TOOLS_BIN_DIR}/${SHELLCHECK_CMD}"

readonly TARGETSS=(
    "${MYENV_ROOT}"/*.bash
    "${MYENV_ROOT}"/devel-tools/script/*.bash
    "${MYENV_ROOT}"/hosts/*/*.bash
    "${MYENV_ROOT}"/lib/*.bash
    "${MYENV_ROOT}"/recipes/*/*.bash
)

main() {
    log_debug "SHELLCHECK_CMD_PATH: ${SHELLCHECK_CMD_PATH}"

    for TARGETS in "${TARGETSS[@]}"; do
        for TARGET in $TARGETS; do
            log_info "TARGET: $TARGET"
            "$SHELLCHECK_CMD_PATH" "$TARGET"
        done
    done
}

main
