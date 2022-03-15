"syntax clear
syntax match popupSharp contained "#" conceal
syntax match popupNormal   "\\\@<!#[^"*|#]\+#" contains=popupSharp
syntax keyword popupRtp     runtimepath
syntax keyword popupmarks   marks
