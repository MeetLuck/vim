" ==============================================================================

if exists( "loaded_showmarks" )
	finish
endif
let loaded_showmarks = 1

" Bail if Vim isn't compiled with signs support.
if has( "signs" ) == 0
	echohl ErrorMsg
	echo "ShowMarks requires Vim to have +signs support."
	echohl None
	finish
endif

" All possible mark characters.(ShowMarksPlaceMark requires [a-z] to be first)
let s:allmarks = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789[]<>`'\"^.(){}"
let s:maxmarks = strlen(s:allmarks)

" Options: Set up some nice defaults

" Commands
com! -nargs=0 ShowMarks			:silent call <sid>ShowMarks()
com! -nargs=0 ShowMarksClearAll :silent call <sid>ShowMarksClearAll()

" Mappings
nnoremap <leader>mt :ShowMarksToggle<cr>
nnoremap <leader>ma :ShowMarksClearAll<cr>

" AutoCommands: Only if ShowMarks is enabled
aug ShowMarks
	au!
"autocmd CursorHold * call s:ShowMarks()
aug END

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
		let text = '>'.c
		if c =~ '[a-z]'
			exe 'sign define ShowMark'.nm.' text='.text.' texthl=ShowMarksHL'
		elseif c =~ '[A-Z]'
			exe 'sign define ShowMark'.nm.' text='.text.' texthl=ShowMarksHLu'
		else " Other signs, like ', ., etc.
			exe 'sign define ShowMark'.nm.' text='.text.' texthl=ShowMarksHLo'
		endif
		let n = n + 1
	endw
endf

" Set things up
call s:ShowMarksSetup()

" Function: ShowMarks()
" Description: This function runs through all the marks and displays or
" removes signs as appropriate. It is called on the CursorHold autocommand.
fun! s:ShowMarks()
	if g:showmarks_enable == 0
		return
	endif

	let n = 0
	while n < s:maxmarks
		let c = strpart(s:allmarks, n, 1)
		let nm = s:NameOfMark(c)
		let id = n + (s:maxmarks * winbufnr(0))
		let ln = line("'".c)

		if c =~ '^['.g:showmarks_include.']$'
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


" Function: ShowMarksClearAll()
" Description: This function clears all a-z and A-Z marks in the buffer.
" It simply moves the marks to line 1 and removes the signs.
fun! s:ShowMarksClearAll()
	let n = 0
	while n < 52
		let c = strpart(s:allmarks, n, 1)
		let nm = s:NameOfMark(c)
		let id = n + (s:maxmarks * winbufnr(0))

		exe 'sign unplace '.id.' buffer='.winbufnr(0)
		exe '1 mark '.c
		let b:placed_{nm} = 1

		let n = n + 1
	endw
endf

" Function: ShowMarksPlaceMark()
" Description: This function will place the next unplaced mark to the current
" location. The idea here is to automate the placement of marks so the user
" doesn't have to remember which marks are placed or not.
" Hidden marks are considered to be unplaced.
" Only marks a-z are supported.
fun! s:ShowMarksPlaceMark()
	let n = 0
	while n < 26
		let c = strpart(s:allmarks, n, 1)
		let ln = line("'".c)
		if ln <= 1
			exe 'mark '.c
			call <sid>ShowMarks()
			break
		endif
		let n = n + 1
	endw
endf

" vim:ts=4:sw=4:noet
