" Custom Mapping File: ...... 
let mapleader = ','
nnoremap <Leader>ev :e $MYVIMRC
nnoremap <Leader>sv :source $MYVIMRC
"nnoremap <Leader>sv :w! $MYVIMRC <bar> source $MYVIMRC
nnoremap <Leader>txt :set filetype=txt<CR>
nnoremap <Leader>help :set filetype=help<CR>
nnoremap <Leader>tips :set filetype=tips<CR>
nnoremap <Leader>w <C-w>
nnoremap <leader>tab :tabnew<CR>
nnoremap <Leader>sa :w<CR>
nnoremap <Leader>x :qa!<CR>
nnoremap <Leader><Esc> :set nohls!<CR>
nnoremap <Leader>term  :bot<SPACE>term<CR>
"cnoremap term bot<SPACE>term<CR> WARNING some delay because of t e r m

"InsertMode: i_Ctrl-l
inoremap <C-l> <Right>

"Colone: use <Space>
nnoremap <Space> :
vnoremap <Space> :

" WindowsResize:
nnoremap <Leader>+ <C-w>+
nnoremap <Leader>- <C-w>-
nnoremap Y y$

" YankandExecute:
nnoremap <Leader>Y y$:@0

" VisualFind: *,#
vnoremap * y/<C-R>"<CR>
"vnoremap # y?<C-R>"<CR>
 
" FormatParagraph: gqap
"nnoremap <Leader>fp gqap 

" Search: url open, duckduckgo, daum dictionary
if has('win32')
    vnoremap <Leader>ff   "qy:silent! exe "!(start firefox " .mylib#trim(@q) .")"<cr>
    vnoremap <Leader>duck "qy:silent! exe "!(start firefox www.duckduckgo.com?q=" .mylib#trim(@q).")"<cr>
    vnoremap <Leader>daum "qy:silent! exe "!(start firefox dic.daum.net/search.do?q=" .mylib#trim(@q).")"<cr>
    " "----------run python with seperate process----------""
    "using pipe after writing stdio by :w"
    "nnoremap <silent> <F5> :w !py<CR>
    " "-------------- start /b  run  app in background like & in linux ---------------""
    "nnoremap <silent> <F4> :w <bar> !start /b cmd /c py %:p<CR><CR>
    nnoremap <silent> <F4> :w <bar> !start cmd /k py %:p<CR><CR>
    nnoremap <silent> <F5> :w <bar> !start /b py %:p & pause<CR><CR>
    "nnoremap <silent> <F6> :w <bar> cd <bar> !py %:p > expand("%:p:h")/out <CR>

endif

" Vimhelp: <F1>
nnoremap <silent> <F1> :exe 'help ' .expand('<cword>')<cr>
vnoremap <silent> <F1> "qy:exe 'help ' .mylib#trim(@q)<cr>

" Netrw:
nnoremap <leader>V :Vex

" Surround:
"   to stop visual mode, <ESC> first
"   to keep mark position, add at mark `> FIRST
vnoremap <C-S>"    `>a"`<i"
vnoremap <C-S>'    `>a'`<i'
vnoremap <C-S>`    `>a``<i`
vnoremap <C-S>#    `>a#`<i#
vnoremap <C-S>_    `>a_`<i_
vnoremap <C-S><    `>a>`<i<
vnoremap <C-S>[    `}a>`<i{
vnoremap <C-S>/*   `>a*/`<i/*

" RepeatVisualMode:
vnoremap . :normal .<CR>
" Last Change like gi
nnoremap gc  `.<CR>
