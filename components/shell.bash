#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

readonly ZDOTDIR="${HOME}/.config/zsh"

setup_zsh() {
    platform_install_zsh
    _setup_zsh_config
    _setup_zsh_completions
    _setup_zsh_keybindings
    _setup_zsh_theme
    _setup_zsh_plugins
    _post_setup_zsh
}
readonly -f setup_zsh

_setup_zsh_config() {
    remove_unused_config "${HOME}/.zshrc"
    remove_unused_config "${HOME}/.zshenv"
    link_file "${MYENV_ROOT}/config/home/.zshenv" "${HOME}/.zshenv"
    link_file "${MYENV_ROOT}/config/home/.config/zsh/.zshrc" "${ZDOTDIR}/.zshrc"
    link_dir "${MYENV_ROOT}/config/home/.config/zsh/zshrc.d" "${ZDOTDIR}/zshrc.d"
}
readonly -f _setup_zsh_config

_setup_zsh_completions() {
    local -r ZSH_COMPLETIONS_LOCAL_DIR="${ZDOTDIR}/completions.local"

    if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/_git" ]]; then
        download_file \
            "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh" \
            "${ZSH_COMPLETIONS_LOCAL_DIR}/_git"
    fi
    if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/git-completion.bash" ]]; then
        download_file \
            "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" \
            "${ZSH_COMPLETIONS_LOCAL_DIR}/git-completion.bash"
    fi
    if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/_mise" ]]; then
        download_file \
            "https://raw.githubusercontent.com/jdx/mise/refs/heads/main/completions/_mise" \
            "${ZSH_COMPLETIONS_LOCAL_DIR}/_mise"
    fi
}
readonly -f _setup_zsh_completions

_setup_zsh_keybindings() {
    local -r ZSH_KEYBINDINGS_LOCAL_DIR="${ZDOTDIR}/keybindings.local"

    if [[ ! -f "${ZSH_KEYBINDINGS_LOCAL_DIR}/fzf.zsh" ]]; then
        download_file \
            "https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/key-bindings.zsh" \
            "${ZSH_KEYBINDINGS_LOCAL_DIR}/fzf.zsh"
    fi
}
readonly -f _setup_zsh_keybindings

_setup_zsh_theme() {
    platform_pre_install_p10k
    platform_install_p10k
}
readonly -f _setup_zsh_theme

_setup_zsh_plugins() {
    local -r ZSH_PLUGINS_LOCAL_DIR="${ZDOTDIR}/plugins.local"

    clone_repo_shallow \
        https://github.com/romkatv/zsh-defer.git \
        "${ZSH_PLUGINS_LOCAL_DIR}/zsh-defer"

    clone_repo_shallow \
        https://github.com/zsh-users/zsh-completions.git \
        "${ZSH_PLUGINS_LOCAL_DIR}/zsh-completions"

    clone_repo_shallow \
        https://github.com/zsh-users/zsh-autosuggestions.git \
        "${ZSH_PLUGINS_LOCAL_DIR}/zsh-autosuggestions"

    clone_repo_shallow \
        https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_PLUGINS_LOCAL_DIR}/zsh-syntax-highlighting"

    clone_repo_shallow \
        https://github.com/zsh-users/zsh-history-substring-search.git \
        "${ZSH_PLUGINS_LOCAL_DIR}/zsh-history-substring-search"
}
readonly -f _setup_zsh_plugins

_post_setup_zsh() {
    find "$ZDOTDIR/" -name '*.zsh' -exec zsh -c 'zcompile "$0"' {} \;
}
readonly -f _post_setup_zsh

setup_default_shell() {
    local -r ZSH_PATH
    ZSH_PATH="$(command -v zsh)"

    if check_if_command_exists "zsh" && [ "$SHELL" != "$ZSH_PATH" ]; then
        chsh -s "$ZSH_PATH"
        log_info "Changed your default login shell to Zsh"
    fi
}
readonly -f setup_default_shell
