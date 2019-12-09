#rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then
    eval "$(rbenv init -)"
fi

#goenv
# goenvを利用する時
# export PATH="$HOME/.goenv/bin:$PATH"
# eval "$(goenv init -)"
export GOPATH="$HOME/workspace/go"
export PATH="$GOPATH/bin:$PATH"
export GO111MODULE=on

# brew go
# export GOROOT=$HOME/go
# export PATH=$PATH:$GOROOT/bin

#peco(golang)
bindkey '^]' peco-src

# psql
export PGDATA=/usr/local/var/postgres

#yarn
export PATH="$HOME/.yarn/bin:$PATH"

# openssl for crystal
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig


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

## anyenv
#export PATH="$HOME/.anyenv/bin:$PATH"
#eval "$(anyenv init -)"

## ndenv
#export PATH="$HOME/.ndenv/bin:$PATH"
#eval "$(ndenv init -)"

## nodenv
eval "$(nodenv init -)"
export PATH=$HOME/.nodebrew/current/bin:$PATH

## dart stagehand
export PATH="$PATH":"$HOME/.pub-cache/bin"

## flutter
export PATH="$PATH:$HOME/flutter/flutter/bin"

## flutter_web
export PATH="$PATH":"$HOME/flutter/flutter/.pub-cache/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/google-cloud-sdk/completion.zsh.inc'; fi

