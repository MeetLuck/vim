:syntax match myString /'[^']*'/ contains=myWord, myVim
:syntax match myWord   /\<[a-z]*\>/ contained
:syntax match myVim    /\<vim\>/ transparent contained contains=NONE
:hi link myString String
:hi link myWord   Comment
