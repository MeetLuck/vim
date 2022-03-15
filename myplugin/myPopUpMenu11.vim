" File: myPopUpMenu10.vim
" Last Change: 2001 Nov 13
" Maintainer: 
" Version: 1.1.1
" PopUp Menu: 
" "--Forget Me Not--""
" "--Global Marks--""
" "--Custom Mapping--""
" "--runtimepath--""
" "--Paste from Clipboard--""
" "--Copy to Clipboard--""
 
if has('win32') 
    command! -buffer Reinstall :silent! exe "!del "  .expand("~/.vim/plugin/") ."myPopUpMenu*.vim"
                             \|:silent! exe "!copy " .expand("%") ." " .expand("~/.vim/plugin")
else
    command! -buffer Reinstall :silent exe "!rm -rf ~/.vim/plugin/myPopUpMenu*.vim" 
                              \|silent exe "!cp % ~/.vim/plugin"
endif

"Safe Guard:
if exists("g:loaded_bufferpopup")
  finish
endif
let g:loaded_bufferpopup = 1

let s:forgetmenotFile = expand('$HOME/.vim/plugin/forgetmenot.txt')
let s:forgetmenotList = readfile(s:forgetmenotFile,'')

function! <sid>showForgetmenot()
    " "-- padding : [top,right,bottom,left] clockwise--"
   call mywindow#create_popup(s:forgetmenotList,'forgetmenot','User1','help')
endfunction
function! <sid>showMapping()
    " "-- padding : [top,right,bottom,left] clockwise--"
    let mappings = split(execute('map <leader>'), "\n")
   call mywindow#create_popup(mappings,'mappings','Comment','help')
endfunction
function! <sid>showMarks()
    " "-- padding : [top,right,bottom,left] clockwise--"
    " orange color : CB4B16
    " blue color : 268BD2
    let amarks = execute('marks') "0ABCDEFGHIJKLMNOPQRSTUVWXYZ.')
    let globalmarks = []
    for line in split(amarks,"\n")
        let linelist = split(line)
        if linelist[0] =~# "[0A-Z.']"
            call add(globalmarks, trim(line))
        endif
    endfor
    call mywindow#create_popup(globalmarks,'marks','Comment','mark')
     
endfunction
function! <sid>showrtp()
    let rtpstring = execute(':set rtp')
    let rtps = split(rtpstring,'=')
    let rtps = split(rtps[1],',')
    call map(rtps, ' "#" . v:val . "#" ')
    call mywindow#create_popup(rtps,'runtimepath','Comment','mypopup')
endfunction


" Add Popup Menus:
function! <sid>addMenus()
    noremenu PopUp.ForgetMeNot        :call <sid>showForgetmenot() <CR>
    noremenu PopUp.Global\ Marks      :call <sid>showMarks()<CR>
    noremenu PopUp.Custom\ Mapping    :call <sid>showMapping()<CR>
    noremenu PopUp.runtimepath                :call <sid>showrtp()<CR>
    nmenu PopUp.PasteFromClipboard   "+p
    vmenu PopUp.CopyToClipboard     "+y
endfunc

call <sid>addMenus()
