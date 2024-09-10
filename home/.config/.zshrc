# ========== Hostory
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data ref: https://askubuntu.com/a/23631

# ========== mise
eval "$(~/.local/bin/mise activate zsh)"

# ========== Starship
eval "$(starship init zsh)"

# ========== fzf
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# =============== fzf with ghq

# What is this:
#     Search Git repositories incrementally with preview
#
# Dependencies:
#     fzf, ghq
#
# Keybinding:
#     `Ctrl-g`
#
# Ref:
#     [ghq で管理しているリポジトリに Ctrl-g で cd する on zsh - sheepla/ghq-fzf.zsh]
#         (https://gist.github.com/sheepla/d680f1480d8c36c4290d6aabebf1abc6)

function _fzf_cd_ghq() {
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --reverse --height=50%"
    local -r root="$(ghq root)"
    local -r repo="$(ghq list | fzf --preview="ls -AF --color=always ${root}/{1}")"
    local -r dir="${root}/${repo}"
    if [ -z "${dir}" ]; then
        echo "no directories found"
        return 1
    fi
    cd "${dir}"
    zle accept-line
    zle reset-prompt
}
zle -N _fzf_cd_ghq
bindkey "^g" _fzf_cd_ghq

# ========== etc
export PATH=$HOME/bin:$PATH
