"NumberColumn:
hi clear LineNr
"hi LineNr ctermfg=238 ctermbg=None guifg=#445566 guibg=#002b36
hi LineNr     guifg=#405060 guibg=#000e23
"CursorLine:
hi clear CursorLine
hi CursorLine gui=None guibg=#00152a
"Fold:
hi clear FoldColumn
hi clear Folded
hi Folded guifg=#2080DB
hi FoldColumn guifg=#2080dd
"ColorColumn:
hi clear ColorColumn
"hi ColorColumn guibg=#001028

" Custom: cterm != guifg
hi clear Normal
hi  Normal            ctermfg=245           guifg=#708294  guibg=#001025
hi  clear             VertSplit
hi  VertSplit         guifg=#001025
"hi  Normal            ctermfg=245           guifg=#708294  guibg=#001025
hi  Type              ctermfg=100           guifg=#708000
hi  PreProc           ctermfg=136           guifg=#af8700
hi  Special           ctermfg=88            guifg=#a03000
hi  Identifier        cterm=bold            ctermfg=11     gui=bold       guifg=#268bd2
hi  Notification      ctermfg=245           gui=bold       guifg=gray     guibg=#003f4f
hi  vimCommand        ctermfg=27            guifg=#0070d0
hi  vimOption         ctermfg=58            guifg=#5f5f00
"hi  vimLineComment    ctermfg=None          guifg=#657b83
hi  vimLineComment    ctermfg=None          gui=italic guifg=#405060
hi  vimCommentString  ctermfg=None          guifg=#6060a0
hi  Search            cterm=reverse         ctermfg=0      ctermbg=14     gui=bold       guifg=#708294  guibg=#003656
"hi  Folded            cterm=bold,underline  ctermfg=11     ctermbg=8      guifg=#708294  guibg=#002b39  guisp=#002b36
hi  link              vimVar                Normal

" For Help File:
" "highlight colors for vim help syntax($VIM/vimfiles/after/syntax/help.vim)"
hi   helpHeader        cterm=italic  ctermfg=25   gui=italic     guifg=#006FCF
hi   helpSectionDelim  ctermfg=25    gui=None     guifg=#005FAF
hi   helpExample       ctermfg=66    gui=None     guifg=#5F8787
"hi  helpNote          cterm=italic  ctermfg=33   gui=italic     guifg=#875f87
hi   helpNote          cterm=italic  ctermfg=33   gui=italic     guifg=#903060
hi   myhelpH1          cterm=bold    ctermfg=33   gui=bold       guifg=#007FEF
hi   myhelpBold        cterm=bold    ctermfg=245  gui=bold       guifg=#7F8F9F
hi   myhelpSpecial     cterm=bold    ctermfg=89   gui=bold       guifg=#87005F
hi   helpWarning       cterm=bold    ctermfg=89   gui=bold       guifg=#87005F
hi   myhelpeg          cterm=bold    ctermfg=28   gui=bold       guifg=#008f00  "fe801a  orange
hi def link myhelpTODO TODO
hi link myhelpVIM myhelpBold

"PopUp Window:
hi  popupNormal       gui=None      guifg=#268BD2 guibg=#002a3a
hi  popupTitle        gui=bold      guifg=#CB4B16 guibg=#002f3f
hi  popupRtp          gui=None      guifg=red guibg=#002a3a
