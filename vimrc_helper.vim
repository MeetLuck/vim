" Helper:
" " Mark  -> hi mark1, Mark2  -> hi mark2,  Mark3  -> hi mark3 "
hi mark1 cterm=inverse ctermfg=1 gui=italic guifg=red guibg=black
hi mark2 cterm=inverse ctermfg=2 gui=italic guifg=orange guibg=black
hi mark3 cterm=inverse ctermfg=3 gui=italic guifg=yellow guibg=black

" "command! -nargs=1 Mark3 :3match mark3 /\%'<args>/"
command! -nargs=0 Mark  :match  mark1 /\%'a/
command! -nargs=0 Mark2 :2match mark2 /\%'b/
command! -nargs=0 Mark3 :3match mark3 /\%'c/
