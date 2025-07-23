# brew 
eval "$(/opt/homebrew/bin/brew shellenv)"

# psql
export PGDATA=/usr/local/var/postgres

#yarn
export PATH="$HOME/.yarn/bin:$PATH"

## direnv
export EDITOR=vim
eval "$(direnv hook zsh)"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

## smctl
export PATH="/usr/local/bin:$PATH"
