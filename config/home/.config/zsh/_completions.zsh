readonly ZSH_COMPLETIONS_LOCAL_DIR="${ZDOTDIR}/completions.local"

# ======== basic setting

fpath=($ZSH_COMPLETION_DIR $fpath)

# enable completion features
autoload -Uz compinit

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# ======== git
# Ref:
#     https://github.com/git/git/blob/ed155187b429a2a6b6475efe1767053df37ccfe1/contrib/completion/git-completion.zsh
#     [【初級者向け】ターミナル（zsh）にgitのブランチ名表示＆補完機能を公式ドキュメントをじっくり読み解いて実装 - Qiita]
#         (https://qiita.com/yamaday0u/items/ee8acb35709bcc8c7fc7#tab%E8%A3%9C%E5%AE%8C%E6%A9%9F%E8%83%BD%E3%82%92%E5%AE%9F%E8%A3%85git-completion)
# TODO: Is this working???
if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/_git" ]]; then
  curl -o "${ZSH_COMPLETIONS_LOCAL_DIR}/_git" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
fi
if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/git-completion.bash" ]]; then
  curl -o "${ZSH_COMPLETIONS_LOCAL_DIR}/git-completion.bash" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
fi
zstyle ':completion:*:*:git:*' script "${ZSH_COMPLETION_DIR}/git-completion.bash"

# ======== mise
# Ref: https://mise.jdx.dev/cli/completion.html
if [[ ! -f "${ZSH_COMPLETIONS_LOCAL_DIR}/_mise" ]]; then
  curl -o "${ZSH_COMPLETIONS_LOCAL_DIR}/_mise" https://raw.githubusercontent.com/jdx/mise/refs/heads/main/completions/_mise
fi

# ======== ???
# TODO: Add more completion for commands...

# ======== compile
# TODO: Cache zcompdump
compinit -d ~/.cache/zcompdump

