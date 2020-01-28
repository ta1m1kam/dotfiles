#!/bin/bash -e

function links() {
  DOT_DIRECTORY="${HOME}/dotfiles/${1}"

  cd $DOT_DIRECTORY
  for f in .??*
  do
      [[ "$f" == ".git" ]] && continue
      [[ "$f" == ".gitignore" ]] && continue
      [[ "$f" == ".DS_Store" ]] && continue
      [[ "$f" == ".idea" ]] && continue
      [[ "$f" == ".github" ]] && continue

      echo "$f"
      ln -sf ${DOT_DIRECTORY}/${f} ${HOME}/${f}
  done
}

function copy() {
  DOT_DIRECTORY="${HOME}/dotfiles/${1}"
  echo $DOT_DIRECTORY
  cp -r $DOT_DIRECTORY ${HOME}/${1}
}
