" "Customize help file"
" "# heading 1#"

syntax match myhelpSharp contained "#" conceal
syntax match myhelpeg "\se\.g\.\s"
syntax match myhelpUnderbar contained "_" conceal
syntax match myhelpH1   "\\\@<!#[^"*|#]\+#" contains=myhelpSharp
syntax match myhelpBold   "\\\@<!__[^ *|#_]\+__" contains=myhelpUnderbar
syntax keyword myhelpSpecial myWarning
syntax keyword myhelpTODO   TODO TODO:
syntax keyword myhelpVIM    VIM
