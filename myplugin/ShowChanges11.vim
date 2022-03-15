" ==============================================================================
" Name:        ShowMarks
" ==============================================================================

" Check if we should continue loading
if exists( "g:loaded_showmarks" )
    finish
endif
let g:loaded_showmarks = 1

" Mappings
noremap <leader>pm :call <sid>PlaceMarks()<cr>
command! -nargs=1 EchoMarkline :echo s:GetMarkline(<f-args>)

" AutoCommands: This will check the marks and set the signs
"autocmd CursorHold * call s:ShowMarks()

" Highlighting: Setup some nice colours to show the mark position.
hi default ShowMarksHL cterm=bold ctermfg=22 ctermbg=None

let s:normalmarks="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
let s:specialmarks = "<>[]`\"^."
let s:allmarks = s:normalmarks . s:specialmarks
 
function! s:Getid(mark)
    return char2nr(a:mark)
endfunction

function! s:Getname(id)
    return "Mark" .a:id
endfunction

" Setup the sign definitions for each mark
function! <sid>DefineSign()
    for mark in split(s:allmarks,'\zs')
        let id = s:Getid(mark)
        exe 'sign define ' .s:Getname(id).' text=`'.mark .' texthl=ShowMarksHL'
    endfor
endfunction

function! s:GetMarkline(mark)
    if line("'".a:mark) == 0   "mark NOT in the list :marks
        return -1
    endif
    if getpos("'".a:mark)[0]==0 " local mark
        return line("'".a:mark)
    elseif getpos("'".a:mark)[0]==winbufnr(0) "global mark in current buffer
        return line("'".a:mark)
    elseif getpos("'".a:mark)[0]!=winbufnr(0) "global mark NOT in current buffer
        return -2
    endif
endfunction

call <sid>DefineSign()

function! <sid>PlaceMarks()
    for mark in split(s:allmarks,'\zs')
        let markline = s:GetMarkline(mark)
        let id=s:Getid(mark)
        let name=s:Getname(id)
        exe 'sign unplace ' .id' buffer=' .winbufnr(0)
        if markline == -1
            continue "no mark is set
        elseif markline == -2
            continue "golbal mark NOT in current buffer
        else
            exe 'sign place '.id .' name='.name .' line='.markline .' buffer=' .winbufnr(0)
        endif
    endfor
endfunction
