if has('gui_running')
    hi Cursor guifg=white guibg=green
    set guicursor=n-v-c:block-Cursor "Normal Visual Command-line mode
    set guicursor+=n-v-c:blinkon0    "blinkon0 for blink OFF
    set guicursor+=i:hor15-Cursor   "Insert mode
    "set guicursor+=i:hor100-iCursor   "NOT WORKING with hor100
    "set guicursor+=i:blinkwait10    "NOT WORKING with hor-cursor
endif
