    # TODO: 以下は仮

main() {

    log_debug "START: ${BASH_SOURCE}"
    # ======================================================
    # ======== git                                         =
    # ======================================================

    local -r GIT_GLOBAL_NAME="rnazmo"
    local -r GIT_GLOBAL_ENAIL="rnazmo@gmail.com"

    # Set git global config
    git config --global user.name "$GIT_GLOBAL_NAME"
    git config --global user.email "$GIT_GLOBAL_ENAIL"

    if ssh -T git@github.com &>/dev/null && ssh -T git@gitlab.com &>/dev/null; then
        : # Do nothing. (The SSH connection settings are already done)
    else
        # Register SSH public key to GitLab(/GitHub)
        [ ! -f "${HOME}/.ssh/id_ed25519.pub" ] && ssh-keygen -t ed25519
        cat "${HOME}/.ssh/id_ed25519.pub"
        echo "Open https://github.com/settings/ssh/new and register the SSH public key"
        echo "Open https://gitlab.com/-/user_settings/ssh_keys and register the SSH public key"
        ssh -T git@github.com
        ssh -T git@gitlab.com
    fi
  
    log_debug "END  : ${BASH_SOURCE}"
}

main
