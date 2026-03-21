augroup CSV
   autocmd!
   autocmd BufNewFile,BufRead *.csv setf csv
   autocmd FileType csv :CSVTabularize!
augroup END
