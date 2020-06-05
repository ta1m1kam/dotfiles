" => vim-plug plugins ------------------------------------- {{{1
"  vim-plugでプラグインを管理する
call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-vinegar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'simeji/winresizer'
Plug 'NLKNguyen/papercolor-theme'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'tpope/vim-fugitive'
  Plug 'christoomey/vim-tmux-navigator'
endif
let g:deoplete#enable_at_startup = 1
call plug#end()

" vim-plugがまだインストールされてなければインストールする
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" packloadall " 全てのプラグインをロードする
" silent! helptags ALL " 全てのプラグイン用にヘルプファイルをロードする

" => Editing ------------------------------------- {{{1
syntax on " シンタックスハイライトを有効化
filetype plugin indent on " ファイルタイプに基づいたインデントを有効化 set autoindent " 新しい行を始める時に自動でインデント set expandtab " タブをスペースに変換
set tabstop=4 " 自動インデントに使われるスペースの数
set shiftwidth=4 " 自動インデントに使われるスペース数
set backspace=2 " 多くのターミナルでバックスペースの挙動を修正
set laststatus=2 " ステータスラインを常に表示 set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set mouse=a " マウス使える
set background=dark
set ruler " ルーラ（行、列、現在位置を右下に表示）
set cursorline " カーソルラインをハイライト
autocmd ColorScheme * highlight LineNr ctermfg=248

set foldmethod=indent " コード折りたたみ
" 折りたたみを開いた状態がデフォルト
autocmd BufRead * normal zR
nnoremap zR zr
nnoremap zM zm

set wildmenu " Tabによる自動補完
set wildmode=list:longest,full " 最長マッチの自動補完メニューを開く
set tags=tags; " 親ディレクトリにあるtagsファイルを再帰的に探す"
set number " 行番号
set title " 編集中のファイル名を表示
colorscheme PaperColor " カラースキームを変更
set hlsearch " マッチのハイライト
set clipboard=unnamed,unnamedplus " システムのクリップボード（*と+）にコピー

" 全てのファイルについて永続アンドゥを有効にする
set undofile
if !isdirectory(expand("$HOME/.vim/undodir"))
    call mkdir(expand("$HOME/.vim/undodir"), "p")
endif
set undodir=$HOME/.vim/undodir

" => Looks ------------------------------------- {{{1
" Powerlineを読み込む
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

" カーソルの形
if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif

" => Key mapping ------------------------------------- {{{1
" コントロールキーとhjklで分割されたウィンドウを素早く移動する
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>
" :lsに対するマッピング
nnoremap <c-r> :ls<cr>

" 矢印キーが何もしなくなる
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" 対応する閉じ括弧や引用符を入力する
inoremap ' ''<esc>i
inoremap " ""<esc>i
inoremap ( ()<esc>i
inoremap { {}<esc>i
inoremap [ []<esc>i

" インサートモードで移動"
imap <c-h> <left>
imap <c-l> <Right>
imap <c-k> <Up>
imap <c-j> <Down>

" tmでターミナルを開く
nnoremap tm :belowright :terminal<cr>
" ターミナルウィンドウをvimと同じように移動する
tnoremap <c-j> <c-w><c-j>
tnoremap <c-k> <c-w><c-k>
tnoremap <c-l> <c-w><c-l>
tnoremap <c-h> <c-w><c-h>

" :q!に対するマッピング
nnoremap <leader>q :q!<cr>  

noremap <c-a> ^
noremap <c-e> $
inoremap <c-e> <Esc>$a
inoremap <c-a> <Esc>^a

" ヴィジアルモードをインデント調整直後に開放しない
vnoremap > >gv
vnoremap < <gv

noremap ss :<c-u>sp<cr>
noremap sv :<c-u>vs<cr>

" 全ページヤンク
nnoremap Y y$

" ==で全体のインデント整理
nnoremap == gg=G

" => Plugins configuration ------------------------------------- {{{1
" コントロールキーとhjklで分割されたウィンドウを素早く移動する
let NERDTreeShowBookmarks = 1 " 起動時にブックマーク表示
autocmd VimEnter * NERDTree " Vim起動時にNERDTreeを開く
" NERDTreeのウィンドウしか開かれていないときは自動的に閉じる
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" LeaderキーをSpaceキーに変更"
let mapleader = "\<space>"
noremap <leader>n :NERDTreeToggle<cr>

" CtrlPがGitのルートをワーキングディレクトリとして使うようになる"
let g:ctrlp_working_path_mode = 'ra'
" winresizer_start_keyをleader + wにする
let g:winresizer_start_key = '<c-w>'

