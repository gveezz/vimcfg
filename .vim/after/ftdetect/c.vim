augroup C
   autocmd!
   autocmd BufReadPost,BufWritePost,BufNewFile *.c,*.h set filetype=c
   autocmd BufReadPost,BufWritePost,BufNewFile *.cc,*.cpp,*.hpp set filetype=cpp
   autocmd BufReadPost,BufWritePost,BufNewFile *.c,*.cc,*.cpp if line('$') == 1 && getline(1) == '' | call InsTxtFromFile($HOME.'/.vim/templates/header/header.txt', line(1)) | call InsTxtFromFile($HOME.'/.vim/templates/c/ctemplate.c', line('$')) | call InsTxtFromFile($HOME.'/.vim/templates/header/footer.txt', line('$')) | call AdjTemplate() | endif
   autocmd BufReadPost,BufWritePost,BufNewFile *.h,*.hpp if line('$') == 1 && getline(1) == '' | call InsTxtFromFile($HOME.'/.vim/templates/header/header.txt', line(1)) | call InsTxtFromFile($HOME.'/.vim/templates/c/ctemplate.h', line('$')) | call InsTxtFromFile($HOME.'/.vim/templates/header/footer.txt', line('$')) | call AdjTemplate() | endif
   autocmd FileType c,cpp call SetIndentMarks() | call AddFtDict()
augroup END
