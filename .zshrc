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
alias mkdir='mkdir -p'
alias mduch='sh $HOME/dotfiles/lib/touch_mkdir.sh'

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

## tmux
alias t='tmux'

