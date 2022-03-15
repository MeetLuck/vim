" Syntax File For PopUp Window:
" Filetype: wave
" orange color : CB4B16  blue color : 268BD2
" Number : Green, wave Name :Cyan
syntax  clear
setlocal conceallevel=1
"Scenario:
syntax  match    waveScenario         /\v✓ <Scenario (One|Two|Three)>/
"Table Special Star Check:
syntax  keyword  waveTableHeader      size type fib days MACD OSC
syntax  keyword  waveSpecial          TODO note WARNING active
syntax  keyword  waveUnknown          unknown
syntax  match    waveStar             contained "*"
syntax  match    waveCheck            contained "✓"
syntax  match    waveNotation         /\v\@notation/
syntax  match    waveChecklist         /\v<Check List>/
"Point Name:
syntax  match    wavePointName        /\v<p[0-5A-C]>/
"Wave: [I](SuperCycle)<-I(Cycle)<-1,2,3(Primary)<-i,ii,iii(Minor)
syntax  match    waveMonthly          /\v<mw[12345ABC]>/
syntax  match    waveWeekly           /\v<ww[12345ABC]>/
syntax  match    waveDaily            /\v<dw[12345ABC]>/
syntax  match    waveHourly           /\v<hw[12345ABC]>/
syntax  match    waveTitle            /\v<(Monthly|Weekly|Daily|Hourly|Minute) wave>/
"Size And Number:
syntax  match    waveSize              /\v(: )@<=[-+]\d{2,3}>/
syntax  match    waveNumber            /\v\s@<=\d{3}>/
syntax  match    waveNotDefinedNumber  /\v\s@<=\*\d{-}>/  contains=waveStar
syntax  match    waveImportantNumber   /\v\s@<=✓\d{-}>/   contains=waveCheck
syntax  match    waveFibNumber        /\v(0.382|0.628|1.000|1.618|2.618|3.618|2.000|2.382|4.000)/

hi link waveSize vimGroup

hi clear waveNotDefinedNumber wavebaseName
hi waveUnknown      gui=italic,underline
hi wavebaseName    gui=bold guifg=#b08500
"hi wavebaseName    gui=bold,italic     guifg=#1650d5 guibg=black
hi wavePointName guifg=#2670d5
hi waveTitle   gui=bold,italic guifg=#1650d5
"hi waveTitle   gui=italic guifg=#1650d5  guibg=black
hi link waveMonthly wavebaseName 
hi link waveWeekly wavebaseName 
hi link waveDaily wavebaseName 
hi link waveHourly wavebaseName 
hi link waveMinute wavebaseName 
hi waveNotation     gui=bold    guifg=#a0b000
hi waveChecklist     gui=bold   guifg=#50a000
hi waveNumber           gui=bold           guifg=#207030
hi waveNotDefinedNumber gui=bold           guifg=#207030
hi waveImportantNumber  gui=bold,underline guifg=#207030
hi waveFibNumber                           guifg=#206030
hi waveStar                                guifg=#206020
hi waveCheck guifg=red
hi waveTableHeader gui=bold guifg=#708090
hi waveSpecial gui=bold guifg=darkred
hi waveScenario gui=bold,italic guifg=#00aa33
