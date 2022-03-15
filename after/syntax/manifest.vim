" Vim syntax file
" Language:    JSON
" Maintainer:    Eli Parra <eli@elzr.com>
" Last Change:    2014 Aug 23
" Version:      0.12

if !exists("main_syntax")
  " quit when a syntax file was already loaded
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'manifest'
endif

syntax match   manifestNoise           /\%(:\|,\)/

" NOTE that for the concealing to work your conceallevel should be set to 2

" Syntax: Strings
" Separated into a match and region because a region by itself is always greedy
syn match  manifestStringMatch /"\([^"]\|\\\"\)\+"\ze[[:blank:]\r\n]*[,}\]]/ contains=manifestString
"Added: manifestTodo and hightlighted with after/syntax/manifest.vim, 18/11/11
syn keyword manifestTodo contained XXX
syn region  manifestString oneline matchgroup=manifestQuote start=/"/  skip=/\\\\\|\\"/  end=/"/ concealends 
            \contains=manifestEscape,manifestTodo,manifestSubKeyword contained

" Syntax: JSON does not allow strings with single quotes, unlike JavaScript.
syn region  manifestStringSQError oneline  start=+'+  skip=+\\\\\|\\"+  end=+'+

" Syntax: JSON Keywords
" Separated into a match and region because a region by itself is always greedy
"syn match  manifestKeywordMatch /"\([^"]\|\\\"\)\+"[[:blank:]\r\n]*\:/ contains=manifestKeyword
"if has('conceal')
"   syn region  manifestKeyword matchgroup=manifestQuote start=/"/  end=/"\ze[[:blank:]\r\n]*\:/ concealends contained
"else
"   syn region  manifestKeyword matchgroup=manifestQuote start=/"/  end=/"\ze[[:blank:]\r\n]*\:/ contained
"endif

" Syntax: Escape sequences
syn match   manifestEscape    "\\["\\/bfnrt]" contained
syn match   manifestEscape    "\\u\x\{4}" contained

" Syntax: Numbers
syn match   manifestNumber    "-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>\ze[[:blank:]\r\n]*[,}\]]"

" ERROR WARNINGS **********************************************
if (!exists("g:vim_manifest_warnings") || g:vim_manifest_warnings==1)
    " Syntax: Strings should always be enclosed with quotes.
    syn match   manifestNoQuotesError  "\<[[:alpha:]][[:alnum:]]*\>"
    syn match   manifestTripleQuotesError  /"""/

    " Syntax: An integer part of 0 followed by other digits is not allowed.
    syn match   manifestNumError  "-\=\<0\d\.\d*\>"

    " Syntax: Decimals smaller than one should begin with 0 (so .1 should be 0.1).
    syn match   manifestNumError  "\:\@<=[[:blank:]\r\n]*\zs\.\d\+"

    " Syntax: No comments in JSON, see http://stackoverflow.com/questions/244777/can-i-comment-a-manifest-file
    syn match   manifestCommentError  "//.*"
    syn match   manifestCommentError  "\(/\*\)\|\(\*/\)"

    " Syntax: No semicolons in JSON
    syn match   manifestSemicolonError  ";"

    " Syntax: No trailing comma after the last element of arrays or objects
    syn match   manifestTrailingCommaError  ",\_s*[}\]]"

    " Syntax: Watch out for missing commas between elements
    syn match   manifestMissingCommaError /\("\|\]\|\d\)\zs\_s\+\ze"/
    syn match   manifestMissingCommaError /\(\]\|\}\)\_s\+\ze"/ "arrays/objects as values
    syn match   manifestMissingCommaError /}\_s\+\ze{/ "objects as elements in an array
    syn match   manifestMissingCommaError /\(true\|false\)\_s\+\ze"/ "true/false as value
endif

" ********************************************** END OF ERROR WARNINGS
" Allowances for JSONP: function call at the beginning of the file,
" parenthesis and semicolon at the end.
" Function name validation based on
" http://stackoverflow.com/questions/2008279/validate-a-javascript-function-name/2008444#2008444
syn match  manifestPadding "\%^[[:blank:]\r\n]*[_$[:alpha:]][_$[:alnum:]]*[[:blank:]\r\n]*("
syn match  manifestPadding ");[[:blank:]\r\n]*\%$"

" Syntax: Boolean
syn match  manifestBoolean /\(true\|false\)\(\_s\+\ze"\)\@!/

" Syntax: Null
syn keyword  manifestNull      null

" Syntax: Braces
syn region  manifestFold matchgroup=manifestBraces start="{" end=/}\(\_s\+\ze\("\|{\)\)\@!/ transparent fold
syn region  manifestFold matchgroup=manifestBraces start="\[" end=/]\(\_s\+\ze"\)\@!/ transparent fold


" Syntax: JSON Keywords
" Separated into a match and region because a region by itself is always greedy
 syn match  manifestKeywordMatch /"\([^"]\|\\\"\)\+"[[:blank:]\r\n]*\:/ contains=manifestKeyword,manifestSubKeyword
"Mandatory
syn keyword  manifestKeyword manifest_version name version
"Recommanded
syn keyword  manifestKeyword default_locale description icons
"Pick one or None
syn keyword  manifestKeyword browser_action page_action
"Optional
syn keyword  manifestKeyword action author automation
syn keyword  manifestKeyword background
"Recommended
syn keyword  manifestKeyword persistent
"Optional
syn keyword  manifestKeyword  service_worker_script
syn keyword  manifestKeyword  chrome_settings_overrides
syn keyword  manifestKeyword  chrome_ui_overrides
syn keyword  manifestKeyword  bookmarks_ui
syn keyword  manifestKeyword  remove_bookmark_shortcut
syn keyword  manifestKeyword  remove_button
syn keyword  manifestKeyword  chrome_url_overrides
syn keyword  manifestKeyword  commands
syn keyword  manifestKeyword  content_capabilities
syn keyword  manifestKeyword  content_scripts
syn keyword  manifestKeyword  content_security_policy
syn keyword  manifestKeyword  converted_from_user_script
syn keyword  manifestKeyword  current_locale
syn keyword  manifestKeyword  declarative_net_request
syn keyword  manifestKeyword  devtools_page
syn keyword  manifestKeyword  event_rules
syn keyword  manifestKeyword  event_rules
syn keyword  manifestKeyword  externally_connectable
syn keyword  manifestKeyword  matches
syn keyword  manifestKeyword  file_browser_handlers
syn keyword  manifestKeyword  file_system_provider_capabilities
syn keyword  manifestKeyword  homepage_url
syn keyword  manifestKeyword  import
syn keyword  manifestKeyword  incognito
syn keyword  manifestKeyword  input_components
syn keyword  manifestKeyword  key
syn keyword  manifestKeyword  minimum_chrome_version
syn keyword  manifestKeyword  nacl_modules
syn keyword  manifestKeyword  oauth2
syn keyword  manifestKeyword  offline_enabled
syn keyword  manifestKeyword  omnibox
syn keyword  manifestKeyword  keyword
syn keyword  manifestKeyword  optional_permissions
syn keyword  manifestKeyword  options_page
syn keyword  manifestKeyword  options_ui
syn keyword  manifestKeyword  chrome_style
syn keyword  manifestKeyword  page
syn keyword  manifestKeyword  permissions
syn keyword  manifestSubKeyword  contained tabs source configurable
syn keyword  manifestKeyword  platforms
syn keyword  manifestKeyword  platforms
syn keyword  manifestKeyword  requirements
syn keyword  manifestKeyword  sandbox
syn keyword  manifestKeyword  short_name
syn keyword  manifestKeyword  signature
syn keyword  manifestKeyword  spellcheck
syn keyword  manifestKeyword  storage
syn keyword  manifestKeyword  managed_schema
syn keyword  manifestKeyword  system_indicator
syn keyword  manifestKeyword  tts_engine
syn keyword  manifestKeyword  update_url
syn keyword  manifestKeyword  version_name
syn keyword  manifestKeyword  web_accessible_resources


" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi manifestKeyword gui=bold,underline guifg=#008800 
hi manifestSubKeyword  guifg=#008800 

hi def link manifestPadding         Operator
hi def link manifestString          String
hi def link manifestTest            Label
hi def link manifestEscape          Special
hi def link manifestNumber          Number
hi def link manifestBraces          Delimiter
hi def link manifestNull            Function
hi def link manifestBoolean         Boolean

if (!exists("g:vim_manifest_warnings") || g:vim_manifest_warnings==1)
    hi def link manifestNumError                  Error
    hi def link manifestCommentError              Error
    hi def link manifestSemicolonError            Error
    hi def link manifestTrailingCommaError        Error
    hi def link manifestMissingCommaError         Error
    hi def link manifestStringSQError             Error
    hi def link manifestNoQuotesError             Error
    hi def link manifestTripleQuotesError         Error
endif

hi def link manifestQuote           Quote
hi def link manifestNoise           Noise

let b:current_syntax = "manifest"
if main_syntax == 'manifest'
  unlet main_syntax
endif

" Vim settings
" vim: ts=8 fdm=marker
