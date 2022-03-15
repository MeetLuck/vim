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
    if !filereadable(s:fname)
        " "create .vimshortcut and save it"
        exe 'badd' .s:fname
        exe 'sb ' .bufname(s:fname)
        :0 put = s:Usage
        :2 d
        :wq
    else
        exe 'badd' .s:fname
    endif
    " "add current file name to .vimshortcut"
    redir! >> $HOME/.vimshortcut
        echo "    " .expand('%:p')
    redir END
endfunction

function! <sid>SetlocalVimShortcut()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    setlocal hidden
    setlocal signcolumn=no nonumber colorcolumn=0 textwidth=0
    setlocal cursorline
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
    if s:prevwinnr == winnr()
        echohl Warningmsg
        echomsg "previous,current :" .s:prevwinnr ."," .winnr()
        let s:prevwinnr -= 1
    endif
    " "save __shortcut__ winnr"
    "let s:shortcutwinnr = winnr()
    " "setlocal options"
    call <sid>SetlocalVimShortcut()
    call <sid>MapVimShortcut()
    " "autocmd when leave __buffer__ window"
    autocmd! * <buffer>
    autocmd WinLeave <buffer> exe bufwinnr('__shortcut__') ."wincmd c"
    setlocal modifiable
    :0,$delete
    exe "0r " .s:fname
    :$
    exe "resize" .s:winheight | redraw!
    setlocal nomodifiable
endfunction


function! <sid>Quitbuffer()
    exe s:prevwinnr ."wincmd w"
"   exe bufwinnr(s:fname) ."wincmd c"
    redraw!
endfunction

function! <sid>Getfilename()
    if line(".") == 1
        return 1
    endif
    echomsg getline(".")
    echomsg strlen(getline("."))
    if strlen(getline(".")) == 0
        return 0
    endif
    :normal ^
"   echohl Question
"   echomsg expand('<cfile>')
    return expand('<cfile>')

endfunction

function! <sid>Execute(cmd)
    let filename = <sid>Getfilename()
    if filename == 1 || filename == 0
        echohl Warningmsg| echomsg "Invalid filename or line"
    else
        exe s:prevwinnr ."wincmd w"
        exe a:cmd .filename
    endif
endfunction

function! <sid>Openfile()
    let filename = <sid>Getfilename()
    if filename == 1 || filename == 0
        echohl Warningmsg| echomsg "Invalid filename or line"
    else
        exe s:prevwinnr ."wincmd w"
        exe "e " .filename
    endif
endfunction

function! <sid>Splitfile()
    call <sid>Execute('split ')
endfunction

function! <sid>Vsplitfile()
endfunction

function! <sid>Tabfile()
endfunction

function! <sid>Deletefile()
    let filename = <sid>Getfilename()
    let cline = getline(.)
    exe s:prevwinnr ."wincmd w"
    "exe "bdelete" .filename
    call <sid>OpenShortcut()
endfunction
