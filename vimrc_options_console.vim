
"set rtp = 
"set rtp +=C:\Program Files\Vim\vim82
set rtp +=$HOME\.vim
set rtp +=$HOME\.vim\after
"NOTE rtp -=<NOSPACE>/path/
set rtp -=$HOME\vimfiles
set rtp -=$HOME\vimfiles\after

execute pathogen#infect()
