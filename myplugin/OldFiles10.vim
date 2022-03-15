" OldFiles:
" " for syntax edit  ~/.vim/syntax/buf.vim"
"!rm -rf ~/.vim/plugin/OldFiles*
"!cp % ~/.vim/plugin
 
command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/OldFiles*.vim" 
                          \|exe "!cp % ~/.vim/plugin"

command! -buffer -nargs=1 EchoErrormsg 
            \:echohl Errormsg   |echomsg "<args>"|echohl None
command! -buffer -nargs=1 EchoWarningmsg 
            \:echohl Warningmsg |echomsg "<args>"|echohl None
command! -buffer Testrun  :setlocal nomodifiable | messages clear | Runtime

if exists('g:loaded_oldfiles')
    finish
endif
let g:loaded_oldfiles = 1

nnoremap <leader>ls :call <sid>OldFiles('__old__')<cr>

" "configure BufEx"
let s:winheight = 6
let s:Usage = "   Usage: edit split vsplit tab delete quit"
let s:bufname = '__old__'


" "BufEx function"
function! <sid>BufEx(bufname)
    if bufnr(a:bufname) == -1 || bufwinnr(a:bufname) == -1
        call <sid>Openwindow(a:bufname)
        call <sid>Updatewindow()
    elseif winnr() != bufwinnr(a:bufname)
        :EchoWarningmsg current windows is NOT __ls__
        exe bufwinnr(a:bufname) ."wincmd w"
        call <sid>Updatewindow()
    endif
endfunction

function! <sid>OpenwindowPre(bufname)
    " "save previouse winnr"
    if !exists('s:prevwinnr')
        let s:prevwinnr = winnr()
    elseif s:prevwinnr == bufwinnr(a:bufname)
        :EchoWarningmsg previous window is __ls__ window.
    else
        let s:prevwinnr = winnr()
    endif
endfunction

function! <sid>Closewindow(bufname)
    autocmd! * <buffer>
    echomsg 'to previous window' | exe s:prevwinnr ."wincmd w"
    exe bufwinnr(a:bufname) ."wincmd q"
endfunction

function! <sid>BufLeave()
    autocmd! * <buffer>
    exe bufwinnr('__ls__') ."wincmd q"
endfunction

function! <sid>Openwindow(bufname)
    call <sid>OpenwindowPre(a:bufname)
    " "create windows : botright 6 split a:bufname"
    exe "silent botright " .s:winheight ." split " .a:bufname
    " "setlocal options && Mapping"
    call <sid>SetLocalOptions() | call <sid>SetLocalMapping()
    " "autocmd "
    autocmd! * <buffer>
    autocmd BufLeave <buffer>   :echomsg '>>bufleave!' | call <sid>BufLeave()
endfunction

function! <sid>Updatewindow()
    " "save buffer list to _ls_ variable"
    redir! => _ls_ | silent ls | redir END
    setlocal modifiable
    " " clear  buffer"
    :0,$delete
    " "insert Usage at line 0, insert __list__ at line 1"
    :0 put = s:Usage
    :1 put = _ls_
    " "move cursor at line 3"
    :3
    setlocal nomodifiable
    exe "resize" .s:winheight | redraw!
endfunction

function! <sid>Getbufnr()
    :normal ^
    let bufnr = str2nr( expand('<cword>') )
    if bufnr != 0 
        return bufnr
    else
        return -1
    endif
endfunction

function! <sid>Select(cmd)
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        autocmd! * <buffer>
        exe s:prevwinnr ."wincmd w"
        exe bufwinnr('__ls__')."wincmd c"
        exe a:cmd .bufnr
    else
        :EchoWarningmsg invalid buffer number
    endif
endfunction

function! <sid>Deletebuffer(bufname)
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        autocmd! * <buffer>
        exe s:prevwinnr ."wincmd w"
        exe bufwinnr(a:bufname) ."wincmd c"
        exe "bdelete" .bufnr
        call <sid>Openwindow(a:bufname)
        call <sid>Updatewindow() 
    else
        :EchoWarningmsg invalid buffer number
    endif
endfunction

function! <sid>SetLocalOptions()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    setlocal hidden
    setlocal signcolumn=no nonumber colorcolumn=0 textwidth=0
    setlocal nomodifiable
    setlocal filetype=buf
    setlocal cursorline
    "edit "~/.vim/syntax/buf.vim"
endfunction

function! <sid>SetLocalMapping()
    nnoremap <buffer>  <Enter>   :call <sid>Select("buffer ")<cr>
    nnoremap <buffer>  e   :call <sid>Select("buffer ")<cr>
    nnoremap <buffer>  s   :call <sid>Select("sb ")<cr>
    nnoremap <buffer>  v   :call <sid>Select("vert sb ")<cr>
    nnoremap <buffer>  t   :call <sid>Select("tab sb ")<cr>
    nnoremap <buffer>  d   :call <sid>Deletebuffer('__ls__')<cr>
    nnoremap <buffer>  q   :call <sid>Closewindow('__ls__')<cr>
    nnoremap <buffer>  <ESC>   :call <sid>Closewindow('__ls__')<cr>
    nnoremap <buffer>  :   :call <sid>Closewindow('__ls__')<cr>:
endfunction
