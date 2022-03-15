" Syntax File For PopUp Window:
" Filetype: popup
" orange color : CB4B16
" blue color : 268BD2
syntax  clear
syntax match mypopupSharp contained "#" conceal
syntax match mypopupNormal   "\\\@<!#[^"*|#]\+#" contains=mypopupSharp
syntax keyword mypopupRtp     runtimepath
syntax keyword mypopupmarks    marks
