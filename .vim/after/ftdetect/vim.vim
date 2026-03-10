augroup Vim
   autocmd!
   autocmd BufReadPost,BufWritePost,BufNewFile,BufRead *.vim set filetype=vim
   autocmd FileType vim call SetIndentMarks() | call AddFtDict()
augroup END
