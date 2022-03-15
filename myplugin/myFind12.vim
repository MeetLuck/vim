" MyFind: <leader><leader> to show  character that shows one time. 
" Syntax: edit  ~/.vim/syntax/buf.vim"
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
    if g:clear
        call clearmatches()
        let g:clear = !g:clear
        return
    endif

    let g:clear = !g:clear
    hi clear myFind
    hi myFind gui=bold,underline,reverse
    " "get current columnr= col('.')-1"
    let colnr = col('.')
    " "get last columnr= col('$') - 1"
    let endcol = col('$')-1
    let onechars = { }
    let charpos = { }
    let linenr = line('.')
    let line = split(getline('.'),'\zs')
    let curline = line[colnr:]
    let char = line[colnr-1]
    "echomsg 'colnr -> ' colnr
    "echomsg 'curline -> ' curline
    for col in range(colnr,endcol-1)
        if char == line[col]
        "echomsg 'curchar -> ' char
        " XXX  !~ 'pattern' NOT double quote
        "if count(curline,char) > 0 && char !~ '\s'
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
