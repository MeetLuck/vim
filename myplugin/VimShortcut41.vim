" " VimShortcut 3.0"
" " for syntax edit  ~/.vim/syntax/buf.vim"
" !cp % ~/.vim/plugin
" !rm -rf ~/.vim/plugin/VimShortcut*.vim
if has('win32') 
    command! -buffer Reinstall :silent! exe "!del " . expand("~/.vim/plugin/") . "VimShortcut*.vim"
                             \| silent! exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/VimShortcut*.vim"
                             \| exe "!cp % ~/.vim/plugin"
endif

command! -buffer Testrun  :setlocal nomodifiable | messages clear | Runtime

if exists("g:loaded_shortcut")
    finish
endif
let g:loaded_shortcut = 1

nnoremap <leader>as  :call <sid>AddShortcut()<cr>
nnoremap <leader>os  :call <sid>OpenShortcut('__shortcut__')<cr>

" "configure VimShortcut"
let s:winheight = 6
let s:fname = expand('$HOME/.vimshortcut')
let s:Usage = "   Usage: edit split vsplit tab delete quit"
let s:line3 = "    " .fnamemodify(s:fname,':p:~')

function! <sid>InitShortcut()
    if !filereadable(s:fname)
        " "create .vimshortcut and save it"
        exe 'badd ' .s:fname | exe 'sb ' .bufname(s:fname)
        :0 put = s:Usage
        :2 put = s:line3
        if strlen(getline('$')) == 0
          :$delete | echomsg 'deleted last line'
        endif
        :wq!
    else
        exe 'badd ' .s:fname
    endif
endfunction

" "Initialize VimShortcut"
call <sid>InitShortcut()

function! <sid>AddShortcut()
    " "add current file name to .vimshortcut"
    let filename = "    " .expand('%:p:~')
    exe "sb " .s:fname
    exe append(line('$'),filename) 
    wq!
    echohl Special | echo "added ".expand('%:p:~') | echohl None
endfunction

function! <sid>SetlocalVimShortcut()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    setlocal hidden
    setlocal signcolumn=no colorcolumn=0 textwidth=0
    setlocal nonumber
    setlocal cursorline
    setlocal filetype=buf
    if has('win32')
        setlocal isfname+=32
    endif
    "edit "~/.vim/syntax/buf.vim"
endfunction

function! <sid>MapVimShortcut()
    nnoremap <buffer> <C-W>s  <nop>
    nnoremap <buffer>  <Enter>  :call  <sid>Select('edit ')<cr>
    nnoremap <buffer>  e    :call <sid>Select('edit ')<cr>
    nnoremap <buffer>  s    :call <sid>Select('split ')<cr>
    nnoremap <buffer>  v    :call <sid>Select('vsplit ')<cr>
    nnoremap <buffer>  t    :call <sid>Select('tabe ')<cr>
    nnoremap <buffer>  d    :call <sid>Deletefilename()<cr>
    nnoremap <buffer>  q    :call <sid>Closewindow()<cr>
    nnoremap <buffer>  <ESC>   :call <sid>Closewindow('__shortcut__')<cr>
    nnoremap <buffer>  :   :call <sid>Closewindow('__shortcut__')<cr>:
endfunction


function! <sid>EchoErrorMsg(msg)
    echohl ErrorMsg |echomsg a:msg |echohl None
endfunction

function! <sid>EchoWarningMsg(msg)
    echohl WarningMsg |echomsg a:msg |echohl None
endfunction

function! <sid>IsCurrentWindow(bufname)
        return winnr() == bufwinnr(a:bufname)
endfunction

function! <sid>OpenShortcut(bufname)
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
        call <sid>Updatewindow()
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

function! <sid>Closewindow(bufname)
    autocmd! * <buffer>
    echomsg 'to previous window' | exe s:prevwinnr ."wincmd w"
    exe bufwinnr(a:bufname) ."wincmd q"
endfunction

function! <sid>Openwindow(bufname)
    call <sid>SavePreviousWinNr(a:bufname)
    " create windows : botright 6 split __shortcut__"
    exe "silent botright " .s:winheight ." split " .a:bufname
    " setlocal options"
    call <sid>SetlocalVimShortcut()
    " local mappings"
    call <sid>MapVimShortcut()
    " autocmd for BufLeave"
    autocmd! * <buffer>
    autocmd WinLeave <buffer> :call <sid>EchoWarningMsg('...WinLeave') | wincmd q
endfunction

function! <sid>Updatewindow()
    setlocal modifiable
    :0,$delete
    silent exe "0r " .s:fname
    if strlen(getline('$')) == 0
      :$delete
      silent echo 'deleted last line'
    endif
    setlocal nomodifiable
    exe "resize" .s:winheight
    redraw!
endfunction

function! <sid>Getfilename()
    if line(".") == 1 || strlen(getline(".")) == 0
        call <sid>EchoErrorMsg('!!! invalid buffer number '.bufnr)
        return -1 
    else
        :normal ^
        return expand('<cfile>')
    endif
endfunction

function! <sid>Select(cmd)
    let filename = <sid>Getfilename()
    if filename != -1
        autocmd! * <buffer>
        exe s:prevwinnr ."wincmd w"
        exe bufwinnr('__shortcut__') ."wincmd c" 
        exe a:cmd .filename
    endif
endfunction

function! <sid>Deletefilename()
    let curline = line('.')
    if curline == 1 | return | endif
    exe s:prevwinnr ."wincmd w"
    silent exe "bdelete! " .s:fname | silent exe "sp! " .s:fname
    silent exe ":" .curline ."d" | silent wq! | exe "badd " .s:fname
    call <sid>OpenShortcut()
endfunction
