"syntax clear
"
syntax match marksNumber    /\<\d\+\>/ contained
syntax match marksGlobal    /^[A-Z0.']\>/ contained
syntax region marksLine    start=/^/ end=/$/ contains=marksGlobal,marksNumber

"myBeginSection,myEndSection

hi link marksGlobal myhelpH1
hi link marksNumber Normal
hi link marksLine helpHeader
