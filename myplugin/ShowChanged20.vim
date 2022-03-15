" ==============================================================================
" Name:          ShowMarks
"if exists( "loaded_showmarks" )
"	finish
"endif
"let loaded_showmarks = 1

let s:allmarks = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.'`^<>\""

" Commands
com! -nargs=0 ShowMarks  :call <sid>ShowMarks()
noremap <leader>sm :call <sid>ShowMarks()<cr>

" AutoCommands: Only if ShowMarks is enabled
"aug ShowMarks
"	au!
"	autocmd CursorHold * call s:ShowMarks()
"aug END
"

" Highlighting: Setup some nice colours to show the mark positions.
hi default ShowMarksHLl ctermfg=12 ctermbg=None cterm=bold
hi default ShowMarksHLu ctermfg=darkgreen ctermbg=None cterm=bold
hi default ShowMarksHLo ctermfg=3 ctermbg=None cterm=bold
hi default ShowMarksHLm ctermfg=darkblue ctermbg=None cterm=bold


" Function: NameOfMark()
" Returns: The name of the requested mark.
fun! s:Getid(mark)
	return char2nr(a:mark)
endf


" Function: ShowMarksSetup()
function! s:ShowMarksSetup()
    for mark in split(s:allmarks,'\zs')
        let name = "ShowMark" .s:Getid(mark)
		if mark =~# '\l'
			let s:ShowMarksDLink{name} = 'ShowMarksHLl'
        elseif mark =~#'\u'
			let s:ShowMarksDLink{name} = 'ShowMarksHLu'
        else
			let s:ShowMarksDLink{name} = 'ShowMarksHLo'
        endif
		" Define the sign with a unique highlight which will be linked when placed.
		exe 'sign define '.name .' text='.mark .' texthl='.s:ShowMarksDLink{name}
    endfor
endfunction

" Set things up
call s:ShowMarksSetup()

" Function: GetMarkLine()
function! s:GetMarkLine(mark)
    let [bufnumber,linenr ;rest] = getpos(a:mark)
    if bufnumber == 0
        return linenr
    endif
    if bufnumber == bufnr('%')
        return linenr
    else
        return -1
    endif
endfunction

" Function: ShowMarks()
fun! s:ShowMarks()
    for mark in split(s:allmarks,'\zs')
        let id = s:Getid(mark)
		let name = "ShowMark" .id
		let marklinenr = s:GetMarkLine("'".mark)
"       exe 'sign unplace '.id .' buffer=' .winbufnr(0)
		if marklinenr == 0
            continue | "nomarks is set ,but unplace if sign placed
        elseif !exists('b:placed_'.name.'_line') | "mark is not placed YET
            exe 'sign place '.id .' name='.name .' line='.marklinenr .' buffer=' .winbufnr(0)
        elseif marklinenr == b:placed_{name}_line
            continue | "same mark
        elseif marklinenr != b:placed_{name}_line | "mark is on the different line
            exe 'sign unplace '.id .' buffer=' .winbufnr(0)
            exe 'sign place '.id .' name='.name .' line='.marklinenr .' buffer=' .winbufnr(0)
        endif
        let b:placed_{name}_line = marklinenr
    endfor
endfunction
