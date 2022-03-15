" File: PopupBuffer.vim
" Last Change: 2001 Nov 13
" Maintainer: 
" Version: 1.1.1
" PopUp Menu: 
" "--Forget Me Not--""
" "--Copy to Clipboard--""
" "--Paste from Clipboard--""

"Safe Guard:
if exists("g:loaded_bufferpopup")
  finish
endif
let g:loaded_bufferpopup = 1


" Add new buffer to popup menu
function! <SID>PBAdd( fname, bnum )
	if !isdirectory(a:fname)
		exe "amenu PopUp.Buffers." . <SID>PBFormat( a:fname, a:bnum ) . " :b " . a:bnum . "<CR>"
	endif
endfunc

" Remove deleted buffer from popup menu
func! <SID>PBRemove()
	let name = expand("<afile>")
	if !isdirectory(name)
		exe "aunmenu PopUp.Buffers." . <SID>PBFormat(  name, expand("<abuf>") )
	endif
endfunc

" Format menu entry
func! <SID>PBFormat(fname, bnum)
	let name = a:fname
	if name == ''
		let name = "[No File]"
	else
		let name = fnamemodify(name, ':p:~')
	endif

	" Parse popupBufferPattern
	let item = substitute( g:popupBufferPattern, "%F", name, "g" )
	let item = substitute( item, "%f", fnamemodify(name, ':t'), "g" )
	let item = substitute( item, "%p", fnamemodify(name, ':h'), "g" )
	let item = substitute( item, "%n", a:bnum, "g" )

	" Some cleaning
	let item = escape( item, "\\. \t|")
	let item = substitute( item, "\n", "^@", "g")
	return item
endfunc

function! <SID>PBShow()
	" Add current buffers
	let bufnr= 1
	while bufnr<= bufnr('$')
		if bufexists(bufnr) && !getbufvar(bufnr, "&bufsecret")
			call <SID>PBAdd( bufname(bufnr), bufnr)
		endif
		let bufnr= bufnr+ 1
	endwhile

	" Define autocommands
	augroup buffer_popup
	au!
	au BufCreate,BufFilePost * call <SID>PBAdd( expand("<afile>"), expand("<abuf>") )
	au BufDelete,BufFilePre * call <SID>PBRemove()
	augroup END
endfunction

" Initialization
call <SID>PBShow()
