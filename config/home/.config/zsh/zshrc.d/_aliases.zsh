# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    # alias fgrep='fgrep --color=auto'
    # alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
# alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time"
alias ls="eza --color=always --icons=always"
alias ll="eza --color=always --icons=always --long"
alias la="eza --color=always --icons=always --long --all"
alias lt="eza --color=always --icons=always --tree --level=3 --all --ignore-glob='node_modules|.git|.cache'"

# Create new session
alias t="tmux"
# Create new session with specific name
alias ts="tmux new-session -s"

alias lg="lazygit"
alias g="git"

alias v="nvim"

# ======================================================
# ======== myenv command                               =
# ======================================================

# What is this?
#     util CLI for myenv
#
# Usage:
#     subcommands:
#         cd:   Move to the myenv directory
#         apply <hostname>: Run myenv setup as <hostname>
#         pull: git pull
#         push: git push
#         TODO: sync: git pull && git push
#         test: Run staticcheck (lint, format, unit-test, integ-test)
#         bump: Commit and push lazy-lock.json changes
#
# Example:
#     $ myenv cd
#     $ myenv apply "udon"
#     $ myenv pull
#     $ myenv push
#
alias myenv="myenv_function $@"

myenv_function() {
  local -r MYENV_ROOT="${HOME}/.myenv"
  local -r subcommand="$1"
  shift # discards the first param ($1) and shifts all other params

  case "$subcommand" in
  cd)
    _sub_command_cd
    ;;
  apply)
    _sub_command_apply "$@"
    ;;
  pull)
    _sub_command_pull
    ;;
  push)
    _sub_command_push
    ;;
  test)
    _sub_command_test
    ;;
  bump)
    _sub_command_bump
    ;;
  *)
    echo "Unknown subcommand: $subcommand"
    echo "Usage: $0 {cd|apply [arguments]|pull|push|test}"
    ;;
  esac
}

_sub_command_cd() {
  cd "$MYENV_ROOT"
}

_sub_command_apply() {
  # TODO: Validate arguments?
  # echo "executing _sub_command_apply with argument: $arg"
  "${MYENV_ROOT}/setup.bash" "$@"
}

_sub_command_pull() {
  cd "$MYENV_ROOT" && git pull
}

_sub_command_push() {
  cd "$MYENV_ROOT" && git push
}

_sub_command_test() {
  # TODO: Validate arguments?
  cd "$MYENV_ROOT" && \
    ./devel-tools/script/run-lint.arch_based_x64.bash
}

_sub_command_bump() {
  bump_nvim_plugins
}

_bump_nvim_plugins() {
  local -r LOCKFILE="${MYENV_ROOT}/config/home/.config/nvim/lazy-lock.json"
  local -r COMMIT_MSG="chore(nvim): bump plugin"

  cd "$MYENV_ROOT"

  # Do nothing if lazy-lock.json has no changes
  if git diff --quiet "$LOCKFILE"; then
    echo "No changes in lazy-lock.json. Nothing to do."
    return 0
  fi

  git add "$LOCKFILE"
  git commit -m "$COMMIT_MSG"
  git push
}
