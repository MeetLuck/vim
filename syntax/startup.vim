"Syntax: __startup__


"syntax region startupSession start='astart'ms=e+1 end='aend'me=s-1
"syntax clear
syntax sync fromstart
syntax region startupCommand      start=/press/ end=/$/ contains=startupSource,startupEnter
syntax match  startupLastSession  /\%4l.*$/ contained 
syntax region startupSession   matchgroup=startupSessionHeader  start=/:Session/ end=/^\s*$/ contains=startupLastSession
syntax region startupOldfiles  matchgroup=startupOldfilesHeader start=/:oldfiles/ end=/^\s*$/
syntax region startupLastFile  matchgroup=startupLastfileHeader start=/:'0/ end=/^\s*$/
syntax region startupLs        matchgroup=startupLsHeader       start=/:ls/ end=/^\s*$/
syntax region startupSource    contained matchgroup=startupS start=/\<s\zeource/ matchgroup=startupCommand end=/ource\>/
syntax match  startupEnter     contained '<CR>'

hi startupCommand           ctermfg=27 gui=italic guifg=#808000
hi startupFirstChar         ctermfg=27 gui=bold   guifg=#d0a000
hi startupLastSession       ctermfg=27 gui=bold guifg=#0070f0 
hi startupSessionHeader     cterm=bold ctermfg=27 gui=bold guifg=#00a5ff 
hi startupOldfilesHeader    cterm=bold ctermfg=27 gui=bold guifg=#00c000
hi startupLastfileHeader    cterm=bold ctermfg=27 gui=bold guifg=#00c000
hi startupLsHeader          cterm=bold ctermfg=27 gui=bold guifg=#95c500 
hi startupSession           ctermfg=27 guifg=#0090d0 
hi startupOldfiles          ctermfg=27 guifg=#00a000 
hi startupLastFile          ctermfg=27 guifg=#00a000 
hi startupLs                ctermfg=27 guifg=#609000
hi link startupS startupFirstChar
hi link startupEnter startupFirstChar
"hi link startupSession startupSessionBody
"hi link startupOldfiles startupOldfilesBody 
"hi link startupLs startupLsBody
