" ==============================================================================
" Name:          ShowMarks
"if exists( "loaded_showmarks" )
"	finish
"endif
"let loaded_showmarks = 1

let s:allmarks = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.'`^<>[]{}()\""

" Commands
com! -nargs=0 ShowMarks  :call <sid>ShowMarks()

" AutoCommands: Only if ShowMarks is enabled
"aug ShowMarks
"	au!
"	autocmd CursorHold * call s:ShowMarks()
"aug END

" Highlighting: Setup some nice colours to show the mark positions.
hi default ShowMarksHLl ctermfg=darkblue ctermbg=None cterm=bold guifg=blue guibg=lightblue gui=bold
hi default ShowMarksHLu ctermfg=darkblue ctermbg=None cterm=bold guifg=blue guibg=lightblue gui=bold
hi default ShowMarksHLo ctermfg=darkblue ctermbg=None cterm=bold guifg=blue guibg=lightblue gui=bold
hi default ShowMarksHLm ctermfg=darkblue ctermbg=None cterm=bold guifg=blue guibg=lightblue gui=bold

" Function: GetMarkLine()
fun! s:GetMarkLine(mark)
	let bufnr,linenr,col,off = getpos(a:mark)
	" "local marks a-z , special marks"
	if bufnr == 0  | "local marks
		return linenr
	endif
	" "global marks A-Z0-9"
	if bufnr == bufnr('%')  | "global marks in the current buffer
		return linenr
	else bufnr != bufnr('%') | "global marks in the different buffer
		return -1
	endif
endf

" Function: NameOfMark()
" Returns: The name of the requested mark.
fun! s:Getid(mark)
	return char2nr(a:mark)
endf


" Function: ShowMarksSetup()
" Description: This function sets up the sign definitions for each mark.
" It uses the showmarks_textlower, showmarks_textupper and showmarks_textother
" variables to determine how to draw the mark.
function! s:ShowMarksSetup()
    for mark in split(s:allmarks,'\zs')
        let name = "Showmarks" .s:Getid(mark)
		if mark =~# '\l'
			let s:ShowMarksDLink{mark} = 'ShowMarksHLl'
        elseif mark =~#'\u'
			let s:ShowMarksDLink{mark} = 'ShowMarksHLu'
        else
			let s:ShowMarksDLink{mark} = 'ShowMarksHLo'
        endif
		" Define the sign with a unique highlight which will be linked when placed.
		exe 'sign define ShowMark'.name .' text='.mark .' texthl='.s:ShowMarksDLink{mark}
    endfor
endfunction

" Set things up
call s:ShowMarksSetup()


" Function: ShowMarks()
fun! s:ShowMarks()
    for mark in split(s:allmarks,'\zs')
        let id = s:Getid(mark)
		let name = "ShowMark" .id
		let marknr = s:GetMarkLine("'".mark)
		if marknr == 0
            continue | "nomarks is set
        elseif !exists('b:placed_'.name.'_line') | "mark is not placed YET
            exe 'sign place '.id .' name='.name .' line='.marknr .' buffer=' .winbufnr(0)
        elseif markline == b:placed_{name}_line
            continue | "same mark
        elseif markline != b:placed_{name}_line | "mark is on the different line
            exe 'sign unplace '.id .' buffer=' .winbufnr(0)
            exe 'sign place '.id .' name='.name .' line='.marknr .' buffer=' .winbufnr(0)
        endif
        let b:placed_{name}_line = marknr
    endfor
endfunction
