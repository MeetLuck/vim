"hi clear Normal
"hi Normal ctermfg=244 guifg=#808080 guibg=#002b36
"hi Normal ctermfg=246 guifg=#949494 guibg=#002b36
"put=execute('verbose hi Normal')
"put=execute('verbose hi LineNr')
"Normal         xxx guifg=#839496 guibg=#002b36
"LineNr         xxx ctermfg=14 guifg=#586e75 guibg=#073642

"   "highlight Number Column"
hi clear LineNr
hi LineNr ctermfg=238 ctermbg=None guifg=#445566 guibg=#002b36
"   "highlight Sign Column"
"hi clear SignColumn
"hi clear CursorLine
"hi SignColumn ctermbg=None
"hi CursorLine ctermbg=235 guibg=black

" Original: ctermgf != guifg
"hi Type         ctermfg=94    guifg=#b58900
"hi PreProc      ctermfg=136   guifg=#cb4b16
"hi Special      ctermfg=88    guifg=#dc322f
"hi vimCommand   ctermfg=25    guifg=#b58900
"hi vimOption    ctermfg=58    guifg=#5f5f00

" Originalplus: ctermfg == guifg
"hi Type         ctermfg=94    guifg=#875f00
"hi PreProc      ctermfg=136   guifg=#af8700
"hi Special      ctermfg=88    guifg=#870000
"hi vimCommand   ctermfg=25    guifg=#005faf
"hi vimOption    ctermfg=58    guifg=#5f5f00


"hi Folded term=bold,underline ctermfg=11 ctermbg=8
"\gui=bold,underline guifg=#839496 guibg=#073642 guisp=#002b36

setlocal nonumber
" Custom: cterm != guifg
hi Type         ctermfg=100    guifg=#708000
hi PreProc      ctermfg=136    guifg=#af8700
hi Special      ctermfg=88     guifg=#a03000
hi Normal       ctermfg=245    guifg=#708294 guibg=#002636
hi vimCommand   ctermfg=27     guifg=#0070d0
hi vimOption    ctermfg=58     guifg=#5f5f00
"hi vimVar       ctermfg=None   guifg=#008070
hi vimCommentString ctermfg=None   guifg=#6060a0
"hi vimCommentString ctermfg=None   guifg=#586e75
"hi vimCommentString ctermfg=None   guifg=#7070C0
hi link vimVar Normal
hi clear Folded
hi Folded cterm=bold,underline ctermfg=11 ctermbg=8 guifg=#708294 guibg=#002c39 guisp=#002b36

" "highlight colors for vim help syntax($VIM/vimfiles/after/syntax/help.vim)"
" "25: DeepSkyBlue4(#005FAF), 66: PaleTurquoise4(#5F8787)"
" "89: DeepPink4(#87005F),    28: Green4(#008700)"
hi helpHeader       cterm=bold   ctermfg=25     gui=bold    guifg=#006FCF
hi helpSectionDelim              ctermfg=25     gui=None    guifg=#005FAF
hi helpExample                   ctermfg=66     gui=None    guifg=#5F8787
"hi helpNote         cterm=italic ctermfg=33     gui=italic  guifg=#875f87
hi helpNote         cterm=italic ctermfg=33     gui=italic  guifg=#903060
hi myhelpH1         cterm=bold   ctermfg=33     gui=bold    guifg=#007FEF
hi myhelpBold       cterm=bold   ctermfg=245    gui=bold
hi myhelpSpecial    cterm=bold   ctermfg=89     gui=bold    guifg=#87005F
hi helpWarning      cterm=bold   ctermfg=89     gui=bold    guifg=#87005F
hi myhelpeg         cterm=bold   ctermfg=28     gui=bold    guifg=#008f00    "fe801a orange
