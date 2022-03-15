" Vim syntax file
" Language:	JSON
" Maintainer:	Eli Parra <eli@elzr.com>
" Last Change:	2014 Aug 23
" Version:      0.12

if !exists("main_syntax")
  " quit when a syntax file was already loaded
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'json'
endif

syntax match   jsonNoise           /\%(:\|,\)/

" NOTE that for the concealing to work your conceallevel should be set to 2

" Syntax: Strings
" Separated into a match and region because a region by itself is always greedy
syn match  jsonStringMatch /"\([^"]\|\\\"\)\+"\ze[[:blank:]\r\n]*[,}\]]/ contains=jsonString
"Added: jsonTodo and hightlighted with after/syntax/json.vim, 18/11/11
syn keyword jsonTodo contained XXX
if has('conceal')
	syn region  jsonString oneline matchgroup=jsonQuote start=/"/  skip=/\\\\\|\\"/  end=/"/ concealends contains=jsonEscape,jsonTodo contained
else
	syn region  jsonString oneline matchgroup=jsonQuote start=/"/  skip=/\\\\\|\\"/  end=/"/ contains=jsonEscape,jsonTodo contained
endif

" Syntax: JSON does not allow strings with single quotes, unlike JavaScript.
syn region  jsonStringSQError oneline  start=+'+  skip=+\\\\\|\\"+  end=+'+

" Syntax: JSON Keywords
" Separated into a match and region because a region by itself is always greedy
syn match  jsonKeywordMatch /"\([^"]\|\\\"\)\+"[[:blank:]\r\n]*\:/ contains=jsonKeyword
"if has('conceal')
"   syn region  jsonKeyword matchgroup=jsonQuote start=/"/  end=/"\ze[[:blank:]\r\n]*\:/ concealends contained
"else
"   syn region  jsonKeyword matchgroup=jsonQuote start=/"/  end=/"\ze[[:blank:]\r\n]*\:/ contained
"endif

" Syntax: Escape sequences
syn match   jsonEscape    "\\["\\/bfnrt]" contained
syn match   jsonEscape    "\\u\x\{4}" contained

" Syntax: Numbers
syn match   jsonNumber    "-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>\ze[[:blank:]\r\n]*[,}\]]"

" ERROR WARNINGS **********************************************
if (!exists("g:vim_json_warnings") || g:vim_json_warnings==1)
	" Syntax: Strings should always be enclosed with quotes.
	syn match   jsonNoQuotesError  "\<[[:alpha:]][[:alnum:]]*\>"
	syn match   jsonTripleQuotesError  /"""/

	" Syntax: An integer part of 0 followed by other digits is not allowed.
	syn match   jsonNumError  "-\=\<0\d\.\d*\>"

	" Syntax: Decimals smaller than one should begin with 0 (so .1 should be 0.1).
	syn match   jsonNumError  "\:\@<=[[:blank:]\r\n]*\zs\.\d\+"

	" Syntax: No comments in JSON, see http://stackoverflow.com/questions/244777/can-i-comment-a-json-file
	syn match   jsonCommentError  "//.*"
	syn match   jsonCommentError  "\(/\*\)\|\(\*/\)"

	" Syntax: No semicolons in JSON
	syn match   jsonSemicolonError  ";"

	" Syntax: No trailing comma after the last element of arrays or objects
	syn match   jsonTrailingCommaError  ",\_s*[}\]]"

	" Syntax: Watch out for missing commas between elements
	syn match   jsonMissingCommaError /\("\|\]\|\d\)\zs\_s\+\ze"/
	syn match   jsonMissingCommaError /\(\]\|\}\)\_s\+\ze"/ "arrays/objects as values
	syn match   jsonMissingCommaError /}\_s\+\ze{/ "objects as elements in an array
	syn match   jsonMissingCommaError /\(true\|false\)\_s\+\ze"/ "true/false as value
endif

" ********************************************** END OF ERROR WARNINGS
" Allowances for JSONP: function call at the beginning of the file,
" parenthesis and semicolon at the end.
" Function name validation based on
" http://stackoverflow.com/questions/2008279/validate-a-javascript-function-name/2008444#2008444
syn match  jsonPadding "\%^[[:blank:]\r\n]*[_$[:alpha:]][_$[:alnum:]]*[[:blank:]\r\n]*("
syn match  jsonPadding ");[[:blank:]\r\n]*\%$"

" Syntax: Boolean
syn match  jsonBoolean /\(true\|false\)\(\_s\+\ze"\)\@!/

" Syntax: Null
syn keyword  jsonNull      null

" Syntax: Braces
syn region  jsonFold matchgroup=jsonBraces start="{" end=/}\(\_s\+\ze\("\|{\)\)\@!/ transparent fold
syn region  jsonFold matchgroup=jsonBraces start="\[" end=/]\(\_s\+\ze"\)\@!/ transparent fold


" Syntax: JSON Keywords
" Separated into a match and region because a region by itself is always greedy
"syn match  jsonKeywordMatch /"\([^"]\|\\\"\)\+"[[:blank:]\r\n]*\:/ contains=jsonKeyword
"Mandatory
syn keyword  jsonKeyword manifest_version name version
"Recommanded
syn keyword  jsonKeyword default_locale description icons
"Pick one or None
syn keyword  jsonKeyword browser_action page_action
"Optional
syn keyword  jsonKeyword action author automation
syn keyword  jsonKeyword background
"Recommended
syn keyword  jsonKeyword persistent
"Optional
syn keyword  jsonKeyword  service_worker_script
syn keyword  jsonKeyword  chrome_settings_overrides
syn keyword  jsonKeyword  chrome_ui_overrides
syn keyword  jsonKeyword  bookmarks_ui
syn keyword  jsonKeyword  remove_bookmark_shortcut
syn keyword  jsonKeyword  remove_button
syn keyword  jsonKeyword  chrome_url_overrides
syn keyword  jsonKeyword  commands
syn keyword  jsonKeyword  content_scripts
syn keyword  jsonKeyword  content_security policy
syn keyword  jsonKeyword  converted_from_user_script
syn keyword  jsonKeyword  current_locale
syn keyword  jsonKeyword  declarative_net_request
syn keyword  jsonKeyword  devtools_page
syn keyword  jsonKeyword  event_rules
syn keyword  jsonKeyword  event_rules
syn keyword  jsonKeyword  externally_connectable
syn keyword  jsonKeyword  matches
syn keyword  jsonKeyword  file_browser_handlers
syn keyword  jsonKeyword  file_system_provider_capabilities
syn keyword  jsonKeyword  homepage_url
syn keyword  jsonKeyword  import
syn keyword  jsonKeyword  incognito
syn keyword  jsonKeyword  input_components
syn keyword  jsonKeyword  key
syn keyword  jsonKeyword  minimum_chrome_version
syn keyword  jsonKeyword  nacl_modules
syn keyword  jsonKeyword  oauth2
syn keyword  jsonKeyword  offline_enabled
syn keyword  jsonKeyword  omnibox
syn keyword  jsonKeyword  keyword
syn keyword  jsonKeyword  optional_permissions
syn keyword  jsonKeyword  options_page
syn keyword  jsonKeyword  options_ui
syn keyword  jsonKeyword  chrome_style
syn keyword  jsonKeyword  page
syn keyword  jsonKeyword  permissions
syn keyword  jsonKeyword  tabs
syn keyword  jsonKeyword  platforms
syn keyword  jsonKeyword  platforms
syn keyword  jsonKeyword  requirements
syn keyword  jsonKeyword  sandbox
syn keyword  jsonKeyword  short_name
syn keyword  jsonKeyword  signature
syn keyword  jsonKeyword  spellcheck
syn keyword  jsonKeyword  storage
syn keyword  jsonKeyword  managed_schema
syn keyword  jsonKeyword  system_indicator
syn keyword  jsonKeyword  tts_engine
syn keyword  jsonKeyword  update_url
syn keyword  jsonKeyword  version_name
syn keyword  jsonKeyword  web_accessible_resources


" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi jsonKeyword gui=bold,underline guifg=#008800 

hi def link jsonPadding         Operator
hi def link jsonString          String
hi def link jsonTest          Label
hi def link jsonEscape          Special
hi def link jsonNumber          Number
hi def link jsonBraces          Delimiter
hi def link jsonNull            Function
hi def link jsonBoolean         Boolean

if (!exists("g:vim_json_warnings") || g:vim_json_warnings==1)
hi def link jsonNumError        Error
hi def link jsonCommentError    Error
hi def link jsonSemicolonError  Error
hi def link jsonTrailingCommaError     Error
hi def link jsonMissingCommaError      Error
hi def link jsonStringSQError        	Error
hi def link jsonNoQuotesError        	Error
hi def link jsonTripleQuotesError     	Error
endif
hi def link jsonQuote           Quote
hi def link jsonNoise           Noise

let b:current_syntax = "json"
if main_syntax == 'json'
  unlet main_syntax
endif

" Vim settings
" vim: ts=8 fdm=marker

