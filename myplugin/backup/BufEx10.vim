" " Buffer Explore 1.0"

nnoremap <leader>ls <sid>BufEx()

" "configure BufEx"
let s:winheight = 6
let s:fname = '__buffer__'

" "BufEx function"
function! <sid>BufEx()
    if bufnr(s:fname) == -1
        call <sid>Openwindow()
    endif
    if bufwinnr(s:fname) == -1
        call <sid>Openwindow()
    endif
    call <sid>Updatewindow()
endfunction

function! <sid>Setlocal__buffer__()
    setlocal buftype=nofie bufhidden=wipe nobuflisted noswapfile
    setlocal hidden
    setlocal signcolumn=no nonumber colorcolumn=0 textwidth=0
    setlocal cursorline
    setlocal nomodifiable
    setlocal filetype=buf
    "edit "~/.vim/plugin/syntax/buf.vim"
endfunction

function! <sid>Map__buffer__()
    nnoremap    <Enter>   :call <sid>Openbuffer()<cr>
    nnoremap    e   :call <sid>Openbuffer()<cr>
    nnoremap    s   :call <sid>Splitbuffer()<cr>
    nnoremap    v   :call <sid>Vsplitbuffer()<cr>
    nnoremap    t   :call <sid>Tabbuffer()<cr>
    nnoremap    d   :call <sid>Deletebuffer()<cr>
    nnoremap    q   :call <sid>Quitbuffer()<cr>
    nnoremap    :   :call <sid>Quitbuffer()<cr>:
endfunction

function! <sid>Openwindow()
    " "save previouse winnr"
    let s:prevwinnr = winnr()
    " "create windows : botright 6 split __buffer__"
    exe 'botright ' .s:winheight .' split ' .s:fname
    " "setlocal options"
    call <sid>Setlocal__buffer__()
    call <sid>Map__buffer__()
    " "autocmd when leave __buffer__ window"
    autocmd! * <buffer>
    autocmd WinLeave <buffer> :call <sid>Quitbuffer()
endfunction

function! <sid>Updatewindow()
    " "save buffer list to __ls__"
    redir! => __ls__
        silent ls
    redir END
    setlocal modifiable
    let Usage = "Usage: edit split vsplit tab delete quit"
    " " clear  __buffer__"
    :0,$delete
    " "insert Usage at line 0, insert __list__ at line 1"
    :0 put = usage
    :1 put = __ls__
    " "move cursor at line 3"
    :3
    setlocal nomodifiable
endfunction

function! <sid>Quitbuffer()
    exe s:prevwinnr ."wincmd w"
endfunction

