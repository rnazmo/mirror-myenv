#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

# ======================================================
# ===== maintenance entry point ========================
# ======================================================

setup_maintenance() {
    maintain_package_cache
    maintain_system_logs
    maintain_build_caches
    maintain_browser_caches
}
readonly -f setup_maintenance

# ======================================================
# ===== package cache ===================================
# ======================================================

maintain_package_cache() {
    platform_clean_package_cache
    platform_clean_yay_cache
}
readonly -f maintain_package_cache

# ======================================================
# ===== system logs ====================================
# ======================================================

maintain_system_logs() {
    platform_clean_system_logs
}
readonly -f maintain_system_logs

# ======================================================
# ===== build caches ===================================
# ======================================================

maintain_build_caches() {
    _maintain_npm_cache
    _maintain_go_cache
    _maintain_mise_versions
}
readonly -f maintain_build_caches

_maintain_npm_cache() {
    local -r STAMP_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/maintenance/npm_cache_cleaned"
    local -r INTERVAL_SEC=$((30 * 24 * 60 * 60))

    if [[ -f "$STAMP_FILE" ]]; then
        local -r NOW=$(date +%s)
        local -r LAST=$(date -r "$STAMP_FILE" +%s)
        if ((NOW - LAST < INTERVAL_SEC)); then
            log_info "npm cache cleanup skipped (last cleaned within 30 days)"
            return 0
        fi
    fi

    if check_if_command_exists "npm"; then
        npm cache clean --force
    fi

    mkdir -p "$(dirname "$STAMP_FILE")"
    touch "$STAMP_FILE"
}
readonly -f _maintain_npm_cache

_maintain_go_cache() {
    local -r STAMP_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/maintenance/go_cache_cleaned"
    local -r INTERVAL_SEC=$((30 * 24 * 60 * 60))

    if [[ -f "$STAMP_FILE" ]]; then
        local -r NOW=$(date +%s)
        local -r LAST=$(date -r "$STAMP_FILE" +%s)
        if ((NOW - LAST < INTERVAL_SEC)); then
            log_info "Go build cache cleanup skipped (last cleaned within 30 days)"
            return 0
        fi
    fi

    if check_if_command_exists "go"; then
        go clean -cache
    fi

    mkdir -p "$(dirname "$STAMP_FILE")"
    touch "$STAMP_FILE"
}
readonly -f _maintain_go_cache

_maintain_mise_versions() {
    local -r STAMP_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/maintenance/mise_pruned"
    local -r INTERVAL_SEC=$((30 * 24 * 60 * 60))

    if [[ -f "$STAMP_FILE" ]]; then
        local -r NOW=$(date +%s)
        local -r LAST=$(date -r "$STAMP_FILE" +%s)
        if ((NOW - LAST < INTERVAL_SEC)); then
            log_info "mise prune skipped (last pruned within 30 days)"
            return 0
        fi
    fi

    if check_if_command_exists "mise"; then
        mise prune --tools --yes
    fi

    mkdir -p "$(dirname "$STAMP_FILE")"
    touch "$STAMP_FILE"
}
readonly -f _maintain_mise_versions

# ======================================================
# ===== browser caches =================================
# ======================================================

maintain_browser_caches() {
    local -r STAMP_FILE="${XDG_CACHE_HOME:-${HOME}/.cache}/myenv/maintenance/browser_cache_cleaned"
    local -r INTERVAL_SEC=$((30 * 24 * 60 * 60))

    if [[ -f "$STAMP_FILE" ]]; then
        local -r NOW=$(date +%s)
        local -r LAST=$(date -r "$STAMP_FILE" +%s)
        if ((NOW - LAST < INTERVAL_SEC)); then
            log_info "browser cache cleanup skipped (last cleaned within 30 days)"
            return 0
        fi
    fi

    rm -rf "${HOME}/.cache/chromium" 2>/dev/null || true
    rm -rf "${HOME}/.cache/mozilla" 2>/dev/null || true
    rm -rf "${HOME}/.cache/google-chrome" 2>/dev/null || true

    mkdir -p "$(dirname "$STAMP_FILE")"
    touch "$STAMP_FILE"
}
readonly -f maintain_browser_caches
