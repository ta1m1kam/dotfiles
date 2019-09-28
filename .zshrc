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

export LC_CTYPE=UTF-8

# コマンドの引数やパス名を途中まで入力して <Tab> を押すといい感じに補完してくれる
# 例： `cd path/to/<Tab>`, `ls -<Tab>`
autoload -U compinit; compinit

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# 例： /usr/bin と入力すると /usr/bin ディレクトリに移動
setopt auto_cd

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



##### aliases
## cd XXX
alias d='cd ~/Desktop'
alias dotfiles='cd ~/dotfiles'
alias K='cd ~/workspace/Karappo'
alias W='cd ~/workspace'
alias R='cd ~/research'

## open XXX
alias od='open ~/Desktop'

## 便利系alias
alias c='clear'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ..='cd ..'
alias ls='ls -G'
alias la='ls -a'
alias ll='ls -l'
alias tree='tree -C'
alias vi='vim'
alias f='open .'

## git系
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'

## docker alias
alias dc='docker-compose'

## 再読み込み
alias zshrc='source ~/.zshrc'

## Global alias
alias -g G='| grep'
