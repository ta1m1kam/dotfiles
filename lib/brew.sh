#!/bin/bash

run_brew() {
  if has "brew"; then
    echo "$(tput setaf 2)Already installed Homebrew ✔︎$(tput sgr0)"
  else
    echo "Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if has "brew"; then
    echo "Updating Homebrew..."
    brew update && brew upgrade
    # TODO 続きを書く
  fi
}
