augroup Vhdl
   autocmd!
   autocmd BufReadPost,BufWritePost,BufNewFile,BufRead *.vhd,*.vhdl,*.vht set filetype=vhdl
   autocmd BufReadPost,BufWritePost,BufNewFile,BufRead *.vhd,*.vhdl,*.vht if line('$') == 1 && getline(1) == '' | call InsTxtFromFile($HOME.'/.vim/templates/header/header.txt', line(1)) | if stridx(expand('%:t'), 'tb') != -1 | call InsTxtFromFile($HOME.'/.vim/templates/vhdl/vhdltbtemplate.vhdl', line('$')) | else | call InsTxtFromFile($HOME.'/.vim/templates/vhdl/vhdltemplate.vhdl', line('$')) | endif | call InsTxtFromFile($HOME.'/.vim/templates/header/footer.txt', line('$')) | call AdjTemplate() | exec ":%s/\\/\\//--/g" | redraw! | endif
   autocmd FileType vhdl call SetIndentMarks() | call AddFtDict()
augroup END
