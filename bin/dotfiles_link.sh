#!/bin/bash
set -e
DOT_DIRECTORY="${HOME}/dotfiles"

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".gitignore" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    echo "$f"
    ln -sf ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done
