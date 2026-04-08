augroup Verilog
   autocmd!
   autocmd BufReadPost,BufWritePost,BufNewFile,BufRead *.v,*vbkp*,*.vams,*.vh,*.vinc,*.vf,*.vl set filetype=verilog
   autocmd BufReadPost,BufWritePost,BufNewFile,BufRead *.sv*,*.svh*,*.svinc,*.svf,*svl set filetype=systemverilog

   autocmd BufReadPost,BufWritePost,BufNewFile,BufRead *.v,*.vams if line('$') == 1 && getline(1) == '' | call InsTxtFromFile($HOME.'/.vim/templates/header/header.txt', line(1)) | if stridx(expand('%:t'), 'tb') != -1 | call InsTxtFromFile($HOME.'/.vim/templates/verilog/vtbtemplate.v', line('$')) | elseif stridx(expand('%:t'), 'wrp') != -1 | call InsTxtFromFile($HOME.'/.vim/templates/verilog/vwrptemplate.v', line('$')) | else | call InsTxtFromFile($HOME.'/.vim/templates/verilog/vtemplate.v', line('$')) | endif | call InsTxtFromFile($HOME.'/.vim/templates/header/footer.txt', line('$')) | call AdjTemplate() | endif
   
   autocmd BufReadPost,BufWritePost,BufNewFile,BufRead *.sv if line('$') == 1 && getline(1) == '' | call InsTxtFromFile($HOME.'/.vim/templates/header/header.txt', line(1)) | if stridx(expand('%:t'), 'tb') != -1 | call InsTxtFromFile($HOME.'/.vim/templates/verilog/svtbtemplate.sv', line('$')) | elseif stridx(expand('%:t'), 'wrp') != -1 | call InsTxtFromFile($HOME.'/.vim/templates/verilog/svwrptemplate.sv', line('$')) | else | | call InsTxtFromFile($HOME.'/.vim/templates/verilog/svtemplate.sv', line('$')) | endif | call InsTxtFromFile($HOME.'/.vim/templates/header/footer.txt', line('$')) | call AdjTemplate() | endif

   autocmd BufReadPost,BufWritePost,BufNewFile,BufRead *.vh,*.svh if line('$') == 1 && getline(1) == '' | call InsTxtFromFile($HOME.'/.vim/templates/header/header.txt', line(1)) | call InsTxtFromFile($HOME.'/.vim/templates/verilog/vtemplate.vh', line('$')) | call InsTxtFromFile($HOME.'/.vim/templates/header/footer.txt', line('$')) | call AdjTemplate() | endif
   autocmd BufReadPost,BufWritePost,BufNewFile,BufRead *.vinc,*.svinc if line('$') == 1 && getline(1) == '' | call InsTxtFromFile($HOME.'/.vim/templates/header/header.txt', line(1)) | call InsTxtFromFile($HOME.'/.vim/templates/verilog/vtemplate.vinc', line('$')) | call InsTxtFromFile($HOME.'/.vim/templates/header/footer.txt', line('$')) | call AdjTemplate() | endif
   autocmd BufReadPost,BufWritePost,BufNewFile,BufRead *.vf,*.svf if line('$') == 1 && getline(1) == '' | call InsTxtFromFile($HOME.'/.vim/templates/header/header.txt', line(1)) | call InsTxtFromFile($HOME.'/.vim/templates/verilog/vtemplate.vf', line('$')) | call InsTxtFromFile($HOME.'/.vim/templates/header/footer.txt', line('$')) | call AdjTemplate() | endif
   autocmd FileType verilog call SetIndentMarks() | call AddFtDict()
   autocmd FileType systemverilog call SetIndentMarks() | call AddFtDict()
augroup END
