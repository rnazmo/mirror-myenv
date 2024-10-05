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

source "${ZDOTDIR}/_functions.zsh"

# ======================================================
# ======== Keybinding                                  =
# ======================================================

source "${ZDOTDIR}/_keybindings.zsh"

# ======================================================
# ======== Completion                                  =
# ======================================================

source "${ZDOTDIR}/_completions.zsh"

# ======================================================
# ======== Prompt                                      =
# ======================================================

# Using starship
eval "$(starship init zsh)"

# ======================================================
# ======== Aliase                                      =
# ======================================================

source "${ZDOTDIR}/_aliases.zsh"

# ======================================================
# ======== PATH                                        =
# ======================================================

typeset -U path PATH

# [ -f "${ZDOTDIR}/_path.zsh" ] && source "${ZDOTDIR}/_path.zsh"
# TODO:

export PATH="$HOME/bin:$PATH"

# mise
# Ref: https://mise.jdx.dev/getting-started.html#_2a-activate-mise
eval "$(~/.local/bin/mise activate zsh)"

# aqua
# Ref: https://aquaproj.github.io/docs/install#2-set-the-environment-variable-path
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"

# ======================================================
# ======== Plugins                                     =
# ======================================================

# Loading plugins with sheldon
eval "$(sheldon source)"

