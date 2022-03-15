" Word Net Dictionary: 
" "wn searchstr -over"
" "for syntax edit  ~/.vim/syntax/wordnet.vim"
"!rm -rf ~/.vim/plugin/SearchWordNet*
"!cp % ~/.vim/plugin
 
command! -buffer Reinstall 
            \:exe "!rm -rf ~/.vim/plugin/SearchWordNet*.vim" 
            \|exe "!cp % ~/.vim/plugin"
command! -buffer -nargs=1 EchoErrormsg 
            \:echohl Errormsg   |echomsg "<args>"|echohl None
command! -buffer -nargs=1 EchoWarningmsg 
            \:echohl Warningmsg |echomsg "<args>"|echohl None

if exists('g:loaded_searchwordnet')
    finish
endif
let g:loaded_searchwordnet = 1

nnoremap <leader>wn :call <sid>SearchWordNet()<cr>

" "configure SearchWordNet"
let s:winheight = 10
let s:fname = '__wordnet__'

" "SearchWordNet function"
function! <sid>SearchWordNet()
    let s:searchstr = <sid>Getword()
    if  s:searchstr == -1
        EchoWarningmsg invalid word or empty
        return
    endif
    if bufnr(s:fname) == -1 || bufwinnr(s:fname) == -1
        call <sid>Openwindow()
        call <sid>Updatewindow()
    elseif winnr() != bufwinnr(s:fname)
        :EchoWarningmsg current window is not __word__
        exe bufwinnr('__word__') ."wincmd w"
        call <sid>Updatewindow()
    endif
endfunction

function! <sid>Setlocal__wordnet__()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile hidden
    setlocal signcolumn=no nonumber colorcolumn=0 textwidth=0
    setlocal nomodifiable nolist nomore
    setlocal filetype=wordnet
    setlocal cursorline
    "edit "~/.vim/syntax/wordnet.vim"
endfunction

function! <sid>Map__wordnet__()
    mapclear <buffer>
    nnoremap <buffer>  q       :call <sid>Quitwindow()<cr>
    nnoremap <buffer>  <ESC>   :call <sid>Quitwindow()<cr>
    nnoremap <buffer>  :       :call <sid>Quitwindow()<cr>:
    let @/ = 'Overview of'
    setlocal nohlsearch
    syn match overviewHeader      /^Overview of .\+/
    syn match definitionEntry  /\v^[0-9]+\. .+$/ contains=numberedList,word
    syn match numberedList  /\v^[0-9]+\. / contained
    syn match word  /\v([0-9]+\.[0-9\(\) ]*)@<=[^-]+/ contained
    hi link overviewHeader Title
    hi link numberedList Operator
    hi def word term=bold cterm=bold gui=bold
endfunction

function! <sid>Quitwindow()
    echomsg "prev, current: " .s:prevwinnr ."," .winnr()
    exe s:prevwinnr ."wincmd w"
endfunction

function! <sid>Openwindow()
    " "save previouse winnr"
    let s:prevwinnr = winnr()
    " "create windows : botright 6 split __wordnet__"
    exe "silent botright " .s:winheight ." split __wordnet__"
    " "setlocal options"
    call <sid>Setlocal__wordnet__()
    call <sid>Map__wordnet__()
    " "autocmd when leave __wordnet__ window"
    autocmd! * <buffer>
    autocmd BufLeave <buffer> exe bufwinnr('__wordnet__') ."wincmd c"
endfunction

function! <sid>Getword()
    let cword = expand("<cword>")
    if cword =~ '[*$#@!~`;:?_]' || strlen(cword) <= 1
        return -1
    else
        return cword
    endif
endfunction

function! <sid>Updatewindow()
    " "save buffer list to __ls__"
    setlocal modifiable
    silent exe "0r!wn " .s:searchstr " -over"
    " "move cursor at line 1"
    :1
    setlocal nomodifiable
    exe "resize" .s:winheight | redraw!
    redraw!
endfunction

function! <sid>Quitwindow()
    echomsg "prev, current: " .s:prevwinnr ."," .winnr()
    autocmd! * <buffer>
    exe s:prevwinnr ."wincmd w"
    exe bufwinnr('__wordnet__') ."wincmd c"
    redraw!
endfunction
