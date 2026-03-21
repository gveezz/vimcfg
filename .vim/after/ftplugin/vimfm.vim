let g:vimfm_force_delete = 1
let g:vimfm_show_hidden_files = 1
let g:vimfm_linkid_str = '>'


setlocal number relativenumber
setlocal bufhidden=wipe
"nmap <silent> <nowait> t :call EchoYellowMsg("(!) Open a new tab from a non ".&ft." buffer")<CR>
"nmap <silent> <nowait> <C-t> :call EchoYellowMsg("(!) Open a new tab from a non ".&ft." buffer")<CR>

nmap <silent> <nowait> <S-Tab> <Left>
nmap <silent> <nowait> <Tab> <Right>
nmap <silent> <nowait> <Space> <Down>
nmap <silent> <nowait> <S-Space> <Up>

nmap <nowait> <C-S-f> :find **/
