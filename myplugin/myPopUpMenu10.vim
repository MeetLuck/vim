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
   let winid = popup_create(s:forgetmenotList, #{
        \ title: 'forgetmenot',
        \ highlight: 'Normal',
       	\ padding: [0,1,1,1],
       	\ border: [1,0,0,0],
       	\ borderchars: [' '],
       	\ borderhighlight: ['popupTitle','','',''],
       	\ close: 'button',
       	\ })
   call win_execute(winid, 'setlocal conceallevel=1')
   call win_execute(winid, 'setlocal filetype=help')
endfunction
function! <sid>showMapping()
    " "-- padding : [top,right,bottom,left] clockwise--"
    let mappings = split(execute('map <leader>'), "\n")
   let winid = popup_create(mappings, #{
        \ title: 'mappings',
        \ highlight: 'Comment',
       	\ padding: [0,1,1,1],
       	\ border: [1,0,0,0],
       	\ borderchars: [' '],
       	\ borderhighlight: ['popupTitle','','',''],
       	\ close: 'button',
       	\ })
   call win_execute(winid, 'setlocal conceallevel=1')
   call win_execute(winid, 'setlocal filetype=mypopup')
endfunction

function! <sid>showMarks()
    " "-- padding : [top,right,bottom,left] clockwise--"
    " orange color : CB4B16
    " blue color : 268BD2
    "split(marks,"\n")

    let amarks = execute('marks') "0ABCDEFGHIJKLMNOPQRSTUVWXYZ.')
    let globalmarks = []
    for line in split(amarks,"\n")
        let linelist = split(line)
        "echo 'line >>' line
        "echo 'linelist >> ' line
        "echo 'linelist[0]: ' linelist[0]
        if linelist[0] =~# "[0A-Z.']"
            call add(globalmarks, trim(line))
            "echo 'linelist: '  linelist[0]
            "echo 'line: >>' line
        endif
    endfor
   let winid = popup_create(globalmarks, #{
        \ title: 'marks',
        \ highlight: 'Comment',
       	\ padding: [0,1,1,1],
       	\ border: [1,0,0,0],
       	\ borderchars: [' '],
       	\ borderhighlight: ['popupTitle','','',''],
       	\ close: 'button',
       	\ })
   call win_execute(winid, 'setlocal conceallevel=1')
   call win_execute(winid, 'setlocal filetype=mark')
     
endfunction
function! <sid>showrtp()
    let rtpstring = execute(':set rtp')
    let rtps = split(rtpstring,'=')
    let rtps = split(rtps[1],',')
    call map(rtps, ' "#" . v:val . "#" ')
   let winid = popup_create(rtps, #{
        \ title: 'runtimepath',
        \ highlight: 'Comment',
       	\ padding: [0,1,1,1],
       	\ border: [1,0,0,0],
       	\ borderchars: [' '],
       	\ borderhighlight: ['popupTitle','','',''],
       	\ close: 'button',
       	\ })
   call win_execute(winid, 'setlocal conceallevel=1')
   call win_execute(winid, 'setlocal filetype=mypopup')
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
