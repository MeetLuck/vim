" " VimShortcut 3.0"
" " for syntax edit  ~/.vim/syntax/buf.vim"
" !cp % ~/.vim/plugin
" !rm -rf ~/.vim/plugin/VimShortcut*.vim

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
        exe 'badd' .s:fname | exe 'sb ' .bufname(s:fname)
        :0 put = s:Usage
        :2 put = s:line3
        if strlen(getline('$')) == 0
          :$delete | echomsg 'deleted last line'
        endif
        :wq!
    else
        exe 'badd' .s:fname
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
"   setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    setlocal buftype=nofile bufhidden=wipe noswapfile
    setlocal hidden
    setlocal signcolumn=no colorcolumn=0 textwidth=0
    setlocal nonumber
    setlocal cursorline
    setlocal filetype=buf
    "edit "~/.vim/syntax/buf.vim"
endfunction

function! <sid>MapVimShortcut()
    nnoremap <buffer>  <Enter>  :call  <sid>Select('edit ')<cr>
    nnoremap <buffer>  e    :call <sid>Select('edit ')<cr>
    nnoremap <buffer>  s    :call <sid>Select('split ')<cr>
    nnoremap <buffer>  v    :call <sid>Select('vsplit ')<cr>
    nnoremap <buffer>  t    :call <sid>Select('tabe ')<cr>
    nnoremap <buffer>  d    :call <sid>Deletefilename()<cr>
    nnoremap <buffer>  q    :call <sid>Quitshortcut()<cr>
    nnoremap <buffer>  <ESC>    :call <sid>Quitshortcut()<cr>
    nnoremap <buffer>  :    :call <sid>Quitshortcut()<cr>:
endfunction

function! <sid>OpenShortcut()
    if bufnr('__shortcut__') == -1 || bufwinnr('__shortcut__') == -1
        call <sid>Openwindow()
        call <sid>Updatewindow()
    elseif winnr() != bufwinnr('__shortcut__')
        echohl Errormsg | echomsg 'au WinLeave Not Working' | echohl None
    endif
endfunction

function! <sid>Openwindow()
    " "save previouse winnr"
    let s:prevwinnr = winnr()
    " "create windows : botright 6 split __shortcut__"
    exe "silent botright " .s:winheight ." split __shortcut__"
    if s:prevwinnr == winnr()
        echohl Warningmsg
        echomsg "# previous,current :" .s:prevwinnr ."," .winnr()
        let s:prevwinnr -= 1
    endif
    " "setlocal options"
    call <sid>SetlocalVimShortcut()
    " "local mappings"
    call <sid>MapVimShortcut()
    " "autocmd when leave __buffer__ window"
    autocmd! * <buffer>
    autocmd WinLeave <buffer> :exe bufwinnr('__shortcut__') ."wincmd c"
    exe "resize" .s:winheight
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
    redraw!
endfunction


function! <sid>Quitshortcut()
    exe s:prevwinnr ."wincmd w"
"   exe bufwinnr(s:fname) ."wincmd c"
"   redraw!
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
    if filename == -1 
        " "When comparing a string with a number, the string is first converted to a number."
        echohl Warningmsg| echomsg "Invalid filename or line"
    else
        exe s:prevwinnr ."wincmd w"
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
