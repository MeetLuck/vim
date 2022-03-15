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
        :EchoErrormsg au WinLeave Not Working 
    endif
endfunction

function! <sid>Setlocal__wordnet__()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    setlocal hidden
    setlocal signcolumn=no nonumber colorcolumn=0 textwidth=0
    setlocal nomodifiable
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
    autocmd WinLeave <buffer> exe bufwinnr('__wordnet__') ."wincmd c"
"   exe bufwinnr(s:fname) ."wincmd c"
"   let &statusline=s:statusline
    redraw!
    return
endfunction

function! <sid>Openwindow()
    " "save previouse winnr"
    let s:prevwinnr = winnr()
"   let s:statusline = &statusline
    " "create windows : botright 6 split __wordnet__"
    exe "silent botright " .s:winheight ." split __wordnet__"
    if s:prevwinnr == winnr()
        echohl Warningmsg
        echomsg "previous,current :" .s:prevwinnr ."," .winnr()
        echohl None
        let s:prevwinnr -= 1
    endif
    " "setlocal options"
    call <sid>Setlocal__wordnet__()
    setlocal list
    call <sid>Map__wordnet__()
"   setlocal statusline=
    setlocal statusline=%n(%{winnr()})
    setlocal statusline+=\ %f
    " "autocmd when leave __wordnet__ window"
    autocmd! * <buffer>
    autocmd WinLeave <buffer>  :call <sid>Quitwindow()
"   autocmd WinLeave <buffer> exe bufwinnr('__wordnet__') ."wincmd c"
    exe "resize" .s:winheight | redraw!
endfunction


"function! <sid>StatusLine()
"    let &statusline='%f'
"endfunction

function! <sid>Getword()
    let cword = substitute(expand("<cword>"),'\v^\s*(.{-})\s*$','\1','')
" TODO: strip whitespace, special character
    echohl Question | echomsg "word: " .cword | echohl None
"   if strlen(cword)=~' '
    if cword=~'[*$#@!~`;:?_]' || strlen(cword)<=1
        return -1
    else
        echohl Question | echo cword
        return cword
    endif
endfunction

function! <sid>Updatewindow()
    " "save buffer list to __ls__"
    setlocal modifiable
    exe "1read !wn " .s:searchstr " -over"
    " " clear  __wordnet__"
    " "move cursor at line 1"
    :0 put = s:searchstr
    :1
    setlocal nomodifiable
    redraw!
endfunction

function! <sid>Quitwindow()
    echomsg "prev, current: " .s:prevwinnr ."," .winnr()
    autocmd! * <buffer>
    exe s:prevwinnr ."wincmd w"
    exe bufwinnr('__wordnet__') ."wincmd c"
"   exe bufwinnr(s:fname) ."wincmd c"
    "let &statusline=s:statusline
    redraw!
endfunction
