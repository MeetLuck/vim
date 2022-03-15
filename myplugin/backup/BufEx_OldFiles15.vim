" " Buffer Explore and OldFiles "
" " for syntax edit  ~/.vim/syntax/buf.vim"
"!rm -rf ~/.vim/plugin/BufEx_OldFiles*
"!cp % ~/.vim/plugin
 
if has('win32') 
    command! -buffer Reinstall :silent! exe "!del " . expand("~/.vim/plugin/") . "BufEx_OldFiles*.vim"
                             \| silent! exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/BufEx_OldFiles*.vim" 
                              \|exe "!cp % ~/.vim/plugin"
endif

if exists('g:loaded_bufex_oldfiles')
    finish
endif
let g:loaded_bufex_oldfiles = 1

nnoremap <leader>ls :call  <sid>Run('__ls__')<cr>
nnoremap <leader>old :call <sid>Run('__old__')<cr>

" "configure BufEx"
let s:winheight = 6

function! <sid>EchoErrorMsg(msg)
    echohl ErrorMsg |echomsg a:msg |echohl None
endfunction

function! <sid>EchoWarningMsg(msg)
    echohl WarningMsg |echomsg a:msg |echohl None
endfunction

function! <sid>IsCurrentWindow(bufname)
        return winnr() == bufwinnr(a:bufname)
endfunction

function! <sid>Run(bufname)
    if bufwinnr(a:bufname) != -1 " "buffer window is OPEN"
        if <sid>IsCurrentWindow(a:bufname)
            call <sid>EchoWarningMsg(a:bufname . ' is open and a CURRENT window')
            return -1
        else
            call <sid>EchoErrorMsg(a:bufname . ' is open BUT NOT a current window')
            "echomsg 'current window is Not ' .a:bufname | exe bufwinnr(bufname) ."wincmd w"
            "call <sid>Updatewindow()
            return -1
        endif
    else                       " "buffer window is NOT open"
        call <sid>Openwindow(a:bufname)
        call <sid>Updatewindow{a:bufname}()
    endif
endfunction

function! <sid>SavePreviousWinNr(bufname)
    " "save previouse winnr"
    if !exists('s:prevwinnr')
        let s:prevwinnr = winnr()
    elseif s:prevwinnr != bufwinnr(a:bufname)
        let s:prevwinnr = winnr()
    else "s:prevwinnr == bufwinnr(a:bufname)
        call <sid>EchoErrorMsg('!!! previous window is '. a:bufname)
    endif
endfunction

function! <sid>Openwindow(bufname)
    call <sid>SavePreviousWinNr(a:bufname)
    "create windows : botright 6 split a:bufname
    exe "silent botright " .s:winheight ." split " .a:bufname
    "setlocal options && Mapping
    call <sid>SetLocalOptions() | call <sid>SetLocalMapping{a:bufname}()
    "call <sid>SetLocalOptions() | call <sid>SetLocalMapping(a:bufname)
    " autocmd for BufLeave
    autocmd! * <buffer>
    autocmd BufLeave <buffer> :call <sid>EchoWarningMsg('...BufLeve') | wincmd q
endfunction

function! <sid>Updatewindow__ls__()
    " "save buffer list to _ls_ variable"
    redir! => _ls_ | silent ls | redir END
    setlocal modifiable
    " " clear  buffer"
    :0,$delete
    " "insert Usage at line 0, insert __list__ at line 1"
    let Usage = "  [BufEx]  edit split vsplit tab delete quit"
    :0 put = Usage
    :1 put = _ls_
    " "move cursor at line 3"
    :3
    setlocal nomodifiable
    setlocal norelativenumber
    exe "resize" .s:winheight | redraw!
endfunction

function! <sid>Updatewindow__old__()
    " "save buffer list to _old_ variable"
    setlocal modifiable
    " " clear  buffer"
    :0,$delete
    " "insert Usage at line 0, insert __list__ at line 1"
    let Usage = "  [OldFiles]  edit split vsplit tab delete quit"
    :0 put = Usage
    :2 put = v:oldfiles
    :3,$s/^/  /g
    :noh
    " "move cursor at line 3"
    :3
    setlocal nomodifiable
    exe "resize" .s:winheight | redraw!
endfunction

function! <sid>Closewindow(bufname)
    call <sid>EchoWarningMsg('...moving to previouse window '.a:bufname)
    autocmd! * <buffer>
    exe s:prevwinnr ."wincmd w" | exe bufwinnr(a:bufname) ."wincmd q"
endfunction

function! <sid>Getbufnr()
    if line(".") == 1 || strlen(getline(".")) == 0
        call <sid>EchoErrorMsg('!!! invalid buffer number '.bufnr)
        return -1
    else
        :normal ^
        return str2nr( expand('<cword>') )
    endif
endfunction

function! <sid>Getfilename()
    if line(".") == 1 || strlen(getline(".")) == 0
        call <sid>EchoErrorMsg('!!! invalid file name '.getline('.'))
        return -1 
    elseif has('win32')
        let filename = getline('.')
        call <sid>EchoErrorMsg(filename)
        return filename
    else
        let filename = expand('<cfile>')
        call <sid>EchoErrorMsg(filename)
        return filename
    endif
endfunction

function! <sid>Select__old__(cmd)
    let filename = <sid>Getfilename()
    if filename != -1
        autocmd! * <buffer>
        exe s:prevwinnr ."wincmd w"
        exe bufwinnr('__old__') ."wincmd c" 
        exe a:cmd .filename
    endif
endfunction

function! <sid>Select__ls__(cmd)
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        autocmd! * <buffer>
        exe s:prevwinnr ."wincmd w"
        exe bufwinnr('__ls__')."wincmd c"
        exe a:cmd .bufnr
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
        call <sid>Updatewindow{a:bufname}() 
    endif
endfunction

function! <sid>SetLocalOptions()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable
    setlocal nonumber signcolumn=no colorcolumn=0 textwidth=0 
    setlocal cursorline
endfunction

function! <sid>SetLocalMapping(bufname)
    setlocal filetype=BufEx
    "edit "~/.vim/syntax/BufEx.vim"
    nnoremap <buffer> <C-W> <nop>
    nnoremap <buffer>  :    <nop>
    nnoremap <buffer>  <CR> :call <sid>Select("buffer ")<cr>
    nnoremap <buffer>  e    :call <sid>Select__ls__("buffer ")<cr>
    nnoremap <buffer>  s    :call <sid>Select__ls__("sb ")<cr>
    nnoremap <buffer>  v    :call <sid>Select__ls__("vert sb ")<cr>
    nnoremap <buffer>  t    :call <sid>Select__ls__("tab sb ")<cr>
    exe 'nnoremap <buffer>  d       :call <sid>Deletebuffer("'.a:bufname .'")<cr>'
    exe 'nnoremap <buffer>  q       :call <sid>Closewindow("' .a:bufname .'")<cr>'
    exe 'nnoremap <buffer>  <ESC>   :call <sid>Closewindow("' .a:bufname .'")<cr>'
    exe 'nnoremap <buffer>  :       :call <sid>Closewindow("' .a:bufname .'")<cr>:'
endfunction

function! <sid>SetLocalMapping__ls__()
    setlocal filetype=BufEx
    "edit "~/.vim/syntax/BufEx.vim"
    nnoremap <buffer> <C-W> <nop>
    nnoremap <buffer>  <CR>   :call <sid>Select("buffer ")<cr>
    nnoremap <buffer>  e   :call <sid>Select__ls__("buffer ")<cr>
    nnoremap <buffer>  s   :call <sid>Select__ls__("sb ")<cr>
    nnoremap <buffer>  v   :call <sid>Select__ls__("vert sb ")<cr>
    nnoremap <buffer>  t   :call <sid>Select__ls__("tab sb ")<cr>
    nnoremap <buffer>  d   :call <sid>Deletebuffer('__ls__')<cr>
    nnoremap <buffer>  <ESC>   :call <sid>Closewindow('__ls__')<cr>
    nnoremap <buffer>  q   :call <sid>Closewindow('__ls__')<cr>
    nnoremap <buffer>  :   :call <sid>Closewindow('__ls__')<cr>:
endfunction

function! <sid>SetLocalMapping__old__()
    setlocal filetype=OldFiles
    "edit "~/.vim/syntax/OldFiles.vim"
    nnoremap <buffer> <C-W> <nop>
    nnoremap <buffer>  <CR>   :call <sid>Select__old__("edit ")<cr>
    nnoremap <buffer>  e   :call <sid>Select__old__("edit ")<cr>
    nnoremap <buffer>  s   :call <sid>Select__old__("split ")<cr>
    nnoremap <buffer>  v   :call <sid>Select__old__("vert split ")<cr>
    nnoremap <buffer>  t   :call <sid>Select__old__("tabe ")<cr>
    nnoremap <buffer>  q   :call <sid>Closewindow('__old__')<cr>
    nnoremap <buffer>  <ESC>   :call <sid>Closewindow('__old__')<cr>
    nnoremap <buffer>  :   :call <sid>Closewindow('__old__')<cr>:
endfunction
