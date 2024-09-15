# ========== Import
[ -f "${HOME}/.config/zsh/_functions.zsh" ] && source "${HOME}/.config/zsh/_functions.zsh"
[ -f "${HOME}/.config/zsh/_aliases.zsh" ] && source "${HOME}/.config/zsh/_aliases.zsh"
# [ -f "${HOME}/.config/zsh/_path.zsh" ] && source "${HOME}/.config/zsh/_path.zsh"

# ========== Hostory
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data ref: https://askubuntu.com/a/23631

# ========== keybind
zle -N _fzf_cd_ghq
bindkey "^g" _fzf_cd_ghq

# TODO:

# ========== PATH
export PATH=$HOME/bin:$PATH

# mise
eval "$(~/.local/bin/mise activate zsh)"

# starship
eval "$(starship init zsh)"

# ========== ?
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
