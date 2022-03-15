nmap \x :call Getfoo()<CR> :exe "/".Foo<CR>
function Getfoo()
    call inputsave()
    let g:Foo = input('enter search pattern:')
    "call inputrestore()
endfunction
