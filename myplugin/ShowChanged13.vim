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
command! -nargs=1 EchoMarkline :echo <sid>GetMarkline(<f-args>)

" AutoCommands: This will check the marks and set the signs
"autocmd CursorHold * call s:ShowMarks()

" Highlighting: Setup some nice colours to show the mark position.
hi default ShowMarksHL cterm=bold ctermfg=22 ctermbg=None

let s:lowermarks    = "abcdefghijklmnopqrstuvwxyz"
let s:uppermarks    = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
let s:numberedmarks = "0123456789"
let s:specialmarks  = "<>[](){}'`\"^."
let s:allmarks = s:lowermarks .s:uppermarks .s:numberedmarks .s:specialmarks
let s:includemarks = s:lowermarks .s:uppermarks ."[<>`\"^."
 
function! <sid>Getid(mark)
    return char2nr(a:mark)
endfunction

function! <sid>Getname(id)
    return "Mark" .a:id
endfunction

" "define sign for all marks"
function! <sid>DefineSign()
    for mark in split(s:allmarks,'\zs')
        let id = <sid>Getid(mark)
        exe 'sign define ' .<sid>Getname(id).' text=`'.mark .' texthl=ShowMarksHL'
    endfor
endfunction

function! <sid>GetMarkline(mark)
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

" "place marks for just included"
function! <sid>PlaceMarks()
    for mark in split(s:allmarks,'\zs')
        let id = <sid>Getid(mark)
        let name = <sid>Getname(id)
        " "just unplace a mark before placing it"
        exe 'sign unplace ' .id' buffer=' .winbufnr(0)
        if s:includemarks !~ mark
            continue
        endif
        " "place mark for ONLY included marks"
        let markline = <sid>GetMarkline(mark)
        if markline == -1
            continue "no mark is set
        elseif markline == -2
            continue "golbal mark NOT in current buffer
        else
            exe 'sign place '.id .' name='.name .' line='.markline .' buffer=' .winbufnr(0)
        endif
    endfor
endfunction
