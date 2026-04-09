augroup JSON
   autocmd!
   autocmd BufReadPost,BufWritePost,BufNewFile *.json, set filetype=json
   autocmd FileType json if line('$') == 1 && getline(1) == '' | call InsTxtFromFile($HOME.'/.vim/templates/json/jsontemplate.json', line(1)) | endif
   autocmd FileType json call SetIndentMarks() | call AddFtDict()
augroup END
