"RestoreScreenSize:

if !has("gui_running") | finish | endif
if exists("g:restore_screen") | finish | endif
let g:restore_screen = 1

function! <sid>ScreenFilename()
    if has('win32')
        return $HOME.'\.vimsize'
    else
        return $HOME.'/.vimsize'
    endif
endfunction

"Restore: window size (columns and lines) and position from values stored in .vimsize file.
" Must set font first so columns and lines are based on font size.
" "v:servername = GVIM2,GVIM1,GVIM"
" "[GVIM2,winpos,columns,lines]"
" "[GVIM1,winpos,columns,lines]"
" "[GVIM, winpos,columns,lines]"
 
function! <sid>RestoreScreen()
    echomsg 'restore screen'
    let f = <sid>ScreenFilename()
    if filereadable(f)
        for line in readfile(f)
            let sizepos = split(line)
            if len(sizepos) == 5 && sizepos[0] == v:servername
                echomsg 'vim instance: '. v:servername
                silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
                silent! execute "winpos ".sizepos[3] ." " .sizepos[4]
                redraw
                return
            endif
        endfor
    endif
endfunction

"Save: window size and position.
function! <sid>SaveScreen()
    let data = v:servername .' ' .&columns .' ' .&lines .' '
                \ .(getwinposx()<0?0:getwinposx()) .' '
                \ .(getwinposy()<0?0:getwinposy())
    let f = <sid>ScreenFilename()
    if filereadable(f)
        let lines = readfile(f)
        " "remove line with name v:servername"
        call filter(lines, "v:val !~ '^" . v:servername . "\\>'")
        call add(lines, data)
    else
        let lines = [data]
    endif
    call writefile(lines, f)
endfunction

augroup restore
autocmd!
autocmd VimEnter * call <sid>RestoreScreen()
autocmd VimLeavePre * call <sid>SaveScreen()
augroup end

" keep default value
let s:current_font = &guifont
noremap <expr> +        <sid>IncreaseFont(1)
noremap <expr> -        <sid>IncreaseFont(-1)
noremap <expr> <A-0>    <sid>ResetFont()

" Increase: fontsize+1
function! <sid>IncreaseFont(size)
    let fontsize = substitute(&guifont, '^.*:h\([^:]*\).*$', '\1', '')
    let fontsize += a:size
    let guifont = substitute(&guifont, ':h\([^:]*\)', ':h'.fontsize, '')
    let &guifont = guifont
    echohl WarningMsg | echomsg 'decrease fontsize '.fontsize | echohl None
endfunction

" Reset: guifont size
function! <sid>ResetFont()
    let &guifont = s:current_font
    let fontsize = substitute(&guifont, '^.*:h\([^:]*\).*$', '\1', '')
    echohl WarningMsg | echomsg 'reset fontsize '.fontsize | echohl None
endfunction

