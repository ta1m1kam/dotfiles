#!/bin/bash

source ./lib/brew.sh
source ./lib/dotfiles_link.sh

function install() {
  has() {
    type "$1" > /dev/null 2>&1
  }
  install_brew
}

function deploy() {
  links zsh
  links git
  links vim
  links tmux
  links others
  copy .vim
  copy .tmux
}

if [ "$1" == "install" ]; then
  install
elif [ "$1" == "deploy" ]; then
  deploy
fi
