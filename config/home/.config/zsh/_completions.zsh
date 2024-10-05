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
zstyle ':completion:*:*:git:*' script "${ZSH_COMPLETION_DIR}/git-completion.bash"

# ======== ???
# TODO: Add more completion for commands...

# ======== compile
# TODO: Cache zcompdump
compinit -d ~/.cache/zcompdump

