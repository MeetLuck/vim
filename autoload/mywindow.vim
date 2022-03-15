
"Echo Functions:
function! mywindow#echoErrorMsg(msg)
    echohl ErrorMsg |echomsg a:msg |echohl None
endfunction

function! mywindow#echoWarningMsg(msg)
    echohl WarningMsg |echomsg a:msg |echohl None
endfunction

function! mywindow#echoMoreMsg(msg)
    echohl MoreMsg |echomsg a:msg |echohl None
endfunction

function! mywindow#echoNotify(msg)
    echohl MoreMsg |echomsg a:msg |echohl None
endfunction

function! mywindow#isCurrentWindow(bufname)
    call mywindow#echoMoreMsg('winnr,bufwinnr' .winnr() .',' .bufwinnr(a:bufname))
    return winnr() == bufwinnr(a:bufname)
endfunction

function! mywindow#isCurrentBuffer(bufname)
    return bufname('%') == a:bufname
endfunction

function! mywindow#doesWindowExist(bufname)
    return bufwinnr(a:bufname) != -1
endfunction

"Popup Windows:
function!  mywindow#notification(message)
    call popup_notification(a:message,
        \#{pos:'center',border:[0,0,0,0],
        \padding:[1,4,1,4],
        \highlight:'Notification',
        \})
endfunction

function!  mywindow#create_popup(contents,title,highlight,filetype)
   let winid = popup_create(a:contents, #{
        \ title: a:title,
        \ highlight: a:highlight,
       	\ padding: [0,1,1,1],
       	\ border: [1,0,0,0],
       	\ borderchars: [' '],
       	\ borderhighlight: ['popupTitle','','',''],
       	\ close: 'button',
       	\ })
   call win_execute(winid, 'setlocal conceallevel=1')
   call win_execute(winid, 'setlocal filetype=' .a:filetype)
endfunction

"Sessions:
function! mywindow#getSessionName(sessiondir)
    let sessionname = getline('.')->mylib#trim()->expand()
    "if fnamemodify(sessionname,':p:h') == a:sessiondir
    if filereadable(sessionname) && fnamemodify(sessionname,':p:h') == a:sessiondir
        return sessionname
    else
        call mywindow#echoWarningMsg('!!! invalid session name '.sessionname)
        return -1
    endif
endfunction

function! mywindow#saveLastSession(sessiondir)
    let tmp = &sessionoptions
    set sessionoptions -=options
    if empty(v:this_session)
        "make default session
        exe 'mks! ' .a:sessiondir .'/Session.vim' 
    else
        "save last session
        exe 'mks! '.v:this_session
    endif
    let g:LASTSESSION = v:this_session
    let &sessionoptions = tmp
    "to debug, wait for keystroke
    "let t = getchar()
endfunction

function! mywindow#makeSession(sessiondir,sessionname)
    "1.Back up sessionoptions
    "2.Remove all options for mksession command
    "3.Restore sessionoptions
    if fnamemodify(a:sessionname,":e") !~ 'session'
        call mywindow#echoNotify('session file extension is not "session"')
        return
    endif
    let path = a:sessiondir .'/' .a:sessionname
    let tmp = &sessionoptions 
    set sessionoptions -=options
    exe 'mks! ' .path
    call mywindow#echoNotify( 'mks! '.path )
    let &sessionoptions = tmp
endfunction

function! mywindow#loadSession(sessiondir)
    let sessionname = mywindow#getSessionName(a:sessiondir)
    if sessionname == -1 |return |endif
    try
        exe 'source  ' .sessionname
        call mywindow#echoNotify('source '.sessionname)
    catch /.*/
        echo v:exception
    endtry
endfunction
