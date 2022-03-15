" " Buffer Explore and OldFiles "
" " for syntax edit  ~/.vim/syntax/buf.vim"
"!rm -rf ~/.vim/plugin/BufEx_OldFiles*
"!cp % ~/.vim/plugin
 
command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/BufEx_OldFiles*.vim" 
                          \|exe "!cp % ~/.vim/plugin"

command! -buffer -nargs=1 EchoErrormsg 
            \:echohl Errormsg   |echomsg "<args>"|echohl None
command! -buffer -nargs=1 EchoWarningmsg 
            \:echohl Warningmsg |echomsg "<args>"|echohl None
command! -buffer Testrun  :setlocal nomodifiable | messages clear | Runtime

if exists('g:loaded_bufex_oldfiles')
    finish
endif
let g:loaded_bufex_oldfiles = 1

nnoremap <leader>ls :call  <sid>Run('__ls__')<cr>
nnoremap <leader>old :call <sid>Run('__old__')<cr>

" "configure BufEx"
let s:winheight = 6


" "Run function"
function! <sid>Run(bufname)
    if bufnr(a:bufname) == -1 || bufwinnr(a:bufname) == -1
        call <sid>Openwindow(a:bufname)
        call <sid>Updatewindow{a:bufname}()
    elseif winnr() != bufwinnr(a:bufname)
"       :EchoWarningmsg current windows is NOT __ls__
        exe bufwinnr(a:bufname) ."wincmd w"
        call <sid>Updatewindow{a:bufname}()
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

function! <sid>BufLeave__ls__()
    autocmd! * <buffer>
    exe bufwinnr('__ls__') ."wincmd q"
endfunction

function! <sid>BufLeave__old__()
    autocmd! * <buffer>
    exe bufwinnr('__old__') ."wincmd q"
endfunction

function! <sid>Openwindow(bufname)
    call <sid>OpenwindowPre(a:bufname)
    " "create windows : botright 6 split a:bufname"
    exe "silent botright " .s:winheight ." split " .a:bufname
    " "setlocal options && Mapping"
    call <sid>SetLocalOptions() | call <sid>SetLocalMapping{a:bufname}()
    " "autocmd "
    autocmd! * <buffer>
    if a:bufname == '__ls__'
        autocmd BufLeave <buffer>   :echomsg '>>bufleave!' | call <sid>BufLeave__ls__()
    elseif a:bufname == '__old__'
        autocmd BufLeave <buffer>   :echomsg '>>bufleave!' | call <sid>BufLeave__old__()
    endif
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

function! <sid>Getbufnr()
    :normal ^
    let bufnr = str2nr( expand('<cfile>') )
    if bufnr != 0 
        return bufnr
    else
        return -1
    endif
endfunction

function! <sid>Getfilename()
    if line(".") == 1 || strlen(getline(".")) == 0
        return -1 
    else
        :normal ^
        return expand('<cfile>')
    endif
endfunction

function! <sid>Select__old__(cmd)
    " "select cmd : edit,split,vsplit,tabe for mapping"
    let filename = <sid>Getfilename()
    if filename != -1
        autocmd! * <buffer>
        exe s:prevwinnr ."wincmd w"
        exe bufwinnr('__old__') ."wincmd c" 
        exe a:cmd .filename
    else
        echohl Warningmsg| echomsg "Invalid filename or line"|echohl None
    endif
endfunction

function! <sid>Select__ls__(cmd)
    let bufnr = <sid>Getbufnr()
    if bufnr != -1
        autocmd! * <buffer>
        exe s:prevwinnr ."wincmd w"
        exe bufwinnr('__ls__')."wincmd c"
        exe a:cmd .bufnr
    else
        echohl Warningmsg| echomsg "Invalid filename or line"|echohl None
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
    else
        :EchoWarningmsg invalid buffer number
    endif
endfunction

function! <sid>SetLocalOptions()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable
    setlocal nonumber signcolumn=no colorcolumn=0 textwidth=0 
    setlocal cursorline
endfunction

function! <sid>SetLocalMapping__ls__()
    setlocal filetype=BufEx
    "edit "~/.vim/syntax/BufEx.vim"
    nnoremap <buffer>  <Enter>   :call <sid>Select("buffer ")<cr>
    nnoremap <buffer>  e   :call <sid>Select__ls__("buffer ")<cr>
    nnoremap <buffer>  s   :call <sid>Select__ls__("sb ")<cr>
    nnoremap <buffer>  v   :call <sid>Select__ls__("vert sb ")<cr>
    nnoremap <buffer>  t   :call <sid>Select__ls__("tab sb ")<cr>
    nnoremap <buffer>  d   :call <sid>Deletebuffer('__ls__')<cr>
    nnoremap <buffer>  q   :call <sid>Closewindow('__ls__')<cr>
    nnoremap <buffer>  <ESC>   :call <sid>Closewindow('__ls__')<cr>
    nnoremap <buffer>  :   :call <sid>Closewindow('__ls__')<cr>:
endfunction

function! <sid>SetLocalMapping__old__()
    setlocal filetype=OldFiles
    "edit "~/.vim/syntax/OldFiles.vim"
    nnoremap <buffer>  <Enter>   :call <sid>Select__old__("edit ")<cr>
    nnoremap <buffer>  e   :call <sid>Select__old__("edit ")<cr>
    nnoremap <buffer>  s   :call <sid>Select__old__("split ")<cr>
    nnoremap <buffer>  v   :call <sid>Select__old__("vert split ")<cr>
    nnoremap <buffer>  t   :call <sid>Select__old__("tabe ")<cr>
    nnoremap <buffer>  q   :call <sid>Closewindow('__old__')<cr>
    nnoremap <buffer>  <ESC>   :call <sid>Closewindow('__old__')<cr>
    nnoremap <buffer>  :   :call <sid>Closewindow('__old__')<cr>:
endfunction
