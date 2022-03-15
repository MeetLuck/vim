" "syntax file for filetype: __buffer__"
"
syntax region bufUsage start=/Usage/ end=/$/ 
            \ contains=bufEdit,bufSplit,bufVsplit,bufTab,bufDelete,bufQuit
syntax region bufEdit   contained matchgroup=bufE start=/\<e/ matchgroup=bufUsage end=/dit\>/ 
syntax region bufSplit  contained matchgroup=bufS start=/\<s/ matchgroup=bufUsage end=/plit\>/ 
syntax region bufVsplit contained matchgroup=bufE start=/\<v/ matchgroup=bufUsage end=/split\>/ 
syntax region bufTab    contained matchgroup=bufE start=/\<t/ matchgroup=bufUsage end=/ab\>/ 
syntax region bufDelete contained matchgroup=bufE start=/\<d/ matchgroup=bufUsage end=/elete\>/ 
syntax region bufQuit   contained matchgroup=bufE start=/\<q/ matchgroup=bufUsage end=/uit\>/ 

hi link bufUsage Comment
"
"
"cterm33: DodgerBlue1 #0087ff
hi bufFirstletter cterm=underline ctermfg=27 gui=underline guifg=#0087ff
hi link bufE bufFirstletter
hi link bufS bufFirstletter
hi link bufV bufFirstletter
hi link bufT bufFirstletter
hi link bufD bufFirstletter
hi link bufQ bufFirstletter
