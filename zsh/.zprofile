# brew 
eval "$(/opt/homebrew/bin/brew shellenv)"


# goenv
# goenvを利用する時
# export PATH="$HOME/.goenv/bin:$PATH"
# eval "$(goenv init -)"
# export GOPATH="$HOME/workspace/go"
# export PATH="$GOPATH/bin:$PATH"
# export GO111MODULE=on

# brew go
# export GOROOT=$HOME/go
# export PATH=$PATH:$GOROOT/bin

#peco(golang)
bindkey '^]' peco-src

# psql
export PGDATA=/usr/local/var/postgres

#yarn
export PATH="$HOME/.yarn/bin:$PATH"

## direnv
export EDITOR=vim
eval "$(direnv hook zsh)"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

