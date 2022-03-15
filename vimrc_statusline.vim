" :h statusline
" "Do NOT use %#ColorGroup#, just use %N*" " "because of StatulsLineNotCurrentwindow"
" cterm235:guifg#262626 cterm246:guibg#949494
hi clear StatusLine 
hi clear StatusLineNC
hi StatusLine   gui=bold guifg=#0070ff
hi StatusLineNC gui=None guifg=darkgray

hi   User1   gui=bold guifg=#0070ff
hi   User2   gui=bold guifg=#0070ff
hi   User3   gui=bold guifg=#0070ff
hi   User4   gui=bold guifg=#0070ff
hi   User5   gui=bold guifg=#0070ff
hi   User6   gui=bold guifg=#0070ff

set statusline=
"File Name Header:
set statusline+=\ %5{fnamemodify(expand('%:p'),':~:h')}\
"File Name Tail:
set statusline+=%1*%t\ \ 
set statusline+=%*
"Modified:
set statusline+=%2*%m
"Read Only:
set statusline+=\%r
"File Type:
set statusline+=\%y
"Global Mark:
set statusline+=%3*%{GlobalMark()}
set statusline+=%*
"Seperator:
set statusline+=%=
"This Session:
set statusline+=\ %6*%15{GetSession()}\ 
"Cursor Column:
set statusline+=%4*\ %c,
"Cursor Line Total Lines:
set statusline+=%l/%L
"Percent Through File:
set statusline+=\ %P\ 
"File Encoding:
set statusline+=%5*\ %{&fenc}\ 
"File Format:
set statusline+=%4*\ %{&ff}\ 

function! GlobalMark()
    let gmarks="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let settedmark=""
    for marker in split(gmarks,'\zs')
        if getpos("'" .marker)[0] == winbufnr(0)
            if getpos("'".marker)[1]!=0
                let settedmark.=marker
            endif
        endif
    endfor
    if strlen(settedmark)
        return " ".settedmark ." "
    else
        return ""
    endif
    unlet gmarks,settedmark
endfunction

function! GetSession()
    if len(v:this_session)
        return fnamemodify(v:this_session,':~:t')
    else
        return 'no session'
endfunction
