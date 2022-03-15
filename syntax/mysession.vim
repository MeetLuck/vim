" Syntaxfile: for __session__"
"
syntax region mksUsage start=/Usage/ end=/$/ 
            \ contains=mksEdit,mksSplit,mksVsplit,mksTab,mksDelete,mksQuit
syntax region mksSplit  contained matchgroup=mksS start=/\<l/ matchgroup=mksUsage end=/oad\>/ 
syntax region mksVsplit contained matchgroup=mksE start=/\<s/ matchgroup=mksUsage end=/ave\>/ 
syntax region mksDelete contained matchgroup=mksE start=/\<d/ matchgroup=mksUsage end=/elete\>/ 
syntax region mksQuit   contained matchgroup=mksE start=/\<q/ matchgroup=mksUsage end=/uit\>/ 

hi link mksUsage Comment
"
"
"cterm33: DodgerBlue1 #0087ff
hi mksFirstletter cterm=underline ctermfg=27 gui=underline guifg=#0087ff
hi link mksE mksFirstletter
hi link mksS mksFirstletter
hi link mksV mksFirstletter
hi link mksT mksFirstletter
hi link mksD mksFirstletter
hi link mksQ mksFirstletter
