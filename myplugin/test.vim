

command! -nargs=0 DoIt :call <sid>showBuffer()
function! <sid>showBuffer()
    let bufno = 1
    while bufno <= bufnr('$')
        if bufexists(bufno)
            echomsg bufno. ' buffer name :' .bufname(bufno)
            echomsg 'bufvar: ' .getbufvar(bufno, "&buftype")
        endif
        let bufno += 1
    endwhile
endfunction
":DoIt
let a = 'worked!'
echomsg eval('a')

"function! <SID>PBShow()
"    " Add current buffers
"    let bufnr= 1
"    while bufnr<= bufnr('$')
"            if bufexists(bufnr) && !getbufvar(bufnr, "&bufsecret")
"                    call <SID>PBAdd( bufname(bufnr), bufnr)
"            endif
"            let bufnr= bufnr+ 1
"    endwhile
