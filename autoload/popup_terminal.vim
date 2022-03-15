let buf = term_start(['bash'], #{hidden: 1})
let winid = popup_create(buf, #{minwidth: 50, minheight: 20})
call popup_show(winid)
