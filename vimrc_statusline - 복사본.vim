" :h statusline
" "Do NOT use %#ColorGroup#, just use %N*" " "because of StatulsLineNotCurrentwindow"
" cterm235:guifg#262626 cterm246:guibg#949494
hi StatusLine   cterm=None ctermfg=1    ctermbg=8    gui=None  guifg=darkgray guibg=#606060
hi StatusLineNC cterm=None ctermfg=238  ctermbg=None gui=None  guifg=#606060  guibg=#002b36
"Blue3   -> cterm20:guifg#0000d7 "Silver  -> cterm7:guifg#0000d7 "DarkRed -> cterm88:guifg#870000 "Orange4 -> cterm58:guifg#5f5f00
hi User1 ctermfg=1  ctermbg=8   gui=None guifg=green        guibg=#707070
hi User2 ctermfg=12 ctermbg=8   gui=None guifg=gray         guibg=#606060
hi User3 ctermfg=13 ctermbg=8   gui=None guifg=darkred      guibg=#606060
hi User4 ctermfg=12 ctermbg=8   gui=None guifg=gray       guibg=#595959
hi User5 ctermfg=13 ctermbg=8   gui=italic guifg=#a07000      guibg=#535353
hi User6 ctermfg=13 ctermbg=8   gui=italic guifg=#a07000    guibg=#4b4b4b

set statusline=
"set statusline+=\ %1*%n( "buffer number n
set statusline+=%1*\ %{winnr()}\ 
set statusline+=%*
set statusline+=\ %15{fnamemodify(expand('%:p'),':~:h')}\
set statusline+=%2*%t\        "tail of the filename
"set statusline+=%#tail#/%t       "tail of the filename
set statusline+=%*
"set statusline+=%h      "help file flag
set statusline+=%3*\ %m      "modified flag
set statusline+=\%r     "read only flag
set statusline+=\%y      "filetype
set statusline+=\ %1*%{GlobalMark()}      "Global Marks
" "not working due to autochdir"
set statusline+=%*
set statusline+=%=      "left/right separator
set statusline+=%4*\ %c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P\     "percent through file
set statusline+=%5*\ %{&fenc}\ "file encoding
set statusline+=%6*\ %{&ff}\ "file format

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
