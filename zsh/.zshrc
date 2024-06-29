source ~/.zplug/init.zsh

plugins=(git)

###### zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
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

# prompt style
zstyle ':prompt:pure:path' color cyan

export LC_CTYPE=UTF-8

# コマンドの引数やパス名を途中まで入力して <Tab> を押すといい感じに補完してくれる
# 例： `cd path/to/<Tab>`, `ls -<Tab>`
autoload -U compinit; compinit
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


##### setopt
# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# 例： /usr/bin と入力すると /usr/bin ディレクトリに移動
setopt auto_cd
# コマンドのスペルミスを指摘
setopt correct
# 補完候補表示時にビープ音を鳴らさない
setopt nolistbeep
# cd -<tab>で以前移動したディレクトリを表示
setopt auto_pushd
# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups
# 重複するコマンドは古い法を削除する
setopt hist_ignore_all_dups
# 複数のzshを同時に使用した際に履歴ファイルを上書きせず追加する
setopt append_history
# 先頭がスペースで始まる場合は履歴に追加しない
setopt hist_ignore_space
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
# 高機能なワイルドカード展開を使用する
setopt extended_glob
# 8bit対応
setopt print_eight_bit


##### peco
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# ヒストリ(履歴)を保存、数を増やす
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

##### fzf
export PATH="$PATH:$HOME/.fzf/bin"
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 30% --border'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#### aliases
## cd XXX
alias d='cd ~/Desktop'
alias dotfiles='cd ~/dotfiles'
alias W='cd ~/workspace'

## open XXX
alias od='open ~/Desktop'

## 便利系alias
alias c='clear'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ..='cd ..'
alias ls='ls -G'
export LSCOLORS=Cxfxcxdxbxegedabagacad
alias la='ls -a'
alias ll='ls -l'
alias tree='tree -C'
alias vi='vim'
alias f='open .'
alias mkdir='mkdir -p'
alias mduch='sh $HOME/dotfiles/lib/touch_mkdir.sh'

## git系
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='gitmoji -c'

## docker alias
alias dc='docker-compose'

## 再読み込み
alias zshrc='source ~/.zshrc'

## Global alias
alias -g G='| grep'

## tmux
alias t='tmux'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# nvm
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# bun completions
[ -s "/Users/taigamikami/.bun/_bun" ] && source "/Users/taigamikami/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#Change this variable to your environment
export BACK_END_REPO="/Users/taigamikami/workspace/backend/back-end"

alias sso="aws sso login --profile=backend-prod-admin"
alias sts="aws sts get-caller-identity"

alias use-be-prod="export AWS_PROFILE=backend-prod-admin"
alias use-be-stg="export AWS_PROFILE=backend-stg-admin"
alias use-be-dev="export AWS_PROFILE=backend-dev-admin"

alias use-so-dev="export AWS_PROFILE=so-dev"
alias use-so-stg="export AWS_PROFILE=so-stg"
alias use-so-prod="export AWS_PROFILE=so-prod"

alias login-prod="ecspresso exec --config $BACK_END_REPO/monolith/deploy/production/app.yml"
alias login-stg="ecspresso exec --config $BACK_END_REPO/monolith/deploy/staging/app.yml"
alias login-sco-g="ecspresso exec --config $BACK_END_REPO/gateway/deploy/staging/gateway.yml"
alias login-ce="ecspresso exec --config $BACK_END_REPO/monolith/deploy/ce/app.yml"
alias login-opex="ecspresso exec --config $BACK_END_REPO/monolith/deploy/opex/app.yml"
alias login-sco="ecspresso exec --config $BACK_END_REPO/monolith/deploy/sco/app.yml"
alias login-sco-g="ecspresso exec --config $BACK_END_REPO/gateway/deploy/sco/gateway.yml"
alias login-ce-w="ecspresso exec --config $BACK_END_REPO/monolith/deploy/ce/sidekiq.yml"
alias login-demo="ecspresso exec --config $BACK_END_REPO/monolith/deploy/demo/app.yml"
alias login-demo-w="ecspresso exec --config $BACK_END_REPO/monolith/deploy/demo/sidekiq.yml"

# run to apply Env vars updated on AWS console
alias deploy-ce="ecspresso deploy --config $BACK_END_REPO/monolith/deploy/ce/app.yml"
alias deploy-ce-w="ecspresso deploy --config $BACK_END_REPO/monolith/deploy/ce/sidekiq.yml"

# run under infra/backend/
alias cdk-diff="node_modules/.bin/cdk diff shippio-backend-ce-stack"
alias cdk-deploy="node_modules/.bin/cdk deploy shippio-backend-ce-stack"


export DENO_INSTALL="/Users/taigamikami/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

source /Users/taigamikami/.gvm/scripts/gvm

# rbenv
eval "$(rbenv init - zsh)"

[ -f ~/.inshellisense/key-bindings.zsh ] && source ~/.inshellisense/key-bindings.zsh

# oj
export PATH="/Users/taigamikami/.local/bin:$PATH"


# protobuf
GOPRIVATE=github.com/Tech-Design-Inc/protobuf
export GOPRIVATE=github.com/Tech-Design-Inc/protobuf
