augroup PDF
   autocmd!
   autocmd BufRead,BufNewFile *.pdf exec ":!xdg-open shellescape(expand(\"%:p\"))"
augroup END
