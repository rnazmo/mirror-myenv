readonly ZSH_PLUGINS_LOCAL_DIR="${ZDOTDIR}/plugins.local"

# ======================================================
# ======== p10k Instant Prompt                         =
# ======================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ======================================================
# ======== Environment Variable                        =
# ======================================================

# ======== myenv
export MYENV_ROOT="${HOME}/.myenv"

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

# ======================================================
# ======== Plugin (pre)                                =
# ======================================================

# ======== zsh-defer
# Ref: https://github.com/romkatv/zsh-defer/blob/master/README.md#installation
source "${ZSH_PLUGINS_LOCAL_DIR}/zsh-defer/zsh-defer.plugin.zsh"

# ======================================================
# ======== Option                                      =
# ======================================================

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# ======== History
# Ref:
#     https://www.labohyt.net/blog/environment/post-4754

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_find_no_dups
# setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data ref: https://askubuntu.com/a/23631

# ======================================================
# ======== Function                                    =
# ======================================================

# source "${ZDOTDIR}/_functions.zsh"

# ======================================================
# ======== Keybinding                                  =
# ======================================================

zsh-defer source "${ZDOTDIR}/_keybindings.zsh"

# ======================================================
# ======== Completion                                  =
# ======================================================

zsh-defer source "${ZDOTDIR}/_completions.zsh"

# ======================================================
# ======== Prompt                                      =
# ======================================================

# ======== Powerlevel10k
# Ref: https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#arch-linux
# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source "${ZDOTDIR}/.p10k.zsh"

# ======================================================
# ======== Aliase                                      =
# ======================================================

zsh-defer source "${ZDOTDIR}/_aliases.zsh"

# ======================================================
# ======== Plugin (post)                               =
# ======================================================

# zsh-users/zsh-completions
zsh-defer source "${ZSH_PLUGINS_LOCAL_DIR}/zsh-completions/zsh-completions.plugin.zsh"

# zsh-users/zsh-autosuggestions
zsh-defer source "${ZSH_PLUGINS_LOCAL_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-users/zsh-syntax-highlighting
# NOTE: must be sourced at the end.
#     Ref: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/README.md#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file
zsh-defer source "${ZSH_PLUGINS_LOCAL_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# # zdharma-continuum/fast-syntax-highlighting
# # NOTE: https://github.com/zdharma-continuum/fast-syntax-highlighting/issues/8
# zsh-defer source "${ZSH_PLUGINS_LOCAL_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# zsh-users/zsh-history-substring-search
# NOTE: must come after syntax highlighting plugin
zsh-defer source "${ZSH_PLUGINS_LOCAL_DIR}/zsh-history-substring-search/zsh-history-substring-search.zsh"

# zoxide
eval "$(zoxide init zsh)"
