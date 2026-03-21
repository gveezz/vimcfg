augroup Makefile
   autocmd!
   autocmd BufReadPost,BufWritePost,BufNewFile Makefile,makefile,*.mk set filetype=make

   autocmd FileType make if line('$') == 1 && getline(1) == '' | call InsTxtFromFile($HOME.'/.vim/templates/header/header.txt', line(1)) | call InsTxtFromFile($HOME.'/.vim/templates/makefile/makefile', line('$')) | call InsTxtFromFile($HOME.'/.vim/templates/header/footer.txt', line('$')) | call AdjTemplate('#') | endif
   
augroup END
