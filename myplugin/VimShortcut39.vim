" " VimShortcut 3.0"
" " for syntax edit  ~/.vim/syntax/buf.vim"
" !cp % ~/.vim/plugin
" !rm -rf ~/.vim/plugin/VimShortcut*.vim
if has('win32') 
    command! -buffer Reinstall :exe "!del " . expand("~/.vim/plugin/") . "VimShortcut*.vim"
                             \| exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/VimShortcut*.vim"
                             \| exe "!cp % ~/.vim/plugin"
endif


if exists("g:loaded_shortcut")
    finish
endif
let g:loaded_shortcut = 1

nnoremap <leader>as  :call <sid>AddShortcut()<cr>
nnoremap <leader>os  :call <sid>OpenShortcut()<cr>

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
    nnoremap <buffer>  <Enter>  :call  <sid>Select('edit ')<cr>
    nnoremap <buffer>  e    :call <sid>Select('edit ')<cr>
    nnoremap <buffer>  s    :call <sid>Select('split ')<cr>
    nnoremap <buffer>  v    :call <sid>Select('vsplit ')<cr>
    nnoremap <buffer>  t    :call <sid>Select('tabe ')<cr>
    nnoremap <buffer>  d    :call <sid>Deletefilename()<cr>
    nnoremap <buffer>  q    :call <sid>Closewindow()<cr>
    nnoremap <buffer>  <ESC>   :call <sid>Closewindow()<cr>
    nnoremap <buffer>  :   :call <sid>Closewindow()<cr>:
endfunction

function! <sid>OpenShortcut()
    if bufnr('__shortcut__') == -1 || bufwinnr('__shortcut__') == -1
        call <sid>Openwindow()
        call <sid>Updatewindow()
    elseif winnr() != bufwinnr('__shortcut__')
        exe bufwinnr('__shortcut__') ."wincmd w"
        call <sid>Updatewindow()
    endif
endfunction

function! <sid>OpenwindowPre()
    " "save previouse winnr"
    if !exists('s:prevwinnr')
        let s:prevwinnr = winnr()
    endif
    if s:prevwinnr != bufwinnr('__shortcut__')
        let s:prevwinnr = winnr()
    endif
endfunction

function! <sid>Closewindow()
    autocmd! * <buffer>
"   exe s:prevwinnr ."wincmd w"
    exe bufwinnr('__shortcut__') ."wincmd c"
endfunction

function! <sid>Openwindow()
    call <sid>OpenwindowPre()
    " "create windows : botright 6 split __shortcut__"
    exe "silent botright " .s:winheight ." split __shortcut__"
    " "setlocal options"
    call <sid>SetlocalVimShortcut()
    " "local mappings"
    call <sid>MapVimShortcut()
    " "autocmd when leave __buffer__ window"
    autocmd! * <buffer>
    autocmd BufLeave <buffer> :call <sid>Closewindow()
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
        return -1 
    else
        :normal ^
        return expand('<cfile>')
    endif
endfunction

function! <sid>Select(cmd)
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

function! <sid>Deletefilename()
    let curline = line('.')
    if curline == 1 | return | endif
    exe s:prevwinnr ."wincmd w"
    silent exe "bdelete! " .s:fname | silent exe "sp! " .s:fname
    silent exe ":" .curline ."d" | silent wq! | exe "badd " .s:fname
    call <sid>OpenShortcut()
endfunction
