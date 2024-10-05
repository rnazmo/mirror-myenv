# TODO:
#     .zprofile vs .zshenv vs .zshrc ?

# ======================================================
# ======== Environment Variable                        =
# ======================================================

# ======== zsh
export ZDOTDIR="${HOME}/.config/zsh"

# ======== myenv-v3
export MYENV_ROOT="${HOME}/.myenv-v3"

# ======== basic
export LANG=en_US.UTF-8
export EDITOR="nvim"

# ======== ???
# TODO: etc...

# ======================================================
# ======== PATH                                        =
# ======================================================

# ======== basic settings for PATH
# Avoid duplicate
typeset -U path PATH

# ======== PATH
path=(
  # ======== basic
  $HOME/bin(N-/)
  # ======== mise
  # Ref:
  #     https://mise.jdx.dev/getting-started.html#_2b-alternative-add-mise-shims-to-path
  #     https://mise.jdx.dev/getting-started.html#_2a-activate-mise
  $HOME/.local/share/mise/shims(N-/)
  # ======== golang
  # export GOPATH="${HOME}/go"
  # ======== aqua
  # Ref: https://aquaproj.github.io/docs/install#2-set-the-environment-variable-path
  ${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin(N-/)
  # ========
  $path
)

