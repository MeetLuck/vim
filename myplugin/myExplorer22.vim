" MyExplorer: ls and oldfiles and shortcut and session mananger
" Buffer  Syntax: edit  ~/.vim/syntax/buf.vim"
" Session Syntax: edit  ~/.vim/syntax/mysession.vim"
" Library: ~/.vim/autoload/mywindow.vim
" Library: ~/.vim/autoload/mylib.vim
 
"Reinstall:
if has('win32') 
    command! -buffer Reinstall :silent! exe "!del " . expand("~/.vim/plugin/") . "myExplorer*.vim"
                             \| silent! exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/myExplorer*.vim" 
                              \|exe "!cp % ~/.vim/plugin"
endif

if exists('g:loaded_myExplorer') |finish |endif

"Configure:
    let g:loaded_myExplorer = 1
    let s:winheight = 15
    let s:shortcutFile = expand('$HOME/.vimshortcut')
    let s:sessiondir   = expand('$HOME/.vim/session')
    let s:winids = {'home':0, 'created':0}

"User Mapping:
    nnoremap <leader>ls  :call <sid>Open('__ls__')<cr>
    nnoremap <leader>old :call <sid>Open('__old__')<cr>
    nnoremap <leader>os  :call <sid>Open('__shortcut__')<cr>
    nnoremap <leader>mks :call <sid>Open('__session__')<cr>
    nnoremap <leader>as  :call <sid>addShortcut()<cr>

function! <sid>initShortcut()
    if !filereadable(s:shortcutFile)
        " "create .vimshortcut and save it"
        exe 'badd ' .s:shortcutFile | exe 'sb ' .bufname(s:shortcutFile)
        :1 put = '   Usage: edit split vsplit tab delete quit'
        :3 put = "    " .fnamemodify(s:shortcutFile,':p:~')
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
    let addfilename  = ["    " .expand('%:p:~')]
    call writefile(addfilename,s:shortcutFile,"a")
    call popup_notification('added' .addfilename,#{highlight:'Notification'})
endfunction

function! <sid>Open(bufname)
    "if !mywindow#doesWindowExist(a:bufname)   
    if bufnr(a:bufname) == -1
        "Buffer NOT Exist:
        call <sid>createWindow(a:bufname)
        call <sid>updateWindow(a:bufname)
        echomsg 'new ' .a:bufname  .' and new window is created'
    else
        "Bufferhidden: but buffer exists,that means window is open
        echomsg 'window with window-ID=' .s:winids.created .' exists!!!'
    endif
endfunction

function! <sid>createWindow(bufname)
    let s:winids.home = win_getid()
    exe "silent botright " .s:winheight ." split " .a:bufname
    let s:winids.created = win_getid()
    call <sid>setlocalOptions() | call <sid>setlocalMappings(a:bufname)
    autocmd! * <buffer>
    autocmd WinLeave <buffer>  call <sid>closeWindow()
                \| call popup_notification('Leaving window, ID=' .s:winids.created,
                \#{pos:'center',border:[0,0,0,0],
                \padding:[1,4,1,4],
                \highlight:'Notification',
                \})
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
        :silent exe "0r " .s:shortcutFile
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
    autocmd! * <buffer>
    if win_getid(winnr()) == s:winids.created
        exe win_id2win(s:winids.home) ."wincmd w" | echomsg 'moving to original window'
        exe win_id2win(s:winids.created) ."wincmd q" | echomsg 'closing created window' 
    else
        throw 'current window-ID is not ' .s:winids.created
    endif
    redraw!
endfunction

function! <sid>select(cmd)
    echomsg '***select: ' .a:cmd

    if bufname('%') == '__ls__'
        let bufnr = <sid>getBufnr()
        if bufnr != -1
            call <sid>closeWindow()
            :exe a:cmd .bufname(bufnr)
        endif
    else
        let filename = <sid>getFilename()
        if filename != -1
            call <sid>closeWindow()
            echomsg 'filename: ' .filename
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
    nnoremap  <buffer>  <C-W>       <nop>
    nnoremap  <buffer>  :           <nop>
    nnoremap  <buffer>  g           <nop>
    nnoremap  <buffer>  <Space>     <nop>
"   nnoremap  <buffer>  <Leader>w   <nop>
"   nnoremap  <buffer>  <Leader>ls  <nop>
    nnoremap  <buffer>  q           :call  <sid>closeWindow()<cr>
    nnoremap  <buffer>  <ESC>       :call  <sid>closeWindow()<cr>
    if a:bufname == ('__ls__' || '__shortcut__' || '__oldfiles__')
        nnoremap <buffer>  <CR>    :call <sid>select("e ")<cr>
        nnoremap <buffer>  e       :call <sid>select("e ")<cr>
        nnoremap <buffer>  s       :call <sid>select("sp ")<cr>
        nnoremap <buffer>  v       :call <sid>select("vs ")<cr>
        nnoremap <buffer>  t       :call <sid>select("tabe ")<cr>
    endif
    if a:bufname == '__ls__'
        nnoremap <buffer>  d       :call <sid>delete('__ls__')<cr>
    elseif a:bufname == '__shortcut__'
        echomsg a:bufname
        nnoremap <buffer>  d       :call <sid>delete('__shortcut__')<cr>
    elseif a:bufname == '__session__'
        nnoremap <buffer>  s       :call <sid>loadSession()<cr>
        nnoremap <buffer>  m       :call <sid>makeSession()<cr>
        nnoremap <buffer>  d       :call <sid>deleteSession('__session__')<cr>
    endif
endfunction

function! <sid>delete(bufname)
    if a:bufname == '__ls__'
        let bufnr = <sid>getBufnr()
        if bufnr != -1
            exe "bdelete" .bufnr | call <sid>updateWindow(a:bufname) 
        endif
    elseif a:bufname == '__shortcut__'
        "do not delete line 1, line2
        if line('.') < 3 | return | endif
        "delete current line
        setlocal modifiable | :delete | setlocal nomodifiable 
        "update .vimshortcut
        exe '%w!' ..s:shortcutFile
    endif
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

" "Initialize VimShortcut"
call <sid>initShortcut()
