" MyExplorer: ls and oldfiles and shortcut and session mananger
" Buffer  Syntax: edit  ~/.vim/syntax/buf.vim"
" Session Syntax: edit  ~/.vim/syntax/mysession.vim"
" Library: ~/.vim/autoload/mywindow.vim
" Library: ~/.vim/autoload/mylib.vim
" TODO   : <C-W>s -> split windows problem
 
"Reinstall:
if has('win32') 
    command! -buffer Reinstall :silent! exe "!del " . expand("~/.vim/plugin/") . "myExplorer*.vim"
                             \| silent! exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/myExplorer*.vim" 
                              \|exe "!cp % ~/.vim/plugin"
endif

"Safe Guard:
"if exists('g:loaded_myExplorer') |finish |endif

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
        :2 put = ''
        :3 put = '    ' .fnamemodify(s:shortcutFile,':p:~')
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
    " Note: we need to add <CR>""
    let addfilename  = ["    " .expand('%:p:~') ."\<CR>"]
    call writefile(addfilename,s:shortcutFile,"as")
    call mywindow#notification('added ' .expand('%:p:~') )
endfunction

function! <sid>Open(bufname)
    "if !mywindow#doesWindowExist(a:bufname)   
    if bufnr(a:bufname) == -1
        "Buffer NOT Exist:
        call <sid>createWindow(a:bufname)
        call <sid>updateWindow(a:bufname)
        call mywindow#notification(a:bufname .' with ID=' .s:winids.created  .' is created')
    else
        "Buffer Hidden: but buffer exists
        if mywindow#doesWindowExist(a:bufname)   
            echomsg 'window with window-ID=' .s:winids.created .' EXISTS!!!'
        else 
            echomsg 'buffer exist, BUT window with window-ID=' .s:winids.created .' NOT exist!!!'
            exe 'bwipeout! ' .a:bufname
        endif
    endif
endfunction

function! <sid>createWindow(bufname)
    let s:winids.home = win_getid()
    exe "silent botright " .s:winheight ." split " .a:bufname
    let s:winids.created = win_getid()
    call <sid>setlocalOptions() | call <sid>setlocalMappings(a:bufname)
    autocmd! * <buffer>
    autocmd WinLeave <buffer>  call <sid>closeWindow()
                \| call mywindow#notification('Leaving window, ID=' .s:winids.created)
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
        :0 put = '   Usage: open delete quit'
        let sessionlist = [ ]
        let sessionlist += glob(s:sessiondir .'/*',0,1)->map({idx,val->fnamemodify(val,":p:~")})
        let sessionlist += ['']
        "let files = glob(s:sessiondir .'/*',0,1)
        "let sessionlist += map(files,{ idx,val->fnamemodify(val,":p:~")})
        let failed = append(line('$'),sessionlist)
        echomsg "__session__ update done"
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
    nnoremap  <buffer>  <Leader>w   <nop>
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
        nnoremap <buffer>  <CR>       :call <sid>openSession()<cr>
        nnoremap <buffer>  s       :call <sid>openSession()<cr>
        nnoremap <buffer>  d       :call <sid>delete('__session__')<cr>
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
    elseif a:bufname == '__session__'
        let sessionname = mywindow#getSessionName(s:sessiondir)
        "check if it is current session"
        if sessionname == -1 || sessionname == v:this_session
           return
        endif
        if sessionname == g:LASTSESSION
            "v:this_session : current session"
            "g:LASTSESSION : previous session"
            "v:this_session is empty if no session"
            echomsg g:LASTSESSION
            echomsg v:this_session
            echoerr v:this_session
        endif
        call mywindow#echoMoreMsg('... deleting '.sessionname)
        if has('win32')
            silent exe '!del ' .sessionname
        else
            silent exe '!rm -rf '.sessionname
        endif
        call <sid>updateWindow(a:bufname)
    endif
endfunction

" Session: load(source), delete
function! <sid>openSession()
    "before source a new session , save current session
    call mywindow#saveLastSession(s:sessiondir)
    "before source a new session, close __session__ buffer 
    call <sid>closeWindow()
    "load session under cursor
    call mywindow#loadSession(s:sessiondir)
endfunction

"Initialize VimShortcut:
call <sid>initShortcut()
