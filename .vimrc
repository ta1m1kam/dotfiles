set encoding=utf-8
scriptencoding utf-8
" matchit {{{
" if や for などの文字にも%で移動できるようになる
source $VIMRUNTIME/macros/matchit.vim
let b:match_ignorecase = 1
" }}}

" カーソルを|にする
if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif

set nowrap  " ターミナルの右端で文字を折り返さない
set noswapfile " tempファイルを作らない。編集中に電源落ちまくるし、とかいう人はコメントアウトで
set hlsearch " ハイライトサーチを有効にする。文字列検索は /word とか * ね
set ignorecase " 大文字小文字を区別しない(検索時)
set smartcase " ただし大文字を含んでいた場合は大文字小文字を区別する(検索時)
set incsearch " インクリメントサーチ 1ッモジ入力ごとに検索を行う
set ruler " カーソル位置が右下に表示される
set number " 行番号を付ける
set wildmenu " コマンドライン補完が強力になる
set showcmd " コマンドを画面の最下部に表示する
set clipboard=unnamed  " クリップボードを共有する(設定しないとvimとのコピペが面倒です)
set autoindent " 改行時にインデントを引き継いで改行する
set shiftwidth=2 " インデントにつかわれる空白の数
set softtabstop=2 " <Tab>押下時の空白数 
set expandtab " <Tab>押下時に<Tab>ではなく、ホワイトスペースを挿入する
set tabstop=2 " <Tab>が対応する空白の数 
set listchars=tab:>-,trail:.  " タブを >--- 半スペを . で表示する
" インクリメント、デクリメントを16進数にする(0x0とかにしなければ10進数です。007をインクリメントすると010になるのはデフォルト設定が8進数のため)
set nf=hex
" マウス使えます
set mouse=a
set whichwrap=b,s,h,l,<,>,[,],~ " カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set cursorline " カーソルラインをハイライト
set showmatch " 括弧の対応関係を一瞬表示する
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する
set history=5000 " 保存するコマンド履歴の数
set backspace=indent,eol,start
" インサートモードの時に C-j でノーマルモードに戻る
imap <C-j> <esc>
" [ って打ったら [] って入力されてしかも括弧の中にいる(以下同様)
imap [ []<left>
imap ( ()<left>
imap { {}<left>

" ２回esc を押したら検索のハイライトをヤメる
nmap <Esc><Esc> :nohlsearch<CR><Esc>
" }}}

" インサートモードで移動
imap <C-h> <left>
imap <C-l> <Right>
imap <C-k> <Up>

"----------------------------------------------------------
"ここからプラグイン vim-plugに乗り換え
call plug#begin('~/.vim/plugged')

"----------------------------------------------------------
" ここに追加したいVimプラグインを記述する・・・・・・②
" ファイルをtree表示してくれる
Plug 'scrooloose/nerdtree'
nnoremap <silent><C-t> :NERDTreeToggle<CR>
" unite.vim
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
" ステータスラインの表示内容強化
Plug 'itchyny/lightline.vim'
" 末尾の全角と半角の空白文字を赤くハイライト
Plug 'bronson/vim-trailing-whitespace'
" インデントの可視化
Plug 'Yggdroot/indentLine'
" TypeScriptプラグイン
Plug 'leafgarland/typescript-vim'

" 多機能セレクタ
Plug 'ctrlpvim/ctrlp.vim'
" CtrlPの拡張プラグイン. 関数検索
Plug 'tacahiroy/ctrlp-funky'
" CtrlPの拡張プラグイン. コマンド履歴検索
Plug 'suy/vim-ctrlp-commandline'
" CtrlPの検索にagを使う
Plug 'rking/ag.vim'
" submode
Plug 'kana/vim-submode'
if has('lua') " lua機能が有効になっている場合・・・・・・①
    " コードの自動補完
    Plug 'Shougo/neocomplete.vim'
    " スニペットの補完機能
    Plug 'Shougo/neosnippet'
    " スニペット集
    Plug 'Shougo/neosnippet-snippets'
endif


"----------------------------------------------------------
call plug#end()

" ファイルタイプ別のVimプラグイン/インデントを有効にする
filetype plugin indent on

""""""""""""""""""""""""""""""
" Unit.vimの設定
""""""""""""""""""""""""""""""
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

"----------------------------------------------------------
" molokaiの設定
"----------------------------------------------------------
colorscheme delek " カラースキームにmolokaiを設定する
set t_Co=256 " iTerm2など既に256色環境なら無くても良い
syntax enable " 構文に色を付ける

"----------------------------------------------------------
" ステータスラインの設定
"----------------------------------------------------------
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示

"----------------------------------------------------------
" neocomplete・neosnippetの設定
"----------------------------------------------------------
" CtrlPの設定
"----------------------------------------------------------
let g:ctrlp_match_window = 'order:ttb,min:20,max:20,results:100' " マッチウインドウの設定. 「下部に表示, 大きさ20行で固定, 検索結果100件」
let g:ctrlp_show_hidden = 1 " .(ドット)から始まるファイルも検索対象にする
let g:ctrlp_types = ['fil'] "ファイル検索のみ使用
let g:ctrlp_extensions = ['funky', 'commandline'] " CtrlPの拡張として「funky」と「commandline」を使用

" CtrlPCommandLineの有効化
command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())

" CtrlPFunkyの有効化
let g:ctrlp_funky_matchtype = 'path'

"----------------------------------------------------------
" ag.vimの設定
"----------------------------------------------------------
if executable('ag') " agが使える環境の場合
  let g:ctrlp_use_caching=0 " CtrlPのキャッシュを使わない
  let g:ctrlp_user_command='ag %s -i --hidden -g ""' " 「ag」の検索設定
endif

nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

" タブで引数ファイルを開く
nnoremap <silent> <leader>te :<c-u>tabedit<cr>

" ターミナルモード
nnoremap tm :belowright :terminal<CR>
tnoremap <C-Q> <C-W>N

noremap <C-a> ^
noremap <C-e> $
noremap <C-k> {
noremap <C-j> }

