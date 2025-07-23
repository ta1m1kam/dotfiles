" ウィンドウ移動の設定
" Ctrl + h/j/k/l でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ウィンドウサイズ調整
" Ctrl + 矢印キーでウィンドウサイズを調整
nnoremap <C-Left> :vertical resize -5<CR>
nnoremap <C-Right> :vertical resize +5<CR>
nnoremap <C-Up> :resize -5<CR>
nnoremap <C-Down> :resize +5<CR>

" ウィンドウ分割のショートカット
" ss で水平分割、sv で垂直分割
nnoremap ss :split<CR>
nnoremap sv :vsplit<CR>

" ウィンドウを閉じる
" sq でウィンドウを閉じる
nnoremap sq :q<CR>

" ウィンドウの位置を入れ替える
" Ctrl + r でウィンドウを回転
nnoremap <C-r> <C-w>r