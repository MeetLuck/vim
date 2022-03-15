"OmniCompletion:
set completeopt=longest,menuone
"function! InsertTabWrapper()
"    let col = col('.') - 1
"    echomsg 'pressed key: ' .getline('.')[col-1]
"    if pumvisible()
"        return "\<C-X>\<C-O>"
"    else
"        return "\<C-N>\<C-P>"
"    end
"    if !col || getline('.')[col-1] !~ '\k'
"        echomsg 'sorry'
"        return "\<TAB>"
"    else
"        echomsg 'lineno: ' .getline('.')[col-1]
"        if pumvisible()
"            return "\<C-N>"
"        else
"            return "\<C-N>\<C-P>"
"        end
"    endif
"endfunction

"inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
"inoremap <C-Space> <c-r>=InsertTabWrapper()<cr>
