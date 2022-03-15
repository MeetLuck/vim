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
    "Clear Match: clear matches
    if g:clear
        call clearmatches()
        let g:clear = !g:clear
        return
    endif

    let g:clear = !g:clear
    "Syntax For Find:
    hi clear myFind
    hi myFind gui=bold,underline,reverse
    " "get current columnr= col('.')-1"
    let startcol = col('.')
    " "get last columnr= col('$') - 1"
    let endcol = col('$')-1
    let charPosition = { }
    let linenr = line('.')
    let linelist = split(getline('.'),'\zs')
    let curlinelist = linelist[startcol:]
    let char = linelist[startcol-1]
    "Mach At Cursor:
    call matchaddpos("myFind",[[linenr,startcol]])
    for col in range(startcol,endcol-1)
        if char == linelist[col]
            call matchaddpos("myFind",[[linenr,col+1]])
            if !has_key(charPosition,char)
                let charPosition[char] = [col]
            else
                call add(charPosition[char],col)
            endif
        endif
    endfor
    redraw!
    call mywindow#echoWarningMsg('charPosition -> '.string(charPosition))
    "call mywindow#notification('charPosition -> '.string(charPosition))
    "redraw! => disappear messages
endfunction

"User Mapping:
nnoremap <silent> <leader><leader>  :call <sid>find()<CR>
