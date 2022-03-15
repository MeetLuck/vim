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

let s:sessiondir = expand('$HOME/.vim/session')

"command! -nargs=1 -bar    Mks         :call <sid>makeSession(<f-args>)
command! -nargs=1 -bar    Mks         :call mywindow#makeSession(s:sessiondir,<f-args>)
command! -nargs=0 -bar    Startup     :call <sid>openWindow('__startup__')


augroup myStartup
    autocmd!
    "Load Start Page:
    autocmd VimEnter      *  nested :call <sid>onVimEnter()
    "Save Last Session: when exit
    autocmd VimLeavePre   *  :call mywindow#saveLastSession(s:sessiondir)
augroup END

function! <sid>onVimEnter()
    "Update oldfiles
    autocmd BufEnter,BufRead,WinEnter,BufWinEnter *  :call <sid>updateOldfiles()
    if &viminfo !~ '!'
        echoerr 'viminfo does not include global variables'
    endif
    "Skip startUp -> c:>vim -options filename
    if argc() != 0 |return |endif
    "Open Window And Start Up:
    call <sid>openWindow('__startup__')
    autocmd! myStartup VimEnter
endfunction

function! <sid>updateOldfiles()
    "remove __file__"
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
    call <sid>writeLastfile(a:bufname)
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
    call filter(files, { -> v:val !~ last})
    let sessionlist += map(files,{ ->fnamemodify(v:val,":p:~")})
    let sessionlist += ['']
    let failed = append(line('$'),sessionlist)
    echom 'session list' .string(sessionlist)
endfunction

function! <sid>writeLastfile(bufname)
    "call <sid>updateOldfiles()
    let lastfile = [":'0"]
    "call map(v:oldfiles, 'fnamemodify(v:val, ":p:~")')
    let lastfile += [v:oldfiles[0]]
    "echo lastfile
    let lastfile += ['']
    let failed = append(line('$'), lastfile)
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

function! <sid>loadSession()
    :call mywindow#loadSession(s:sessiondir)
endfunction

"Mapping:
function! <sid>SetLocalMappings(bufname)
    nnoremap <buffer>  <CR>    :call <sid>loadSession()<cr>
    nnoremap <buffer>  s       :call <sid>loadSession()<cr>
    nnoremap <buffer>  d       <C-d>
    nnoremap <buffer>  u       <C-u>
endfunction


