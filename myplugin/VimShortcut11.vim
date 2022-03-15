" " VimShortcut 1.0"
" " for syntax edit  ~/.vim/syntax/buf.vim"

nnoremap <leader>as :call <sid>AddShortcut()<cr>
nnoremap <leader>os :call <sid>OpenShortcut()<cr>

" "configure VimShortcut"
"let s:winheight = 6
"let s:fname = expand('$HOME/.vimshortcut')
let s:winheight = 6
let s:fname = expand('$HOME/.vimshortcut')
let s:Usage = "   Usage: edit split vsplit tab delete quit"

function! <sid>AddShortcut()
    if filereadable(s:fname)
        exe 'badd' .s:fname
    else
        " "create one"
        exe 'badd' .s:fname
        exe 'sb ' .bufnr(s:fname)
        :0 put = s:Usage
        :w!
        :quit!
    endif
    call <sid>OpenShortcut()
    call <sid>UpdateShortcut()
    :exe s:prevwinnr ."wincmd w"
endfunction

function! <sid>SetlocalVimShortcut()
    setlocal noswapfile
"   setlocal hidden
    setlocal signcolumn=no nonumber colorcolumn=0 textwidth=0
    setlocal cursorline
"   setlocal nomodifiable
    setlocal filetype=buf
    "edit "~/.vim/syntax/buf.vim"
endfunction

function! <sid>MapVimShortcut()
    nnoremap <buffer>  <Enter>   :call <sid>Openbuffer()<cr>
    nnoremap <buffer>  e   :call <sid>Openbuffer()<cr>
    nnoremap <buffer>  s   :call <sid>Splitbuffer()<cr>
    nnoremap <buffer>  v   :call <sid>Vsplitbuffer()<cr>
    nnoremap <buffer>  t   :call <sid>Tabbuffer()<cr>
    nnoremap <buffer>  d   :call <sid>Deletebuffer()<cr>
    nnoremap <buffer>  q   :call <sid>Quitbuffer()<cr>
"   nnoremap <buffer>  :   :call <sid>Quitbuffer()<cr>:
endfunction

function! <sid>OpenShortcut()
    " "save previouse winnr"
    let s:prevwinnr = winnr()
    " "create windows : botright 6 split .vimshortcut"
    exe "silent botright " .s:winheight ." split " .s:fname
    " "setlocal options"
    call <sid>SetlocalVimShortcut()
    call <sid>MapVimShortcut()
    " "autocmd when leave __buffer__ window"
    autocmd! * <buffer>
    autocmd WinLeave,WinEnter <buffer> :exe bufwinnr(s:fname) ."wincmd c"
endfunction

function! <sid>UpdateShortcut()
    " "save buffer list to __ls__"
    redir! => __shortcut__
        echo expand('%:p')
    redir END
    let @s = __shortcut__
    echom type(__shortcut__)
"   echom type(shortcut)
    let shortcut = "   " .split(__shortcut__)[0]
    echom shortcut[0]
"   let a = 'x y z'
    setlocal modifiable
"   " "insert Usage at line 0, insert __list__ at line 1"
    :$ put = shortcut
"   :$ put = a
"   " "move cursor at end of file"
"   :$
    :w!
    setlocal nomodifiable
    redraw!
endfunction

function! <sid>Quitbuffer()
    exe s:prevwinnr ."wincmd w"
"   exe bufwinnr(s:fname) ."wincmd c"
    redraw!
endfunction

function! <sid>Getbufnr()
    :normal ^
    let bufnr = str2nr( expand('<cword>') )
    if bufnr != 0 
        return bufnr
    else
        return -1
endfunction

function! <sid>Openbuffer()
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        exe s:prevwinnr ."wincmd w"
        exe "b " .bufnr
    else
        echohl Warningmsg | echo "invalid buffer number"
    endif
endfunction

function! <sid>Splitbuffer()
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        exe s:prevwinnr ."wincmd w"
        exe "sb " .bufnr
    else
        echohl Warningmsg | echo "invalid buffer number"
    endif
endfunction

function! <sid>Vsplitbuffer()
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        exe s:prevwinnr ."wincmd w"
        exe "vert sb " .bufnr
    else
        echohl Warningmsg | echo "invalid buffer number"
    endif
endfunction

function! <sid>Tabbuffer()
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        exe s:prevwinnr ."wincmd w"
        exe "tab sb " .bufnr
    else
        echohl Warningmsg | echo "invalid buffer number"
    endif
endfunction

function! <sid>Deletebuffer()
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        exe s:prevwinnr ."wincmd w"
        "exe "bdelete" .bufnr
        call <sid>OpenShortcut()
    else
        echohl Warningmsg | echo "invalid buffer number"
    endif
endfunction
