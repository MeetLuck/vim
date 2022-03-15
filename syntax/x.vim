"syntax region xPreProc start=/^#/ end=/$/ contains=xLineContinue
"syntax match xLineContinue "\\$" contained

syntax region xPreProc start=/^#/ end=/$/ contains=xLineContinue, xPreProcEnd
"syntax match xPreProcEnd /end$/ contained
syntax match xPreProcEnd excludenl /end$/ contained
syntax match xLineContinue "\\$" contained
hi link xPreProc PreProc
hi link xLineContinue Special
hi link xPreProcEnd Error
