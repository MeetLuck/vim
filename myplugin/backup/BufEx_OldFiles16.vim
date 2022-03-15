" " Buffer Explore and OldFiles "
" " for syntax edit  ~/.vim/syntax/buf.vim"
"!rm -rf ~/.vim/plugin/BufEx_OldFiles*
"!cp % ~/.vim/plugin
"~/.vim/autoload/mywindow.vim
 
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


function! <sid>Run(bufname)
    if !mywindow#doesWindowExist(a:bufname)   " "buffer window is NOT CREATED"
        call <sid>Openwindow(a:bufname)
        call <sid>Updatewindow(a:bufname)
    else                       " "buffer window is ALREADY open"
        if mywindow#isCurrentWindow(a:bufname)
            call mywindow#echoWarningMsg(a:bufname .' is open and a CURRENT window')
            return -1
        else
            echoerr a:bufname . ' is open BUT NOT a current window'
            return -1
        endif
    endif
endfunction

function! <sid>Openwindow(bufname)
    call mywindow#savePreviousWinNr(a:bufname) 
    "create windows : botright 6 split a:bufname
    exe "silent botright " .s:winheight ." split " .a:bufname
    call mywindow#setLocalOptions() | call mywindow#setLocalMappings(a:bufname)
    " autocmd for BufLeave
    autocmd! * <buffer>
    autocmd BufLeave <buffer> :call mywindow#echoWarningMsg('...BufLeve') | wincmd q
endfunction

function! <sid>Updatewindow(bufname)
    setlocal modifiable
    :0,$delete
    :0 put ='              edit split vsplit tab delete quit'
    if a:bufname == '__ls__' 
        :1 put = execute('ls')
    elseif a:bufname == '__old__' 
        :2 put = v:oldfiles
    endif
    :3
    setlocal nomodifiable
    exe "resize" .s:winheight | redraw!
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
