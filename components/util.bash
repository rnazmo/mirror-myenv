#!/usr/bin/env bash
set -eu

source "${MYENV_ROOT}/lib/util.bash"

setup_util_clis() {
    : # Phase 2: platform_install_{tree,xclip,unzip,ghq,fzf,zoxide,eza,ripgrep,bat,fd,bottom,jq}
}

setup_fastfetch() {
    : # Phase 2: platform_install_fastfetch + config link
}

setup_yazi() {
    : # Phase 2: platform_install_yazi + config link
}

setup_proper7y() {
    : # Phase 2: install via curl
}
