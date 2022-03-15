
function! mylib#trim(string)
    return matchstr(a:string, '^\v\_s*\zs.{-}\ze\_s*$')
endfunction

function! mylib#echortp()
    let rtp = execute('set rtp')
    let rtplist = split(rtp,'=')[1]
    let rtplist = split(rtplist,',')
    echomsg string(rtplist)
    echomsg 'runtimepath: ' .len(rtplist)
    for rtp in rtplist
        echomsg string(rtp)
    endfor
endfunction
