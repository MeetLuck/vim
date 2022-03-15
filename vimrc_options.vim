set nocompatible

"Gui Options: -> to disable default menu including popup menu
"if has('gui_running') && has('win32')
if has('win32')
    set noshellslash
    "WARNING! cmd.exe not work because a forward slash(/) is "used
    "WARNING! shellslash cause ~\.vim\bundle/vim-vinear on windows
    set rtp +=$HOME/.vim        "WARNING need to work pathogen properly for gvim 
    set rtp +=$HOME/.vim/after  "WARNING need to work ater for gvim
    "NOTE rtp -=<NOSPACE>/path/
    set guioptions=cM
    "WARNING ! -> may cause problem with external program
    "NOTE M -> do not source $VIMRUNTIME/menu.vim
    set rtp -=$HOME/vimfiles
    set rtp -=$HOME/vimfiles/after
    "NOTE should come before executing pathogen on or filetype plugin for windows
endif

"Pathogen:
execute pathogen#infect()
:Helptags
"Syntax Filetype Plugin:
filetype plugin indent on "enable filetype plugins
syntax on	"syntax highlight 
set modeline

"Viminfo:
set viminfo=%,!,'100,<50,s10,h
"set: viminfo with win32
"WARNING!!! -> bugs when :ls, :messages, especially files with marks A-Z,0-9
 
"Clear Shortmessage Option: shm
set shm-=

"Autocomplete: using AutoComplPop"
"git clone https://github.com/vim-scripts/AutoComplPop
set complete+=kspell
set completeopt=menuone,longest
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
" Navigate the complete menu items like CTRL+n / CTRL+p would.
inoremap <expr> <Down> pumvisible() ? "<C-n>" :"<Down>"
inoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"
" Select the complete menu item like CTRL+y would.
" WARNING : need to press <ENTER> twice if want to go new line
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"
" Cancel the complete menu item like CTRL+e would.
inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Left>"
inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Esc>"



"Timeout:
set ttyfast
set notimeout ttimeout "only keycode delay using ttimeoutlen
set ttimeoutlen=10

"Auto:
set autoread
set autowrite
set autochdir "WARNING -> this cause STRANGE behaviour with :ls and messages

"Mouse:
set mouse=a
set mousemodel=popup
set ttymouse=xterm2

"Indent:
set tabstop=4     " Size of a hard tabstop (ts).
set shiftwidth=4  " Size of an indentation (sw).
set expandtab     " Always uses spaces instead of tab characters (et).
set softtabstop=0 " Number of spaces a <Tab> counts for. When 0, featuer is off (sts).
set autoindent    " Copy indent from current line when starting a new line.
set smarttab      " Inserts blanks on a <Tab> key (as per sw, ts and sts).
" "NOT needed with expand tab"
"set smartindent
"set cindent

" CharSet: utf-8
" WARNING win32GUI,console use CP949, but if fileencoding is UTF-8
" then, changing encoding=utf-8 display weird characters(your locale charset)
language messages en_US "(display all menus and messages in English)
scriptencoding utf-8
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8              " NOTE The encoding when "displayed"
    setglobal fileencoding=utf-8    " NOTE encoding when "written to file"
    "setglobal bomb
    set fileencodings=ucs-bom,utf-8,default,latin1
endif


" Buffer: ls
set hidden	"put buffer to the background without writing
set noswapfile
set nobackup
set nowritebackup

" Tab: command-line completion instead of <C-D>
set wildmenu  "visual autocomplete for command menu TABTAB...
set wildmode=list:longest,full

"set lazyredraw	"redraw only when need
set redraw=1
set rdt=500
"Search:
set incsearch	"search as characters are entered
set hlsearch	"highlight matches

"Trailing Blanks:
set backspace=indent,eol,start
set listchars=eol:$,space:.,tab:^I,extends:>,precedes:<
"List Mode: to see trailing blanks
"set list:
"set nolist:

"Status:
set title
set laststatus=2	"always show status line
set report=0		"0 for show all changes 
set showmatch	"highlight matching ({[]})
set showcmd 	"show command in bottom bar
set showmode	"show current mode
set cmdheight=2		"get rid of all the press enter to continue
"set breakindent	
set noruler	"show current position on the bottom
"set textwidth=78
"set linebreak		"break on words not in the middle of word
"set linespace=0		"don't insert any extra pixel lines between rows
"set conceallevel=0

"Columns:
set number relativenumber	"show line numbers
"set numberwidth=5
set signcolumn=no
set colorcolumn=81
set cursorline  "highlight current line
"Vertical Split: ->help hl-VertSplit
set fillchars=vert:.
" "--set guifg==guibg to hide char"

"Solarized:
if has('gui_running')
    " "--------gui font set -------"
    set guifont=Anonymous\ Pro:h14:cANSI
endif
if has("termguicolors") || has('gui_running')
    set termguicolors
    set background=dark
    colors solarized
endif

"CustomizeSolarized:
"~/.vim/bundle/vim-colors-solarized/colors/solarized.vim
"~/.vim/after/colors/solarized.vim
 
"Netrw:
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_winsize=25

"Folding:
set nofoldenable
"set foldmethod=syntax 	"zR for fold, zM for unfold
"WARNING: not working properly--; git clone vim-javascript.git
"NOTE: function funcName()<NO SPACE>{}"
let javaScript_fold=1
let g:vimsyn_folding = 'af'   

" ----- Current File Directory -----"
"command! -nargs=0 Cfd cd %:p:h
" ------ find -----"
"set your path to current directory(from which you launched vim)
"set path=$PWD/**
set path+=~/.vim/**
set path+=$PWD
