" " Buffer Explore 1.0"
" " for syntax edit  ~/.vim/syntax/buf.vim"
"!rm -rf ~/.vim/plugin/BufEx*
"!cp % ~/.vim/plugin
 
command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/BufEx*.vim" 
                          \|exe "!cp % ~/.vim/plugin"
command! -buffer -nargs=1 EchoErrormsg 
            \:echohl Errormsg   |echomsg "<args>"|echohl None
command! -buffer -nargs=1 EchoWarningmsg 
            \:echohl Warningmsg |echomsg "<args>"|echohl None
command! -buffer Testrun  :setlocal nomodifiable | messages clear | Runtime

"if exists('g:loaded_bufex')
"    finish
"endif
"
"let g:loaded_bufex = 1

nnoremap <leader>ls :call <sid>BufEx()<cr>

" "configure BufEx"
let s:winheight = 6
let s:fname = '__ls__'

" "BufEx function"
function! <sid>BufEx()
    if bufnr(s:fname) == -1 || bufwinnr(s:fname) == -1
        call <sid>Openwindow()
        call <sid>Updatewindow()
    elseif winnr() != bufwinnr(s:fname)
        :EchoErrormsg au WinLeave Not Working 
    endif
endfunction

function! <sid>Setlocal__ls__()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    setlocal hidden
    setlocal signcolumn=no nonumber colorcolumn=0 textwidth=0
    setlocal nomodifiable
    setlocal filetype=buf
    setlocal cursorline
    "edit "~/.vim/syntax/buf.vim"
endfunction

function! <sid>Map__ls__()
    nnoremap <buffer>  <Enter>   :call <sid>Select("buffer ")<cr>
    nnoremap <buffer>  e   :call <sid>Select("buffer ")<cr>
    nnoremap <buffer>  s   :call <sid>Select("sb ")<cr>
    nnoremap <buffer>  v   :call <sid>Select("vert sb ")<cr>
    nnoremap <buffer>  t   :call <sid>Select("tab sb ")<cr>
    nnoremap <buffer>  d   :call <sid>Deletebuffer()<cr>
    nnoremap <buffer>  q   :call <sid>Closewindow()<cr>
    nnoremap <buffer>  <ESC>   :call <sid>Closewindow()<cr>
    nnoremap <buffer>  :   :call <sid>Closewindow()<cr>:
endfunction

function! <sid>OpenwindowPre()
    " "save previouse winnr"
    "if exists('g:loaded_bufex')
    if !exists('s:prevwinnr')
        let s:prevwinnr = winnr()
    endif
    if s:prevwinnr != bufwinnr('__ls__')
        let s:prevwinnr = winnr()
    endif
    " "backup &statusline
endfunction

function! <sid>Closewindow()
    " "restore statusline
    echomsg "closewindow"
    echomsg "previous,current :" .s:prevwinnr ."," .winnr()
    " "close window
    if s:prevwinnr != winnr()
        exe bufwinnr('__ls__') ."wincmd c"
    endif
   
endfunction

function! <sid>BufLeavewindow()
    echohl Warningmsg
    echomsg "previous window: " .s:prevwinnr
    echomsg "current window: " .winnr()
    echomsg "__ls__ window: " .bufwinnr('__ls__')
    sleep 100m
"   autocmd! * <buffer>
"   autocmd  * <buffer>
"   sleep 5
    autocmd! * <buffer>
    exe s:prevwinnr ."wincmd w"
"   sleep 500m
    exe bufwinnr('__ls__') ."wincmd c"
"   sleep 500m
"   echohl Question
"   echomsg "after comm"
"   echomsg "previous window: " .s:prevwinnr
"   echomsg "current window: " .winnr()
"   echomsg "__ls__ window: " .bufwinnr('__ls__')
"   sleep 500m
endfunction

function! <sid>Openwindow()
    call <sid>OpenwindowPre()
    " "create windows : botright 6 split __ls__"
    exe "silent botright " .s:winheight ." split __ls__"
"   if s:prevwinnr == winnr()
"       echohl Warningmsg
"       echomsg "previous,current :" .s:prevwinnr ."," .winnr()
"       echohl None
"       let s:prevwinnr -= 1
"   endif
    " "setlocal options"
    call <sid>Setlocal__ls__()
    call <sid>Map__ls__()
    " "autocmd when leave __ls__ window"
    autocmd! * <buffer>
    autocmd BufLeave <buffer>  :call <sid>BufLeavewindow()
"   autocmd WinLeave <buffer>  call <sid>Closewindow()
"   autocmd WinLeave <buffer>  :exe bufwinnr('__ls__') ."wincmd c"
    exe "resize" .s:winheight | redraw!
endfunction


function! <sid>Updatewindow()
    " "save buffer list to __ls__"
    redir! => __ls__
        silent ls
    redir END
    setlocal modifiable
    let Usage = "   Usage: edit split vsplit tab delete quit"
    " " clear  __ls__"
    :0,$delete
    " "insert Usage at line 0, insert __list__ at line 1"
    :0 put = Usage
    :1 put = __ls__
    " "move cursor at line 3"
    :3
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
    endif
endfunction

function! <sid>Select(cmd)
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        exe s:prevwinnr ."wincmd w"
        exe a:cmd .bufnr
    else
        :EchoWarningmsg invalid buffer number
    endif
endfunction

function! <sid>Deletebuffer()
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        exe s:prevwinnr ."wincmd w"
        exe "bdelete" .bufnr
        call <sid>Openwindow()
        call <sid>Updatewindow() 
    else
        :EchoWarningmsg invalid buffer number
    endif
endfunction
