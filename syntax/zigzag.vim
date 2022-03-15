" "syntax file for filetype: .zigzag"
"
"hi clear
syntax region lsUsage matchgroup=lsTitle start=/\v^\s+\[BufEx]/ end=/$/ 
            \ contains=lsEdit,lsSplit,lsVsplit,lsTab,lsDelete,lsQuit
syntax region lsEdit   contained matchgroup=lsE start=/\<e/ matchgroup=lsUsage end=/dit\>/ 
syntax region lsSplit  contained matchgroup=lsS start=/\<s/ matchgroup=lsUsage end=/plit\>/ 
syntax region lsVsplit contained matchgroup=lsE start=/\<v/ matchgroup=lsUsage end=/split\>/ 
syntax region lsTab    contained matchgroup=lsE start=/\<t/ matchgroup=lsUsage end=/ab\>/ 
syntax region lsDelete contained matchgroup=lsE start=/\<d/ matchgroup=lsUsage end=/elete\>/ 
syntax region lsQuit   contained matchgroup=lsE start=/\<q/ matchgroup=lsUsage end=/uit\>/ 

syntax region zzStart start=/^start/ end=/$/ 
syntax region zzWaves start=/^waves/ end=/$/ 
syntax region zzLine start=/^-/ end=/$/
syntax region zzDoubleLine start=/^=/ end=/$/
"hi Normal ctermfg=242
hi zzStart cterm=bold ctermfg=33
hi zzWaves cterm=bold ctermfg=33
hi zzLine cterm=None ctermfg=29
"hi clear zzDoubleLine
hi link zzDoubleLine zzLine
"hi zzDoubleLine cterm=bold ctermfg=245
hi link lsUsage Comment
hi lsFirstletter cterm=underline ctermfg=39
hi link lsE lsFirstletter
hi link lsS lsFirstletter
hi link lsV lsFirstletter
hi link lsT lsFirstletter
hi link lsD lsFirstletter
hi link lsQ lsFirstletter
