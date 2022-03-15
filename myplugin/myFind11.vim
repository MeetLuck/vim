" MyFind: <leader><leader> to show  character that shows one time. 
" Syntax: edit  ~/.vim/syntax/buf.vim"
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

"Safe Guard: prevent reload script
"if exists('g:loaded_myFind') |finish |endif
"let g:loaded_myFind = 1
let g:clear = 0

function! <sid>find()
    " "get current columnr= col('.')-1"
    " "get last columnr= col('$') - 1"
    if g:clear
        call clearmatches()
        let g:clear = !g:clear
        return
    endif

    let g:clear = !g:clear
    hi clear myFind
    hi myFind gui=bold,underline,reverse
    let onechars = { }
    let charpos = { }
    let linenr = line('.')
    let curcol = col('.')
    let endcol = col('$')-1
    let line = split(getline('.'),'\zs')
    let curline = line[curcol:]
    echomsg 'curcol -> ' curcol
    echomsg 'curline -> ' curline
    for col in range(curcol,endcol-1)
        let char = line[col]
        "echomsg 'curchar -> ' char
        " XXX  !~ 'pattern' NOT double quote
        if count(curline,char) > 0 && char !~ '\s'
            call matchaddpos("myFind",[[linenr,col+1]])
            if !has_key(onechars,char)
                let onechars[char] = [col]
            else
                call add(onechars[char],col)
            endif
        endif
    endfor
    redraw!
    echomsg 'onechars -> ' onechars
    redraw!
endfunction

"User Mapping:
nnoremap <silent> <leader><leader>  :call <sid>find()<CR>
