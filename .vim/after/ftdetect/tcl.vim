" tcl
augroup Tcl 
    autocmd BufNewFile,BufRead *.tcl set filetype=tcl
    autocmd FileType tcl call SetIndentMarks() | call AddFtDict()
augroup END
