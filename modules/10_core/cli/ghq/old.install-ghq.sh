#!/bin/bash
set -eu

# Whatisthis:
#  Install ghq if it does not installed.


main() {

  local -r APPNAME="ghq"
  local -r CMDNAME="ghq"

  local -r VERSION="v1.6.2"
  local -r FNAME="ghq_linux_amd64"
  local -r FNAMEZIP="${FNAME}.zip"
  local -r EXECFILE="${FNAME}/ghq"
  local -r URL="https://github.com/x-motemen/ghq/releases/download/${VERSION}/${FNAMEZIP}"

  local -r DEST="${HOME}/bin"

  echo "========== Checking if $APPNAME is installed..."
  if command -v "$CMDNAME" &>/dev/null; then
    echo "========== $APPNAME is already installed!!"
  else
    echo "========== $APPNAME does not installed. Installing..."
  
    cd "$(mktemp -d)"
    curl -OL "$URL"
    ls -alFh
    unzip "$FNAMEZIP"
    mkdir -pv "$DEST"
    mv -fv "$EXECFILE" "$DEST"
  
    echo "========== $APPNAME was installed successflly!!"
  fi
}

main
