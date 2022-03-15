" " Buffer Explore and OldFiles and Shortcut"
" " for syntax edit  ~/.vim/syntax/buf.vim"
"~/.vim/autoload/mywindow.vim
 
if has('win32') 
    command! -buffer Reinstall :silent! exe "!del " . expand("~/.vim/plugin/") . "myBufExOldFilesShortcut*.vim"
                             \| silent! exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/myBufExOldFilesShortcut*.vim" 
                              \|exe "!cp % ~/.vim/plugin"
endif

if exists('g:loaded_bufex_oldfiles_shortcut')
    finish
endif

" "configure BufEx"
let g:loaded_bufex_oldfiles_shortcut = 1
let s:winheight = 6
let s:shortcutFile = expand('$HOME/.vimshortcut')

nnoremap <leader>ls :call  <sid>Open('__ls__')<cr>
nnoremap <leader>old :call <sid>Open('__old__')<cr>
nnoremap <leader>os  :call <sid>Open('__shortcut__')<cr>
nnoremap <leader>as  :call <sid>addShortcut()<cr>


function! <sid>initShortcut()
    if !filereadable(s:shortcutFile)
        " "create .vimshortcut and save it"
        let line1 = '   Usage: edit split vsplit tab delete quit'
        let line3 = "    " .fnamemodify(s:shortcutFile,':p:~')
        exe 'badd ' .s:shortcutFile | exe 'sb ' .bufname(s:shortcutFile)
        :1 put = line1
        :3 put = line3
        if strlen(getline('$')) == 0
          :$delete | echomsg 'deleted last line'
        endif
        :wq!
    else
        exe 'badd ' .s:shortcutFile
    endif
endfunction
function! <sid>addShortcut()
    " "add current file name to .vimshortcut"
    let filename = "    " .expand('%:p:~')
    exe "sb " .s:shortcutFile
    exe append(line('$'),filename) 
    wq!
    echohl Special | echo "added ".expand('%:p:~') | echohl None
endfunction

" "Initialize VimShortcut"
call <sid>initShortcut()

function! <sid>Open(bufname)
    if !mywindow#doesWindowExist(a:bufname)   " "buffer window is NOT CREATED"
        call <sid>createWindow(a:bufname)
        call <sid>updateWindow(a:bufname)
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

function! <sid>savePreviousWinNr(bufname)
    if winnr() != bufwinnr(a:bufname)
        let s:previouswinnr = winnr()
    else
        echoerr '...previouse window is ' .a:bufname
        finish
    endif
endfunction

function! <sid>closeWindow()
    let bufname = expand('%')
    call mywindow#echoWarningMsg('...moving to previous window '.bufname)
    autocmd! * <buffer>
    exe s:previouswinnr ."wincmd w" | exe bufwinnr(bufname) ."wincmd q"
    unlet! s:previouswinnr
endfunction

function! <sid>createWindow(bufname)
    call <sid>savePreviousWinNr(a:bufname) 
    "create windows : botright 6 split a:bufname
    exe "silent botright " .s:winheight ." split " .a:bufname
    call <sid>setlocalOptions() | call <sid>setlocalMappings(a:bufname)
    " autocmd for BufLeave
    autocmd! * <buffer>
    autocmd BufLeave <buffer> :call mywindow#echoWarningMsg('...BufLeve') | wincmd q
endfunction

function! <sid>updateWindow(bufname)
    setlocal modifiable
    :0,$delete
    :0 put = '   Usage: edit split vsplit tab delete quit'
    if a:bufname == '__ls__' 
        :1 put = execute('ls')
    elseif a:bufname == '__old__' 
        :2 put = v:oldfiles
    elseif a:bufname == '__shortcut__'
        :0,$delete
        silent exe "0r " .s:shortcutFile
        if strlen(getline('$')) == 0 | :$delete | endif
    endif
    :3
    setlocal nomodifiable
    exe "resize" .s:winheight | redraw!
endfunction

function! <sid>getFilename()
    if line(".") == 1 || strlen(getline(".")) == 0
        call mywindow#echoWarningMsg('!!! invalid file name '.getline('.'))
        return -1 
    elseif has('win32')
        let filename = getline('.')
        echomsg filename
        return filename
    else
        let filename = expand('<cfile>')
        return filename
    endif
endfunction

function! <sid>getBufnr()
    if line(".") == 1 || strlen(getline(".")) == 0
        call mywindow#echoWarningMsg('!!! invalid buffer number')
        return -1
    else
        :normal ^
        return str2nr( expand('<cword>') )
    endif
endfunction

function! <sid>select(cmd)
    if expand('%') == '__ls__'
        let bufnr = <sid>getBufnr()
        if bufnr != -1
            call <sid>closeWindow()
            exe a:cmd .bufnr
        endif
    elseif "expand('%') == ('__old__' || '__shortcut__')
        let filename = <sid>getFilename()
        if filename != -1
            call <sid>closeWindow()
            exe a:cmd .filename
        endif
    endif
endfunction

function! <sid>setlocalOptions()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable
    setlocal nonumber norelativenumber signcolumn=no colorcolumn=0 textwidth=0 
    setlocal cursorline
endfunction

function! <sid>setlocalMappings(bufname)
    setlocal filetype=buf
    "edit "~/.vim/syntax/BufEx.vim"
    nnoremap <buffer> <C-W> <nop>
    "nnoremap <buffer>  :    <nop>
    if a:bufname == '__ls__'
        nnoremap <buffer>  <CR>    :call <sid>select("buffer ")<cr>
        nnoremap <buffer>  e       :call <sid>select("buffer ")<cr>
        nnoremap <buffer>  s       :call <sid>select("sb ")<cr>
        nnoremap <buffer>  v       :call <sid>select("vert sb ")<cr>
        nnoremap <buffer>  t       :call <sid>select("tab sb ")<cr>
        nnoremap <buffer>  d       :call <sid>deleteBuffer('__ls__')<cr>
    else
        nnoremap <buffer>  <CR>    :call <sid>select("e ")<cr>
        nnoremap <buffer>  e       :call <sid>select("e ")<cr>
        nnoremap <buffer>  s       :call <sid>select("sp ")<cr>
        nnoremap <buffer>  v       :call <sid>select("vs ")<cr>
        nnoremap <buffer>  t       :call <sid>select("tabe ")<cr>
    endif
    if a:bufname == '__shortcut__'
        nnoremap <buffer>  d       :call <sid>deleteShortcut('__shortcut__')<cr>
    endif
    nnoremap <buffer>  q       :call <sid>closeWindow()<cr>
    nnoremap <buffer>  <ESC>   :call <sid>closeWindow()<cr>
    nnoremap <buffer>  :       :call <sid>closeWindow()<cr>:
endfunction

function! <sid>deleteBuffer(bufname)
    let bufnr = <sid>getBufnr()
    if bufnr != -1
"       autocmd! * <buffer>
"       exe s:prevwinnr ."wincmd w"
"       exe bufwinnr(a:bufname) ."wincmd c"
        exe "bdelete" .bufnr
"       call <sid>Openwindow(a:bufname)
        call <sid>updateWindow(a:bufname) 

    endif
endfunction
function! <sid>deleteShortcut(bufname)
    let curline = line('.')
    if curline == 1 | return | endif
    exe s:previouswinnr ."wincmd w"
    silent exe "bdelete! " .s:shortcutFile | silent exe "sp! " .s:shortcutFile
    silent exe ":" .curline ."d" | silent wq! | exe "badd " .s:shortcutFile
    call <sid>createWindow(a:bufname)
    call <sid>updateWindow(a:bufname)
endfunction
