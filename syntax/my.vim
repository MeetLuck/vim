"syntax clear
syntax match mySharp  /#/ contained conceal
syntax match myStar   /*/ contained conceal
syntax match myString1 /#[^*|#]\+#/ contains=mySharp
syntax match myString2 /*[^*|#]\+\*/ contains=myStart
syntax keyword myKeyword my his her
hi link myString1 myhelpH1
hi link myString2 ErrorMsg
hi link myKeyword Keyword
