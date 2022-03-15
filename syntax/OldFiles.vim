" "syntax file for filetype: __old__"
"
syntax region oldUsage matchgroup=oldTitle start=/\v^\s+\[OldFiles]/ end=/$/ 
            \ contains=oldEdit,oldSplit,oldVsplit,oldTab,oldDelete,oldQuit
syntax region oldEdit   contained matchgroup=oldE start=/\<e/ matchgroup=oldUsage end=/dit\>/ 
syntax region oldSplit  contained matchgroup=oldS start=/\<s/ matchgroup=oldUsage end=/plit\>/ 
syntax region oldVsplit contained matchgroup=oldE start=/\<v/ matchgroup=oldUsage end=/split\>/ 
syntax region oldTab    contained matchgroup=oldE start=/\<t/ matchgroup=oldUsage end=/ab\>/ 
syntax region oldDelete contained matchgroup=oldE start=/\<d/ matchgroup=oldUsage end=/elete\>/ 
syntax region oldQuit   contained matchgroup=oldE start=/\<q/ matchgroup=oldUsage end=/uit\>/ 

hi link oldUsage Comment
hi oldTitle cterm=bold ctermfg=33
hi oldFirstletter cterm=underline ctermfg=39
hi link oldE oldFirstletter
hi link oldS oldFirstletter
hi link oldV oldFirstletter
hi link oldT oldFirstletter
hi link oldD oldFirstletter
hi link oldQ oldFirstletter
