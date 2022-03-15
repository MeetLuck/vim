" ==============================================================================
" Name:        ShowMarks
" ==============================================================================

" Check if we should continue loading
if exists( "g:loaded_showmarks" )
    finish
endif
let g:loaded_showmarks = 1

" Mappings
noremap <leader>sm :call <sid>ShowMarks()<cr>
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
function! s:Getname(mark)
    return "Mark".s:Getid(a:mark)
endfunction
" Setup the sign definitions for each mark
function! s:ShowMarkSetup()
    for mark in split(s:allmarks,'\zs')
"       exe 'sign undefine ' .s:Getname(mark)
        exe 'sign define ' .s:Getname(mark).' text=`'.mark .' texthl=ShowMarksHL'
    endfor
endfunction



function! s:GetMarkline(mark)
    if line("'".a:mark) == 0    "no marks is set
        return -1
    endif
    if getpos("'".a:mark)[0]== 0 " local marks
        return line("'".a:mark)
    elseif getpos("'".a:mark)[0]==winbufnr(0) "global mark
        return line("'".a:mark)
    endif
endfunction

function! s:ShowMarks()
    call s:ShowMarkSetup()
"    s:allmarks = s:normalmarks
    echomsg 'in ShowMarks'
    exe 'sign unplace *' .' buffer=' .winbufnr(0)
    for mark in split(s:allmarks,'\zs')
"       let id = strlen(s:allmarks)*winbufnr(0) + stridx(s:allmarks,mark)
        "echomsg 'mark,id:' .mark ."," .id
        let markline = s:GetMarkline(mark)
        let id=s:Getid(mark)
        let name=s:Getname(mark)
        if markline == -1
            continue "Global mark is in another buffer
        endif
        if markline == 0 "no mark is set
            continue 
        else
            exe 'sign place '.id .' name='.name .' line='.markline .' buffer=' .winbufnr(0)
        endif
    endfor
endfunction
