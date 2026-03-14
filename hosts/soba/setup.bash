#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

source "${MYENV_ROOT}/recipes/cachyos_x64/0_core.bash"
source "${MYENV_ROOT}/recipes/cachyos_x64/1_base.bash"
source "${MYENV_ROOT}/recipes/cachyos_x64/2_extra.bash"

main() {
    call_func_in_0_core() {
        log_debug "/hosts/soba/setup.bash - pre_setup_core"
        pre_setup_core
        log_debug "/hosts/soba/setup.bash - setup_git"
        setup_git
        log_debug "/hosts/soba/setup.bash - setup_aur_helper"
        setup_aur_helper
        log_debug "/hosts/soba/setup.bash - setup_runtime_version_manager"
        setup_runtime_version_manager
        setup_programming_languages
        setup_some_directories
        post_setup_core
    }
    call_func_in_1_base() {
        pre_setup_base
        setup_font
        setup_ime
        setup_util
        setup_shell_on_manjaro
        setup_terminal
        setup_multiplexer
        setup_devel
        setup_editor
        setup_browser
        post_setup_base
    }
    call_func_in_2_extra() {
        pre_setup_extra
        # something here
        post_setup_extra
    }

    call_func_in_0_core
    call_func_in_1_base
    call_func_in_2_extra
}

main
