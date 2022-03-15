" MyStartUp: start up "
" Buffer  Syntax: edit  ~/.vim/syntax/buf.vim"
" Session Syntax: edit  ~/.vim/syntax/mysession.vim"
" Library: ~/.vim/autoload/mywindow.vim
" Library: ~/.vim/autoload/mylib.vim
" Session: 1. source sessionName
"          2. make NEW session file
"          3. save Last session when exit
" Old Files: updates old files
" TODO   : 
 
"Reinstall:
if has('win32') 
    command! -buffer Reinstall :silent exe "!del " . expand("~/.vim/plugin/") . "myStartup*.vim"
                \| silent exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/myStartup*.vim" 
                \|exe "!cp % ~/.vim/plugin"
endif

command! -nargs=1 -bar    Mks         :call <sid>makeSession(<f-args>)
command! -nargs=0 -bar    Startup     :call <sid>openWindow('__startup__')

let s:sessiondir = expand('$HOME/.vim/session')

augroup myStartup
    autocmd!
    "Load Start Page:
    autocmd VimEnter      *  nested :call <sid>onVimEnter()
    "Save Last Session: when exit
    autocmd VimLeavePre   *  :call <sid>saveLastSession()
augroup END

function! <sid>onVimEnter()
    "Update Oldfiles:
    autocmd BufEnter,BufRead,WinEnter,BufWinEnter *  :call <sid>updateOldfiles()
    if &viminfo !~ '!'
        echoerr 'viminfo does not include global variables'
    endif
    "Skip StartUp: vim -options ...
    if argc() != 0 |return |endif
    "Open Window And Start Up:
    call <sid>openWindow('__startup__')
    autocmd! myStartup VimEnter
endfunction

function! <sid>updateOldfiles()
    call filter(v:oldfiles,"v:val !~ '__[^_]*__$'")
    "autocmd file <afile>
    if empty(expand('<afile>:p:t')) |return |endif
    "__file__
    if expand('<afile>:p') =~ '__[^_]*__$' |return |endif
    "continue...
    let file = expand('<afile>:p')
    call map(v:oldfiles, 'fnamemodify(v:val, ":p")')
    let idx = index(v:oldfiles, file)
    if idx == -1
        call insert(v:oldfiles, file, 0)
    else
        call remove(v:oldfiles, idx)
        call insert(v:oldfiles, file, 0)
    endif
    call map(v:oldfiles, 'fnamemodify(v:val, ":p:~")')
endfunction

"Windows:
function! <sid>openWindow(bufname)
    " "create new buffer __startup__"
    exe 'edit! ' .a:bufname
    call <sid>SetLocalOptions() | call <sid>SetLocalMappings(a:bufname)
    setlocal modifiable
    call <sid>writeTitle(a:bufname)
    call <sid>writeSession(a:bufname)
    call <sid>writeOldfiles(a:bufname)
    call <sid>writeLs(a:bufname)
    call <sid>formatBuffer(a:bufname)
    setlocal nomodifiable
    :noh | redraw!
endfunction

function! <sid>writeTitle(bufname)
    " "insert title below line 0 in the current buffer"
    let title =  [' press source or <CR> to load session ']
    let failed = append(0,title) 
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
    call <sid>updateOldfiles()
    let oldlist = [':oldfiles']
    "let oldlist += ['']
    "call map(v:oldfiles, 'fnamemodify(v:val, ":p:~")')
    let oldlist += v:oldfiles[:20]
    "echo oldlist
    let oldlist += ['']
    let failed = append(line('$'), oldlist)
endfunction

function! <sid>writeLs(bufname)
    let lslist = [':ls']
    "let lslist +=['']
    let lslist += execute('ls')->split("\n")
    "let lslist += split(execute('ls'),"\n")
    let lslist +=['']
    let failed = append(line('$'),lslist)
endfunction

function! <sid>formatBuffer(bufname)
    :g/^/s//     /g
    :3
endfunction

"Options:
function! <sid>SetLocalOptions()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable
    setlocal nonumber norelativenumber signcolumn=no colorcolumn=0 foldcolumn=0 textwidth=0 
    setlocal cursorline
    setlocal filetype=startup
endfunction

"Mapping:
function! <sid>SetLocalMappings(bufname)
    nnoremap <buffer>  <CR>    :call <sid>loadSession()<cr>
    nnoremap <buffer>  s       :call <sid>loadSession()<cr>
    nnoremap <buffer>  d       <C-d>
    nnoremap <buffer>  u       <C-u>
endfunction

"Session:
function! <sid>getSessionName()
    let sessionname = getline('.')->mylib#trim()->expand()
    if fnamemodify(sessionname,':p:h') == s:sessiondir
        return sessionname
    else
        call mywindow#echoWarningMsg('!!! invalid session name '.sessionname)
        return -1
    endif
endfunction

function! <sid>saveLastSession()
    let tmp = &sessionoptions
    set sessionoptions -=options
    if empty(v:this_session)
        "make default session
        exe 'mks! ' .s:sessiondir .'/Session.vim' 
    else
        "save last session
        exe 'mks! '.v:this_session
    endif
    let g:LASTSESSION = v:this_session
    let &sessionoptions = tmp
endfunction

function! <sid>makeSession(sessionname)
    "1.Back up sessionoptions
    "2.Remove all options for mksession command
    "3.Restore sessionoptions
    let path = s:sessiondir .'/' .a:sessionname
    let tmp = &sessionoptions 
    set sessionoptions -=options
    exe 'mks! ' .path
    call mywindow#echoNotify( 'mks! '.path )
    let &sessionoptions = tmp
endfunction

function! <sid>loadSession()
    let sessionname = <sid>getSessionName()
    if sessionname == -1 |return |endif
    if filereadable(sessionname)
        try
            exe 'source  ' .sessionname
            call mywindow#echoNotify('source '.sessionname)
        catch /.*/
            echo v:exception
        endtry
    else
        call mywindow#echoWarningMsg('can not read '.sessionname)
    endif
endfunction

