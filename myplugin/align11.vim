if has('win32') 
    command! -buffer Reinstall :silent! exe "!del " . expand("~/.vim/plugin/") . "align*.vim"
                \| silent! exe "!copy " . expand("%") . " " . expand("~/.vim/plugin")
    command! -buffer Remove    :silent! exe "!del " . expand("~/.vim/plugin/") . "align*.vim"
    command! -buffer RemoveAll :silent! exe "!del " . expand("~/.vim/plugin/") . "*.*"
else
    command! -buffer Reinstall :exe "!rm -rf ~/.vim/plugin/align*.vim" 
                \|exe "!cp % ~/.vim/plugin"
endif

"if exists('g:loaded_align') |finish |endif

" "configure align"
let g:loaded_align = 1

"command! -nargs=? -range Align <line1>,<line2>call AlignSection('<args>')
command! -nargs=? -range -bang Align <line1>,<line2>call <sid>alignSection(<bang>0,'<args>')
vnoremap <silent> <Leader>a :Align<CR>

function! <sid>alignSection(bang,regex) range
    let extra = 1
    if a:bang
        let sep ='\s\w'
    elseif empty(a:regex)
        let sep = '='
    else
        let sep = a:regex
    endif
    let lines    = getline(a:firstline, a:lastline)
    let position = [ ]
    for line in lines
        call add(position, match(line, ''.sep)  )
    endfor
    let maxpos = max(position)
    call map(lines, '<sid>alignLine(v:val, sep, maxpos, extra)')
    call setline(a:firstline, lines)
endfunction

function! <sid>alignLine(line, sep, maxpos, extra)
    let m = matchlist(a:line, '\(.\{-}\) \{-}\('.a:sep.'.*\)')
    if empty(m)
        return a:line
    endif
    let spaces = repeat(' ', a:maxpos-1 - strlen(m[1]) + a:extra)
    return m[1] . spaces . m[2]
endfunction
