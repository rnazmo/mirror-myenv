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
