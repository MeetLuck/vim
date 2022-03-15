" MyExplorer: ls and oldfiles and shortcut and session mananger
" Syntax: edit  ~/.vim/syntax/buf.vim"
" Syntax: edit  ~/.vim/syntax/mysession.vim"
" Library: ~/.vim/autoload/mywindow.vim
" Library: ~/.vim/autoload/mylib.vim
" Version: v12 -> added autocmd CmdlineEnter
"              -> remove mapping :
 
if has('win32') 
    command! -buffer Reinstall :silent! exe "!del " . expand("~/.vim/plugin/") . "myExplorer*.vim"
                             \| silent! exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
    command! -buffer Remove    :silent! exe "!del " . expand("~/.vim/plugin/") . "myExplorer*.vim"
    command! -buffer RemoveAll :silent! exe "!del " . expand("~/.vim/plugin/") . "*.*"
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/myExplorer*.vim" 
                              \|exe "!cp % ~/.vim/plugin"
endif

if exists('g:loaded_myExplorer') |finish |endif

" "configure myExplorer"
let g:loaded_myExplorer = 1
let s:winheight = 20
let s:shortcutFile = expand('$HOME/.vimshortcut')
let s:sessiondir   = expand('$HOME/.vim/session')

nnoremap <leader>ls  :call <sid>Open('__ls__')<cr>
nnoremap <leader>old :call <sid>Open('__old__')<cr>
nnoremap <leader>os  :call <sid>Open('__shortcut__')<cr>
nnoremap <leader>mks :call <sid>Open('__session__')<cr>
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
          :$delete | call echomsg 'deleted last line'
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

function! <sid>closeWindow()
    "let bufname = expand('%')
    autocmd! * <buffer>
    call mywindow#echoWarningMsg('->> entering closeWindow()') 
    if mywindow#doesWindowExist(s:bufname) 
        call mywindow#echoMoreMsg('bufname: ' .bufname('%') )
    else
        call mywindow#echoMoreMsg('bufname: ' .bufname('%') )
    endif
    if s:previouswinnr != winnr('#')
        call mywindow#echoMoreMsg('s:previouswinnr -> '.s:previouswinnr) 
        call mywindow#echoMoreMsg('winnr("#" ->) '.winnr('#'))
        return
    endif
    call mywindow#echoWarningMsg('previous winnr:' .s:previouswinnr .', winnr(#):' .winnr('#') )
    exe s:previouswinnr ."wincmd w" | exe bufwinnr(s:bufname) ."wincmd q"
    redraw!
    "call mywindow#echoWarningMsg('...end closing window')
    "exe s:previouswinnr ."wincmd w" | exe bufwinnr(bufname) ."wincmd q"
    "unlet! s:previouswinnr
endfunction

function! <sid>createWindow(bufname)
    "call <sid>savePreviousWinNr(a:bufname) 
    exe "silent botright " .s:winheight ." split " .a:bufname
    call <sid>setlocalOptions() | call <sid>setlocalMappings(a:bufname)
    let s:previouswinnr = winnr('#')
    let s:bufwinnr = winnr()
    let s:bufname = bufname('%')
    "call mywindow#echoWarningMsg('... previous winnr: '.winnr('#'))
    autocmd BufLeave <buffer>  call <sid>onBufLeave()
    autocmd WinLeave <buffer>  call <sid>onWinLeave()
endfunction

function! <sid>onBufLeave()
    call mywindow#echoWarningMsg('...BufLeve')
    call mywindow#echoMoreMsg('bufname,winnr' .bufname('%') .',' .winnr())
    call mywindow#echoMoreMsg('s:bufname,s:winnr' .s:bufname .',' .s:bufwinnr)
    if mywindow#isCurrentBuffer(s:bufname) && mywindow#isCurrentWindow(s:bufname)
        call mywindow#echoMoreMsg('->current buffer and current winnr')
    elseif mywindow#isCurrentBuffer(s:bufname) && !mywindow#isCurrentWindow(s:bufname)
        call mywindow#echoWarningMsg('-> current buffer and NOT current winnr')
    elseif !mywindow#isCurrentBuffer(s:bufname) && mywindow#isCurrentWindow(s:bufname)
        call mywindow#echoWarningMsg('-> NOT current buffer and current winnr')
    else
        call mywindow#echoWarningMsg('-> NOT current buffer and NOT current winnr')
    endif
    "call <sid>closeWindow()
    "unlet! s:previouswinnr
endfunction

function! <sid>onWinLeave()
    call mywindow#echoWarningMsg('...WinLeve')
    call mywindow#echoMoreMsg('bufname,winnr' .bufname('%') .',' .winnr())
    call mywindow#echoMoreMsg('s:bufname,s:winnr' .s:bufname .',' .s:bufwinnr)
    if mywindow#isCurrentBuffer(s:bufname) && mywindow#isCurrentWindow(s:bufname)
        call mywindow#echoMoreMsg('->current buffer and current winnr')
    elseif mywindow#isCurrentBuffer(s:bufname) && !mywindow#isCurrentWindow(s:bufname)
        call mywindow#echoWarningMsg('-> current buffer and NOT current winnr')
    elseif !mywindow#isCurrentBuffer(s:bufname) && mywindow#isCurrentWindow(s:bufname)
        call mywindow#echoWarningMsg('-> NOT current buffer and current winnr')
    else
        call mywindow#echoWarningMsg('-> NOT current buffer and NOT current winnr')
    endif
    "call <sid>closeWindow()
    "unlet! s:previouswinnr
endfunction

function! <sid>updateWindow(bufname)
    setlocal modifiable
    if a:bufname == '__ls__' 
        :0,$delete
        :0 put = '   Usage: edit split vsplit tab delete quit'
        :1 put = execute('ls')
    elseif a:bufname == '__old__' 
        :0,$delete
        :0 put = '   Usage: edit split vsplit tab delete quit'
        :2 put = v:oldfiles
    elseif a:bufname == '__shortcut__'
        :0,$delete
        silent exe "0r " .s:shortcutFile
        if strlen(getline('$')) == 0 | :$delete | endif
    elseif a:bufname == '__session__'
        :0,$delete
        :0 put = '   Usage: source makesession delete quit'
        let lastsession  = [fnamemodify(g:LASTSESSION,':p:~')] 
        let sessionlist = [ ]
        let sessionlist += lastsession
        let files = glob(s:sessiondir .'/*',0,1)
        let last = fnamemodify(g:LASTSESSION,':t')
        "echomsg 'lastsession: ' .last
        call filter(files, { -> v:val !~ last})
        let sessionlist += map(files,{ ->fnamemodify(v:val,":p:~")})
        let sessionlist += ['']
        let failed = append(line('$'),sessionlist)
    endif
    :3
    setlocal nomodifiable
    exe "resize" .s:winheight | redraw!
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

function! <sid>getFilename()
    if line(".") == 1 || getline(".") =~ '^\s*$'
        call mywindow#echoWarningMsg('!!! invalid file name '.getline('.'))
        return -1 
    endif
    if has('win32')
        let filename = mylib#trim(getline('.'))
        let filename = expand(filename)
        return filename
    else
        :normal ^
        let filename = expand('<cfile>')
        return filename
    endif
endfunction

function! <sid>closeWindow()
    if s:previouswinnr != winnr('#')
        call mywindow#echoErrorMsg('!!! previous winnr:' .s:previouswinnr .'!= winnr(#):' .winnr('#') )
        return
    endif
    call mywindow#echoWarningMsg('previous winnr:' .s:previouswinnr .', winnr(#):' .winnr('#') )
    exe s:previouswinnr ."wincmd w" | exe bufwinnr(s:bufname) ."wincmd q"
    autocmd! * <buffer>
    redraw!
endfunction

function! <sid>select(cmd)
    if bufname('%') == '__ls__'
        let bufnr = <sid>getBufnr()
        if bufnr != -1
            call <sid>closeWindow()
            :exe a:cmd .bufnr
        endif
    else
        let filename = <sid>getFilename()
        if filename != -1
            call <sid>closeWindow()
            exe a:cmd .filename
        endif
    endif
    "elseif "expand('%') == ('__old__' || '__shortcut__')
endfunction

function! <sid>loadSession()
    let filename = <sid>getFilename()
    if filename == -1 |return | endif
    if fnamemodify(filename,':p:h') == s:sessiondir
        "TODO: how to identify session file, =~ not working
        call <sid>closeWindow()
        try
            exe 'source  ' .filename
        catch /.*/
            echo v:exception
        endtry
    else
        call mywindow#echoWarningMsg('!!! invalid session file '.filename)
        return -1
    endif
endfunction

function! <sid>makeSession()
    let filename = <sid>getFilename()
    if filename == -1
        return
    endif
    "let filename = expand(filename)
    "silent call mywindow#echoWarningMsg('trying save '.filename)
    if filereadable(expand(filename))
        call mywindow#echoMoreMsg('overwriting existing '.filename)
        try
            call <sid>closeWindow()
            exe 'mks! ' .filename
        catch /.*/
            call mywindow#echoErrorMsg('error occured duing make session ' .v:exception)
        endtry
    else
        call mywindow#echoWarningMsg('cannot read '.filename)
    endif
endfunction

function! <sid>setlocalOptions()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable
    setlocal nonumber norelativenumber signcolumn=no colorcolumn=0 textwidth=0 
    setlocal cursorline
    if bufname('%') == '__session__'
        setlocal filetype=mysession
    else
        setlocal filetype=buf
    endif
endfunction

function! <sid>setlocalMappings(bufname)
    "edit "~/.vim/syntax/mysession.vim"
    nnoremap <buffer> <C-W> <nop>
    nnoremap <buffer>  :    <nop>
    if a:bufname == '__ls__'
        nnoremap <buffer>  <CR>    :call <sid>select("buffer ")<cr>
        nnoremap <buffer>  e       :call <sid>select("buffer ")<cr>
        nnoremap <buffer>  s       :call <sid>select("sb ")<cr>
        nnoremap <buffer>  v       :call <sid>select("vert sb ")<cr>
        nnoremap <buffer>  t       :call <sid>select("tab sb ")<cr>
        nnoremap <buffer>  d       :call <sid>deleteBuffer('__ls__')<cr>
    elseif a:bufname == ('__shortcut__' || '__oldfiles__')
        nnoremap <buffer>  <CR>    :call <sid>select("e ")<cr>
        nnoremap <buffer>  e       :call <sid>select("e ")<cr>
        nnoremap <buffer>  s       :call <sid>select("sp ")<cr>
        nnoremap <buffer>  v       :call <sid>select("vs ")<cr>
        nnoremap <buffer>  t       :call <sid>select("tabe ")<cr>
    endif
    if a:bufname == '__shortcut__'
        nnoremap <buffer>  d       :call <sid>deleteShortcut('__shortcut__')<cr>
    elseif a:bufname == '__session__'
        nnoremap <buffer>  s       :call <sid>loadSession()<cr>
        nnoremap <buffer>  m       :call <sid>makeSession()<cr>
        nnoremap <buffer>  d       :call <sid>deleteSession('__session__')<cr>
    endif
    nnoremap <buffer>  q        :call <sid>closeWindow()<cr>
    nnoremap <buffer>  <ESC>    :call <sid>closeWindow()<cr>
    "nnoremap <buffer>  :       :call <sid>closeWindow()<cr>:
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
    "exe s:previouswinnr ."wincmd w"
    exe winnr('#') ."wincmd w"
    silent exe "bdelete! " .s:shortcutFile | silent exe "sp! " .s:shortcutFile
    silent exe ":" .curline ."d" | silent wq! | exe "badd " .s:shortcutFile
    call <sid>createWindow(a:bufname)
    call <sid>updateWindow(a:bufname)
endfunction
function! <sid>deleteSession(bufname)
    let filename = <sid>getFilename()
    if filename == -1
        return
    endif
    let filename = expand(filename)
    if filereadable(filename)
        call mywindow#echMoreMsg('... deleting '.filename)
        if has('win32')
            silent exe '!del ' .filename
        else
            silent exe '!rm -rf '.filename
        endif
        call <sid>updateWindow(a:bufname)
    else
        call mywindow#echoWarningMsg('cannot read '.filename)
    endif
endfunction
