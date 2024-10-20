#!/usr/bin/env bash
set -eu

# What is this?
#     util CLI for myenv
#
# Usage:
#     subcommands:
#         apply <hostname>: Run myenv setup as <hostname>
#         sync: TODO: git pull & git push ?
#         test: TODO: run staticcheck (lint, format, unit-test, integ-test)
#
# Example:
#     $ myenv apply "udon"
#     $ myenv pull
#     $ myenv push
readonly MYENV_ROOT="${HOME}/.myenv"

main() {
  local subcommand="$1"
  shift

  case "$subcommand" in
  apply)
    sub_command_apply "$@"
    ;;
  pull)
    sub_command_pull
    ;;
  push)
    sub_command_push
    ;;
  test)
    sub_command_test
    ;;
  *)
    echo "Unknown subcommand: $subcommand"
    echo "Usage: $0 {sub_command_1|sub_command_2|sub_command_3} [arguments]"
    exit 1
    ;;
  esac
}

sub_command_apply() {
  # TODO: Validate arguments?
  # echo "executing sub_command_apply with argument: $arg"
  "${MYENV_ROOT}/setup.bash" "$@"
}

sub_command_pull() {
  cd "$MYENV_ROOT"
  git pull
}

sub_command_push() {
  cd "$MYENV_ROOT"
  git push
}

sub_command_test() {
  # TODO: Validate arguments?
  echo "Executing sub_command_test"
  echo "TODO: Implement..."
}

main "$@"
