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
        exe 'sb ' .bufname(s:fname)
        :0 put = s:Usage
        :2 d
        :w!
        :quit!
    endif
    " "save current file to shortcut"
    redir! >> $HOME/.vimshortcut
        echo "    " .expand('%:p')
    redir END
"   call <sid>UpdateShortcut()
"   :exe s:prevwinnr ."wincmd w"
endfunction

function! <sid>SetlocalVimShortcut()
    setlocal noswapfile
    setlocal hidden
    setlocal signcolumn=no nonumber colorcolumn=0 textwidth=0
    setlocal cursorline
    "setlocal filetype=shortcut
    setlocal filetype=buf
    "edit "~/.vim/syntax/buf.vim"
endfunction

function! <sid>MapVimShortcut()
    nnoremap <buffer>  <Enter>   :call <sid>Openfile()<cr>
    nnoremap <buffer>  e   :call <sid>Openfile()<cr>
    nnoremap <buffer>  s   :call <sid>Splitfile()<cr>
    nnoremap <buffer>  v   :call <sid>Vsplitfile()<cr>
    nnoremap <buffer>  t   :call <sid>Tabfile()<cr>
    nnoremap <buffer>  d   :call <sid>Deletefile()<cr>
    nnoremap <buffer>  q   :call <sid>Quitbuffer()<cr>
    nnoremap <buffer>  :   :call <sid>Quitbuffer()<cr>:
endfunction

function! <sid>OpenShortcut()
    " "save previouse winnr"
    let s:prevwinnr = winnr()
    " "create windows : botright 6 split .vimshortcut"
    exe "silent botright " .s:winheight ." split __shortcut__"
    " "save __shortcut__ winnr"
    "let s:shortcutwinnr = winnr()
    " "setlocal options"
    call <sid>SetlocalVimShortcut()
    call <sid>MapVimShortcut()
    " "autocmd when leave __buffer__ window"
    autocmd! * <buffer>
    autocmd WinLeave <buffer> :exe bufwinnr('__shortcut__') ."wincmd c"
    setlocal modifiable
    :0,$delete
    exe "0r " .s:fname
    :$
    setlocal nomodifiable
endfunction

function! <sid>UpdateShortcut()
    " "save current file to shortcut"
    redir! >> $HOME/.vimshortcut
        echo "    " .expand('%:p')
    redir END
"   redir! => addedfile
"       echo expand('%:p')
"   redir END
"   " "open ~/.vimshortcut"
"   exe "sb " .bufname(s:fname)
"   let addedfile = "   " .split(addedfile)[0]
"   setlocal modifiable
"   " "insert Usage at line 0, insert __list__ at line 1"
"   :$ put = addedfile
"   " "move cursor at end of file"
"   :$
"   :w! | quit
"   setlocal nomodifiable
"   redraw!
endfunction

function! <sid>Quitbuffer()
    exe s:prevwinnr ."wincmd w"
"   exe bufwinnr(s:fname) ."wincmd c"
    redraw!
endfunction

function! <sid>Getfilename()
    :normal ^
    return expand('<cfile>')
endfunction

function! <sid>Openfile()
    let bufname = <sid>Getfilename()
    exe s:prevwinnr ."wincmd w"
    exe "b " .bufname
endfunction

function! <sid>Splitfile()
    let bufname = <sid>Getfilename()
    exe s:prevwinnr ."wincmd w"
    exe "sb " .bufname
endfunction

function! <sid>Vsplitfile()
    let bufname = <sid>Getfilename()
    exe s:prevwinnr ."wincmd w"
    exe "vert sb " .bufname
endfunction

function! <sid>Tabfile()
    let bufname = <sid>Getfilename()
    exe s:prevwinnr ."wincmd w"
    exe "tab sb " .bufname
endfunction

function! <sid>Deletefile()
    let bufname = <sid>Getfilename()
    exe s:prevwinnr ."wincmd w"
    "exe "bdelete" .bufname
    call <sid>OpenShortcut()
endfunction
