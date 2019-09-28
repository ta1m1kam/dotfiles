source ~/.zplug/init.zsh

plugins=(git)
# zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# theme (https://github.com/sindresorhus/pure#zplug)　好みのスキーマをいれてくだされ。
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# history関係
zplug "zsh-users/zsh-history-substring-search"
# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
# Then, source plugins and add commands to $PATH
zplug load

export LC_CTYPE=UTF-8

# コマンドの引数やパス名を途中まで入力して <Tab> を押すといい感じに補完してくれる
# 例： `cd path/to/<Tab>`, `ls -<Tab>`
autoload -U compinit; compinit
# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# 例： /usr/bin と入力すると /usr/bin ディレクトリに移動
setopt auto_cd

## cd XXX
alias d='cd ~/Desktop'
alias dotfiles='cd ~/dotfiles'
alias K='cd ~/workspace/Karappo'
alias W='cd ~/workspace'
alias R='cd ~/research'

## open XXX
alias od='open ~/Desktop'

## 便利系alias
alias cl='clear'

## docker alias
alias dc='docker-compose'

#rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then
    eval "$(rbenv init -)"
fi

#goenv
# goenvを利用する時
export PATH="$HOME/.goenv/bin:$PATH"
eval "$(goenv init -)"
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

function peco-src() {
  local src=$(ghq list --full-path | peco --query "$LBUFFER")
  if [ -n "$src" ]; then
    BUFFER="cd $src"
    zle accept-line
  fi
  zle -R -c
}
zle -N peco-src


#yarn
export PATH="$HOME/.yarn/bin:$PATH"

# openssl for crystal
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/google-cloud-sdk/completion.zsh.inc'; fi


# peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# ヒストリ(履歴)を保存、数を増やす
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

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
export PATH="$HOME/.ndenv/bin:$PATH"
eval "$(ndenv init -)"

## nodenv
eval "$(nodenv init -)"

## flutter
export PATH="$PATH:$HOME/flutter/flutter/bin"

