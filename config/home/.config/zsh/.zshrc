# ======================================================
# ======== Env                                         =
# ======================================================

source "${ZDOTDIR}/_env.zsh"

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

# ======== basic
# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# ======== git
# Ref:
#     https://github.com/git/git/blob/ed155187b429a2a6b6475efe1767053df37ccfe1/contrib/completion/git-completion.zsh
#     [【初級者向け】ターミナル（zsh）にgitのブランチ名表示＆補完機能を公式ドキュメントをじっくり読み解いて実装 - Qiita]
#         (https://qiita.com/yamaday0u/items/ee8acb35709bcc8c7fc7#tab%E8%A3%9C%E5%AE%8C%E6%A9%9F%E8%83%BD%E3%82%92%E5%AE%9F%E8%A3%85git-completion)
# TODO: This work????
local -r ZSH_COMPLETION_DIR="${ZDOTDIR}/completion"
fpath=($ZSH_COMPLETION_DIR $fpath)
zstyle ':completion:*:*:git:*' script "${ZSH_COMPLETION_DIR}/git-completion.bash"

# ======================================================
# ======== Prompt                                      =
# ======================================================

# Using starship
eval "$(starship init zsh)"

# ======================================================
# ======== Aliase                                      =
# ======================================================

[ -f "${ZDOTDIR}/_aliases.zsh" ] && source "${ZDOTDIR}/_aliases.zsh"

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

