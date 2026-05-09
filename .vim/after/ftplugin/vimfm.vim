let g:vimfm_force_delete = 1
let g:vimfm_show_hidden_files = 1
let g:vimfm_linkid_str = '>'
stopinsert
setlocal number relativenumber
setlocal bufhidden=wipe
"nmap <silent> <nowait> t :call EchoYellowMsg("(!) Open a new tab from a non ".&ft." buffer")<CR>
"nmap <silent> <nowait> <C-t> :call EchoYellowMsg("(!) Open a new tab from a non ".&ft." buffer")<CR>

nmap <silent> <nowait> <buffer> <S-Tab> <Left>
nmap <silent> <nowait> <buffer> <Tab> <Right>
nmap <silent> <nowait> <buffer> <Space> <Down>
nmap <silent> <nowait> <buffer> <S-Space> <Up>

nmap <silent> <nowait> <buffer> <2-LeftMouse> <Right>
vmap <silent> <nowait> <buffer> <2-LeftMouse> <Right>

nmap <silent> <nowait> <buffer> <C-S-f> :find **/
