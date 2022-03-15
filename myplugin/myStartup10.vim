if has('win32') 
    command! -buffer Reinstall :silent! exe "!del " . expand("~/.vim/plugin/") . "myStartup*.vim"
                \| silent! exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/myStartup*.vim" 
                \|exe "!cp % ~/.vim/plugin"
endif

let s:sessiondir = expand('$HOME/.vim/session')

augroup myStartup
    autocmd!
    autocmd VimEnter      *  nested :call <sid>onVimEnter()
    autocmd VimLeavePre   *  :call <sid>saveLastSession()
    autocmd BufEnter      *  :call <sid>updateOldfiles()
augroup END

function! <sid>onVimEnter()
    if argc() != 0 |return |endif
    if &viminfo !~ '!'
        echoerr 'viminfo does not include global variables'
    endif
    call <sid>openWindow('__startup__')
endfunction

function! s:updateOldfiles(file)
    if &buftype==nofile |return |endif
    let idx = index(v:oldfiles, a:file)
    if idx != -1
        call remove(v:oldfiles, idx)
    endif
    call insert(v:oldfiles, a:file, 0)
endfunction

function! <sid>openWindow(bufname)
    "create new buffer __startup__
    exe 'edit! ' .a:bufname
    call <sid>SetLocalOptions() | call <sid>SetLocalMappings(a:bufname)
    setlocal modifiable
    call <sid>writeTitle(a:bufname)
    call <sid>writeSession(a:bufname)
    call <sid>writeOldfiles(a:bufname)
    call <sid>writeLs(a:bufname)
    call <sid>formatBuffer(a:bufname)
    :noh
    setlocal nomodifiable
    redraw!
endfunction

function! <sid>writeTitle(bufname)
    let cmd =  [' press source or <CR> to load session ']
    let failed = append(0,cmd)
    ":0put = ' source edit tab quit'
endfunction

function! <sid>writeSession(bufname)
    let sessiontitle = [':Session ']
    let lastsession  = [fnamemodify(g:LASTSESSION,':p:~')] 
    let sessionlist = [ ]
    let sessionlist += sessiontitle
    let sessionlist += lastsession
    let files = glob(s:sessiondir .'/*',0,1)
    let last = fnamemodify(g:LASTSESSION,':t')
    "echomsg 'lastsession: ' .last
    call filter(files, { -> v:val !~ last})
    let sessionlist += map(files,{ ->fnamemodify(v:val,":p:~")})
    let sessionlist += ['']
    let failed = append(line('$'),sessionlist)
endfunction

function! <sid>writeOldfiles(bufname)
    let oldlist = [':oldfiles']
    "let oldlist += ['']
    let oldlist += v:oldfiles[:20]
    let oldlist += ['']
    let failed = append(line('$'), oldlist)
endfunction

function! <sid>writeLs(bufname)
    let lslist = [':ls']
    "let lslist +=['']
    let lslist += split(execute('ls'),"\n")
    let lslist +=['']
    let lslist +=['']
    let failed = append(line('$'),lslist)
endfunction

function! <sid>formatBuffer(bufname)
    :g/^/s//     /g
    :3
endfunction

function! <sid>getSessionName()
    if line(".") == 1 || getline(".") =~ '^\s*$'
        call mywindow#echoWarningMsg('!!! invalid session file '.getline('.'))
        return -1 
    endif
    if has('win32')
        let filename = mylib#trim(getline('.'))
        let filename = expand(filename)
    else
        :normal ^
        let filename = expand('<cfile>')
    endif
    if fnamemodify(filename,':p:h') == s:sessiondir
        "TODO: how to identify session file, =~ not working
        return filename
    else
        call mywindow#echoWarningMsg('!!! invalid session file '.filename)
        return -1
    endif
endfunction

function! <sid>saveLastSession()
    let tmp = &sessionoptions
    set sessionoptions -=options
    if empty(v:this_session)
        exe 'mks! ' .s:sessiondir .'/Session.vim' 
    else
        exe 'mks! '.v:this_session
    endif
    let g:LASTSESSION = v:this_session
    let &sessionoptions = tmp
endfunction

function! <sid>makeSession(filename)
    let path = s:sessiondir .'/' .a:filename
    let tmp = &sessionoptions
    set sessionoptions -=options
    exe 'mks! ' .path
    call mywindow#echoMoreMsg( 'mks! '.path )
    let &sessionoptions = tmp
endfunction

function! <sid>loadSession()
    let filename = <sid>getSessionName()
    if filename == -1 |return |endif
    if filereadable(filename)
        try
            exe 'source  ' .filename
            call mywindow#echoMoreMsg('source '.filename)
        catch /.*/
            echo v:exception
        endtry
    else
        call mywindow#echoWarningMsg('can not read '.filename)
    endif
endfunction

function! <sid>SetLocalOptions()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable
    setlocal nonumber norelativenumber signcolumn=no colorcolumn=0 foldcolumn=0 textwidth=0 
    setlocal cursorline
    setlocal filetype=startup
endfunction

function! <sid>SetLocalMappings(bufname)
    nnoremap <buffer>  <CR>    :call <sid>loadSession()<cr>
    nnoremap <buffer>  s       :call <sid>loadSession()<cr>
endfunction

command! -nargs=1 -bar    Mks         :call <sid>makeSession(<f-args>)
command! -nargs=0 -bar    Startup     :call <sid>openWindow('__startup__')
