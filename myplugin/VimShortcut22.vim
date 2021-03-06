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
    nnoremap <buffer>  <Enter>   :call <sid>Execute('edit ')<cr>
    nnoremap <buffer>  e   :call <sid>Execute('edit ')<cr>
    nnoremap <buffer>  s   :call <sid>Execute('split ')<cr>
    nnoremap <buffer>  v   :call <sid>Execute('vsplit ')<cr>
    nnoremap <buffer>  t   :call <sid>Execute('tabe ')<cr>
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
    if line(".") == 1 || strlen(getline(".")) == 0
        return -1 
    endif
    :normal ^
    return expand('<cfile>')

endfunction

function! <sid>Execute(cmd)
    let filename = <sid>Getfilename()
    if filename == -1 
        " "When comparing a string with a number, the string is first converted to a number."
        echohl Warningmsg| echomsg "Invalid filename or line"
    else
        exe s:prevwinnr ."wincmd w"
        exe a:cmd .filename
    endif
endfunction


function! <sid>Deletefile()
    let filename = <sid>Getfilename()
    let cline = getline(.)
    exe s:prevwinnr ."wincmd w"
    "exe "bdelete" .filename
    call <sid>OpenShortcut()
endfunction
