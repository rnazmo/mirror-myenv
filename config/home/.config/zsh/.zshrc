# ==================================
# ======== Import                  =
# ==================================

[ -f "${HOME}/.config/zsh/_functions.zsh" ] && source "${HOME}/.config/zsh/_functions.zsh"

# ==================================
# ======== Set Zsh options         =
# ==================================

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

# ==================================
# ======== History                 =
# ==================================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data ref: https://askubuntu.com/a/23631

# ==================================
# ======== Keybinding              =
# ==================================

bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

zle -N _fzf_cd_ghq
bindkey "^g" _fzf_cd_ghq

# ==================================
# ======== Completion              =
# ==================================

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion


# ==================================
# ======== Prompt                  =
# ==================================

# Using starship
eval "$(starship init zsh)"

# ==================================
# ======== Extra                   =
# ==================================

# Ref: https://archlinux.org/packages/extra/any/zsh-syntax-highlighting/
[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# Ref: https://archlinux.org/packages/extra/any/zsh-autosuggestions/
[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Ref: https://archlinux.org/packages/extra/any/zsh-history-substring-search/
[ -f "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" ] && source "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# ==================================
# ======== Aliase                  =
# ==================================

[ -f "${HOME}/.config/zsh/_aliases.zsh" ] && source "${HOME}/.config/zsh/_aliases.zsh"

# ==================================
# ======== PATH                    =
# ==================================

# [ -f "${HOME}/.config/zsh/_path.zsh" ] && source "${HOME}/.config/zsh/_path.zsh"
# TODO:

export PATH=$HOME/bin:$PATH

# mise
eval "$(~/.local/bin/mise activate zsh)"
