" " Buffer Explore 1.0"
" " for syntax edit  ~/.vim/syntax/buf.vim"
"!rm -rf ~/.vim/plugin/BufEx*
"!cp % ~/.vim/plugin
 
command! -buffer Reinstall 
            \:exe "!rm -rf ~/.vim/plugin/BufEx*.vim" 
            \|exe "!cp % ~/.vim/plugin"
command! -buffer -nargs=1 EchoErrormsg 
            \:echohl Errormsg   |echomsg "<args>"|echohl None
command! -buffer -nargs=1 EchoWarningmsg 
            \:echohl Warningmsg |echomsg "<args>"|echohl None

if !exists('g:loaded_bufex')
    try
        silent exe "normal! '2 "
        silent exe "normal! '1 "
        silent exe "normal! '0 "
    finally
        let g:loaded_bufex = 1
    endtry
else
    finish
endif

nnoremap <leader>ls :call <sid>BufEx()<cr>

" "configure BufEx"
let s:winheight = 6
let s:fname = '__buffer__'

" "BufEx function"
function! <sid>BufEx()
    if bufnr(s:fname) == -1 || bufwinnr(s:fname) == -1
        call <sid>Openwindow()
        call <sid>Updatewindow()
    elseif winnr() != bufwinnr(s:fname)
        :EchoErrormsg au WinLeave Not Working 
    endif
endfunction

function! <sid>Setlocal__buffer__()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    setlocal hidden
    setlocal signcolumn=no nonumber colorcolumn=0 textwidth=0
    setlocal nomodifiable
    setlocal filetype=buf
    setlocal cursorline
    "edit "~/.vim/syntax/buf.vim"
endfunction

function! <sid>Map__buffer__()
    nnoremap <buffer>  <Enter>   :call <sid>Select("buffer ")<cr>
    nnoremap <buffer>  e   :call <sid>Select("buffer ")<cr>
    nnoremap <buffer>  s   :call <sid>Select("sb ")<cr>
    nnoremap <buffer>  v   :call <sid>Select("vert sb ")<cr>
    nnoremap <buffer>  t   :call <sid>Select("tab sb ")<cr>
    nnoremap <buffer>  d   :call <sid>Deletebuffer()<cr>
    nnoremap <buffer>  q   :call <sid>Quitbuffer()<cr>
    nnoremap <buffer>  <ESC>   :call <sid>Quitbuffer()<cr>
    nnoremap <buffer>  :   :call <sid>Quitbuffer()<cr>:
endfunction

function! <sid>Openwindow()
    " "save previouse winnr"
    let s:prevwinnr = winnr()
    " "create windows : botright 6 split __buffer__"
    exe "silent botright " .s:winheight ." split __buffer__"
    if s:prevwinnr == winnr()
        echohl Warningmsg
        echomsg "previous,current :" .s:prevwinnr ."," .winnr()
        echohl None
        let s:prevwinnr -= 1
    endif
    " "setlocal options"
    call <sid>Setlocal__buffer__()
    call <sid>Map__buffer__()
    " "autocmd when leave __buffer__ window"
    autocmd! * <buffer>
    autocmd WinLeave <buffer>  :exe bufwinnr('__buffer__') ."wincmd c"
    exe "resize" .s:winheight | redraw!
endfunction


function! <sid>Updatewindow()
    " "save buffer list to __ls__"
    redir! => __ls__
        silent ls
    redir END
    setlocal modifiable
    let Usage = "   Usage: edit split vsplit tab delete quit"
    " " clear  __buffer__"
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
