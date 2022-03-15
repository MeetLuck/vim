" ==============================================================================
" Check if we should continue loading

if exists( "loaded_showmarks" )
	finish
endif
let loaded_showmarks = 1

" All possible mark characters.(ShowMarksPlaceMark requires [a-z] to be first)
let s:allmarks = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789[]<>`'\"^.(){}"
let s:maxmarks = strlen(s:allmarks)

" Options: Set up some nice defaults
if !exists('g:showmarks_enable')
	let g:showmarks_enable = 1
endif

" Commands
com! -nargs=0 ShowMarks		:silent call <sid>ShowMarks()
com! -nargs=0 ShowMarksToggle :silent call <sid>ShowMarksToggle()
com! -nargs=0 ShowMarksClearAll :silent call <sid>ShowMarksClearAll()

" Mappings
noremap <leader>mt :ShowMarksToggle<cr>
noremap <leader>ma :ShowMarksClearAll<cr>
noremap <unique> <script> \sm m
noremap <silent> m :exe 'norm \sm'.nr2char(getchar())<bar>call <sid>ShowMarks()<CR>

" AutoCommands: Only if ShowMarks is enabled
if g:showmarks_enable == 1
	aug ShowMarks
		au!
		autocmd CursorHold * call s:ShowMarks()
	aug END
endif

" Highlighting: Setup some nice colours to show the mark positions.
hi default ShowMarksHL  ctermfg=22 ctermbg=None cterm=bold
hi default ShowMarksHLu ctermfg=darkblue ctermbg=None cterm=bold
hi default ShowMarksHLo ctermfg=53 ctermbg=None cterm=bold


fun! s:NameOfMark(mark)
	let name = a:mark
	if a:mark =~ '\W'
		let name = stridx(s:allmarks, a:mark)
	endif
	return name
endf


" Function: ShowMarksSetup()
" Description: This function sets up the sign definitions for each mark.
" It uses the showmarks_textlower, showmarks_textupper and showmarks_textother
" variables to determine how to draw the mark.
fun! s:ShowMarksSetup()
	let n = 0
	while n < s:maxmarks
		let c = strpart(s:allmarks, n, 1)
		let nm = s:NameOfMark(c)
		if c =~ '[a-z]'
			let text = ">" .c
			exe 'sign define ShowMark'.nm.' text='.text.' texthl=ShowMarksHL'
		elseif c =~ '[A-Z]'
			let text = ">".c
			exe 'sign define ShowMark'.nm.' text='.text.' texthl=ShowMarksHLu'
		else " Other signs, like ', ., etc.
			let text = ">" .c
			exe 'sign define ShowMark'.nm.' text='.text.' texthl=ShowMarksHLo'
		endif
		let n = n + 1
	endw
endf

" Set things up
call s:ShowMarksSetup()

" Function: ShowMarksToggle()
" Description: This function toggles whether marks are displayed or not.
fun! s:ShowMarksToggle()
	if g:showmarks_enable == 0
		let g:showmarks_enable = 1
		call <sid>ShowMarks()
		aug ShowMarks
			au!
			autocmd CursorHold * call s:ShowMarks()
		aug END
	else
		let g:showmarks_enable = 0
		call <sid>ShowMarksHideAll()
		aug ShowMarks
			au!
			autocmd BufEnter * call s:ShowMarksHideAll()
		aug END
	endif
endf

" Function: ShowMarks()
" Description: This function runs through all the marks and displays or
" removes signs as appropriate. It is called on the CursorHold autocommand.
fun! s:ShowMarks()
	if g:showmarks_enable == 0
		return
	endif
	echomsg 'in s:ShowMarks'
	let n = 0
	while n < s:maxmarks
		let c = strpart(s:allmarks, n, 1)
		let nm = s:NameOfMark(c)
		let id = n + (s:maxmarks * winbufnr(0))
		let ln = line("'".c)
		if c =~ '^[' .s:allmarks .']$'
			if ln == 0 && (exists('b:placed_'.nm) && b:placed_{nm} != ln )
				exe 'sign unplace '.id.' buffer='.winbufnr(0)
			elseif ln > 1 && (!exists('b:placed_'.nm) || b:placed_{nm} != ln )
				exe 'sign unplace '.id.' buffer='.winbufnr(0)
				exe 'sign place '.id.' name=ShowMark'.nm.' line='.ln.' buffer='.winbufnr(0)
			endif
		endif

		let b:placed_{nm} = ln
		let n = n + 1
	endw
endf

" Function: ShowMarksClearMark()
" Description: This function hides the a-z or A-Z mark at the current line.
" It simply moves the mark to line 1 and removes the sign.
fun! s:ShowMarksClearMark()
	let ln = line(".")
	let n = 0
	while n < 52
		let c = strpart(s:allmarks, n, 1)
		let nm = s:NameOfMark(c)
		let id = n + (s:maxmarks * winbufnr(0))
		let markln = line("'".c)
		if ln == markln
			exe 'sign unplace '.id.' buffer='.winbufnr(0)
			exe '1 mark '.c
			let b:placed_{nm} = 1
		endif
		let n = n + 1
	endw
endf

" vim:ts=4:sw=4:noet
