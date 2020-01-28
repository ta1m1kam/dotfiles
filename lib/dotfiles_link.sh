#!/bin/bash -e

function links() {
  DOT_DIRECTORY=~/dotfiles

  pwd
  ls -al
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
