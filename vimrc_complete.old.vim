"OmniCompletion:
set completeopt=longest,menuone
"set omnifunc=syntaxcomplete#Complete
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
"autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"autocmd FileType c set omnifunc=ccomplete#Complete

inoremap <C-X>l <C-x><C-L>
inoremap <expr> j pumvisible()? "\<C-n>":"j"
inoremap <expr> k pumvisible()? "\<C-p>":"k"
inoremap <expr> <C-x><C-o> pumvisible()? '<C-n>':
            \'<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : "\<lt>Esc>a"<CR>'
inoremap <expr> <C-x><C-v> pumvisible()? '<C-n>':
            \'<C-x><C-v><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : "\<lt>Esc>a"<CR>'
" WARNING: recursive map
imap <expr> <C-Space> <sid>CleverComplete()
inoremap <expr> . <sid>DotOmniComplete()

function! <sid>CleverComplete()
    let curChar = strpart(getline('.'), col('.')-1, 1)
    if &filetype =='vim'
        echomsg 'command-line completion' | return "\<C-X>\<C-V>"
    elseif match(curChar, '\/') != -1  "if hasSlash
        echomsg 'filename completion'     | return "\<C-X>\<C-F>"
    elseif &omnifunc != '' 
        echomsg 'omni completion'         | return "\<C-X>\<C-O>"
    elseif &dictionary != ''
        echomsg 'dictionary completion'   | return "\<C-X>\<C-K>"
"   elseif &complete != ''
"       echomsg 'keyword completion'      | return "\<C-N>"
    else
        echomsg 'current file completion' | return "\<C-X>\<C-N>"
     endif
endfunction

function! <sid>DotOmniComplete()
    " "col-2 : a-zA-Z_\d or quotes or ) or right }"
    " "col-1 : current cursor is dot(.)"
    let previousChar = strpart(getline('.'), col('.')-2, 1)
    let tmp = &iskeyword
    set iskeyword +=\",',),],},#
    echomsg 'inside DotOmniComplete'
    if previousChar=~'\k' && &omnifunc !=''
        let &iskeyword = tmp
        return ".\<C-X>\<C-O>"
    else
        echomsg previousChar." is not keyword"
        let &iskeyword = tmp
        return '.'
    endif
endfunction

