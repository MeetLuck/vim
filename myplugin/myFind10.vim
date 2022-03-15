" MyExplorer: ls and oldfiles and shortcut and session mananger
" Syntax: edit  ~/.vim/syntax/buf.vim"
" Syntax: edit  ~/.vim/syntax/mysession.vim"
" Library: ~/.vim/autoload/mywindow.vim
" Library: ~/.vim/autoload/mylib.vim
" Version: v16 -> added autocmd CmdlineEnter
"              -> remove mapping :
 
if has('win32') 
    command! -buffer Reinstall :silent! exe "!del " . expand("~/.vim/plugin/") . "myFind*.vim"
                             \| silent! exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/myFind*.vim" 
endif
"Safe Guard:
"if exists('g:loaded_myFind') |finish |endif
"let g:loaded_myFind = 1

function! <sid>find()
    " "get current columnr= col('.')-1"
    " "get last columnr= col('$') - 1"
    call clearmatches()
    let charpos = {}
    let char = nr2char(getchar())
    let curcol = col('.')
    let eol    = col('$')-1
    echomsg 'curcol,eol ==>' curcol ',' eol
    let line = split(getline('.'),'\zs')
    for col in range(curcol,eol-1)
        "echomsg 'col:' col
        if char == line[col]
            "echomsg 'col->' col
            let match_pos = matchaddpos("ErrorMsg",[[line('.'),col+1]])
            if !has_key(charpos,char)
                let charpos[char] = [col]
            else
                let charpos[char] = add(charpos[char],col)
            endif
        endif
    endfor
    "call matchadd("Error",char)
    redraw!
    echomsg 'charpos -> ' charpos
    sleep 2000m
    call clearmatches()
    redraw
    return 'f'

endfunction


"User Mapping:
nnoremap <silent> <leader><leader>  :call <sid>find()<CR>
