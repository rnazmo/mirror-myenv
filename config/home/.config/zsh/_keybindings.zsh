readonly ZSH_KEYBINDINGS_LOCAL_DIR="${ZDOTDIR}/keybindings.local"

# ======== basic

bindkey -e                                        # emacs key bindings (it's important:) )
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

# ======== my functions

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
function _fuzzy_choose_repo() {
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
zle -N _fuzzy_choose_repo
bindkey "^Xq" _fuzzy_choose_repo

# ======== fzf
source "${ZSH_KEYBINDINGS_LOCAL_DIR}/key-bindings.zsh"
