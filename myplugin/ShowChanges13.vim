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
hi default ShowMarksHL cterm=bold ctermfg=22 ctermbg=None
hi lastChange cterm=underline
hi lastInsert ctermbg=130
hi lastYank     ctermbg=97
hi lastSelection ctermbg=103
hi lastJump ctermbg=109
match lastInsert /\%'\^/
match lastChange /\%'\./

let s:lowermarks="abcdefghijklmnopqrstuvwxyz"
let s:uppermarks="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
let s:numberedmarks="0123456789"
let s:specialmarks = "<>[](){}'`\"^."
let s:allmarks = s:lowermarks .s:uppermarks .s:numberedmarks .s:specialmarks
"let s:includemarks = s:lowermarks .s:uppermarks ."[<>`\"^."
let s:includemarks = "[<>`\"^."
 
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
        let id=s:Getid(mark)
        let name=s:Getname(id)
        " "unplace all marks for the current buffer"
        exe 'sign unplace ' .id' buffer=' .winbufnr(0)
        if s:includemarks !~ mark
            continue
        endif
        " "place mark for included"
        let markline = s:GetMarkline(mark)
        if markline == -1
            continue "no mark is set
        elseif markline == -2
            continue "golbal mark NOT in current buffer
        else
            exe 'sign place '.id .' name='.name .' line='.markline .' buffer=' .winbufnr(0)
        endif
    endfor
endfunction
