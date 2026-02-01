" setlocal colorcolumn=80
setlocal wrap
" setlocal comments="/*,\/\/"
setlocal formatoptions=joqmtcn
setlocal wrapmargin=0
setlocal textwidth=0
" setlocal linebreak
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=0
setlocal expandtab
" stop annoying with positioning # to the beginning of the line
setlocal cinkeys-=0#
setlocal cindent
setlocal cinwords+="begin,end,;,#"
setlocal indentkeys-=0#
" setlocal smartindent
" setlocal formatoptions-=cro

let b:verilog_indent_modules=1

" extend gvimrc inoremap for <CR>
" inoremap <expr> <buffer> <silent> <nowait> <CR> pumvisible() ? "<C-y>" : substitute(getline('.'), '\s', '', 'g')[0] == '.' ? "<CR><C-o>:call  AutoAlignIoInstance()<CR>" : "<CR>"

inoremap <buffer> <silent> <nowait> <M-c> <C-o>:call AddLineComment()<CR><End>
snoremap <buffer> <silent> <nowait> <M-c> <C-o>:call AddMultiLineComment()<CR>
xnoremap <buffer> <silent> <nowait> <M-c> :call AddMultiLineComment()<CR>

inoremap <buffer> <silent> <nowait> <M-a> <C-o>:call PromptAlign()<CR>
snoremap <buffer> <silent> <nowait> <M-a> <C-o>:call PromptAlign()<CR>
xnoremap <buffer> <silent> <nowait> <M-a> :call PromptAlign()<CR>

inoremap <buffer> <silent> <nowait> <M-.> <C-o>:call InsertDot()<CR>
snoremap <buffer> <silent> <nowait> <M-.> <C-o>:call InsertDot()<CR>
xnoremap <buffer> <silent> <nowait> <M-.> :call InsertDot()<CR>

inoremap <buffer> <silent> <nowait> <M-,> <C-o>:call AppendComma()<CR>
snoremap <buffer> <silent> <nowait> <M-,> <C-o>:call AppendComma()<CR>
xnoremap <buffer> <silent> <nowait> <M-,> :call AppendComma()<CR>

" inoremap <buffer> <silent> <nowait> <M-s> <C-o>:call RplcSemicolonToDot()<CR>
" snoremap <buffer> <silent> <nowait> <M-s> <C-o>:call RplcSemicolonToDot()<CR>
" xnoremap <buffer> <silent> <nowait> <M-s> :call RplcSemicolonToDot()<CR>

inoremap <buffer> <silent> <nowait> <M-;> <C-o>:call AppendSemicolon()<CR>
snoremap <buffer> <silent> <nowait> <M-;> <C-o>:call AppendSemicolon()<CR>
xnoremap <buffer> <silent> <nowait> <M-;> :call AppendSemicolon()<CR>

inoremap <buffer> <silent> <nowait> <M-8> <C-o>:call FormatIoInstance()<CR>
snoremap <buffer> <silent> <nowait> <M-8> <C-o>:call FormatIoInstance()<CR>
xnoremap <buffer> <silent> <nowait> <M-8> :call FormatIoInstance()<CR>

inoremap <buffer> <silent> <nowait> <M-9> <C-o>:call CloseIoInstance()<CR>
snoremap <buffer> <silent> <nowait> <M-9> <C-o>:call CloseIoInstance()<CR>
xnoremap <buffer> <silent> <nowait> <M-9> :call CloseIoInstance()<CR>

inoremap <buffer> <silent> <nowait> <M-j> <C-o>:call MultiLineComment()<CR>
snoremap <buffer> <silent> <nowait> <M-j> <C-o>:call MultiLineComment()<CR>
xnoremap <buffer> <silent> <nowait> <M-j> :call MultiLineComment()<CR>

function! RenameCmlToSnk(br, wf)
    let l:wordList = []
    let l:rplcList = []
    for l in range(line(1), line('$'))
        if getline(l) !~ '^\/\/' && getline(l) !~ '^\s\+\/\/'
            if (stridx(getline(l), 'input ') != -1 || stridx(getline(l), 'output ') != -1 ) 
                " store inputs/outputs 
                let l:input = substitute(getline(l), ",.*", "", "g")
                let l:input = split(l:input, ' ')
                "echo l:input[-1]
                call add(l:wordList, l:input[-1])
            elseif (stridx(getline(l), 'logic ') != -1 || stridx(getline(l), 'wire ') != -1 || stridx(getline(l), 'reg ') != -1)
                let l:logic = substitute(getline(l), ";.*", "", "g")
                let l:logic = split(l:logic, ' ')
                "echo l:logic[-1]
                call add(l:wordList, l:logic[-1])
            " elseif (stridx(getline(l), 'localparam ') != -1 || stridx(getline(l), 'parameter ') != -1)
            "     let l:param = split(getline(l), '=')
            "     let l:param = split(l:param[0], ' ')[1]
            "     echo l:param
            "     call add(l:wordList, [l:param, '])
            " elseif getline(l) =~# '\..*(.*),'
            "     let l:ioinst = split(getline(l), '(')
            "     let l:io = substitute(l:ioinst[0], "\\s\\+\\.", "", "g")
            "     let l:io = substitute(l:io, "\\s\\+", "", "g")
            "     " echo l:io
            "     call add(l:wordList, [l:io, 1])
            endif
        endif
    endfor
    

    " let l:idx = 0
    " for i in l:wordList
    "     let l:idx = l:idx + 1
    "     let l:iidx = 0
    "     for ii in l:wordList 
    "         let l:iidx = l:iidx + 1
    "         if i[1] == 1 && i[0] == ii[0] && ii[1] == 0
    "             call remove(l:wordList, l:idx)
    "             call remove(l:wordList, l:iidx)
    "         endif
    "     endfor
    " endfor
    
    let l:sedFile = "rplc.vsed"
    call delete(l:sedFile)
    let l:sedList = []
    for i_old in l:wordList
        let l:str = i_old
        let l:i_new = substitute(i_old, "\\\([a-z]\\\)\\\([A-Z]\\\)", "\\1\\_\\l\\2", "g")
        let l:str = l:str." -> ".l:i_new
        let l:i_new = substitute(l:i_new, "\\\([A-Z]\\\)\\\([A-Z]\\\)", "\\l\\1\\l\\2", "g")
        let l:str = l:str." -> ".l:i_new
        let l:i_new = substitute(l:i_new, "\\\([A-Z]\\\)\\\([a-z]\\\)", "\\l\\1\\2", "g")
        let l:str = l:str." -> ".l:i_new
        let l:i_new = substitute(l:i_new, "\_in", "\_i", "g")
        let l:str = l:str." -> ".l:i_new
        let l:i_new = substitute(l:i_new, "\_out", "\_o", "g")
        let l:str = l:str." -> ".l:i_new
        let l:i_new = substitute(l:i_new, "async\_rst", "arst", "g")
        let l:str = l:str." -> ".l:i_new
        let l:i_new = substitute(l:i_new, "sync\_rst", "srst", "g")         
        let l:str = l:str." -> ".l:i_new
        echo l:str
        if (a:br) 
            exec "%s/\\\<".i_old."\\\>/".l:i_new."/g" 
        endif
        " echo l:str
        let l:sedStr = "s/\\\<".i_old."\\\>/".l:i_new."/g"
        call add(l:sedList, l:sedStr)
    endfor

    if (a:wf == 1) 
        call writefile(l:sedList, l:sedFile, 'a')
    else
        echo l:sedList
    endif

    "echo l:wordList
endfunction

function! AddLineComment()
   if len(getline('.')) > 0
      silent! :s/$/ gn\/ /g
   else
      silent! :norm 80i/
   endif
endfunction

function! AddMultiLineComment() range

   silent! exec ":".a:firstline.",".a:lastline."v/\\/\\//s/$/ \\/\\/ /g"
   " silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\/EasyAlign /\\s\\/\\/ / {'lm':0,'rm':0}"
   " silent! exec ":".a:firstline.",".a:lastline."g/\\/\\//s/\\/\\/$/\\/\\/ /g"

endfunction

" Pending fix
function! PromptAlign() range
   call inputrestore()
   let l:sel = input("Select alignment: [a]ssignment -  [c]omment - [d]eclaration - [p]arams - [io] instance: ")
   call inputsave()

   "echom "'<,'>= ".line("'<")." ".line("'>") | 2sleep
   if l:sel == 'a'
      call AlignAssignment()
   elseif l:sel == 'c'
      call AlignComment()
   elseif l:sel == 'd'
      call AlignDeclarations()
      call AlignComment()
   elseif l:sel == 'p'
      call AlignParams()
   elseif l:sel == 'io'
      call AlignIoInstance()
   endif
endfunction

function! AlignAssignment() range
   silent! exec ":".a:firstline.",".a:lastline."EasyAlign /=/ {'lm':1,'rm':1}"
   silent! exec ":".a:firstline.",".a:lastline."EasyAlign /<=/ {'lm':1,'rm':1}"
   silent! exec ":".a:firstline.",".a:lastline."s/\\\s=/=/g"
endfunction

function! AlignComment() 
   silent! exec ":".a:firstline.",".a:lastline."EasyAlign /\/\//  'v/^\\s\\+\\/\\//"
endfunction

function! AlignDeclarations() range
   silent! exec ":".a:firstline.",".a:lastline."s# \+# #g"
   silent! exec ":".a:firstline.",".a:lastline."EasyAlign /\s\a/ {'lm':0,'rm':0}"
   silent! exec ":".a:firstline.",".a:lastline."EasyAlign /\\gn\\\// {'lm':0,'rm':0}"
endfunction

function! AlignParams() range
  silent! exec ":".a:firstline.",".a:lastline."s# \+# #g"
  silent! exec ":".a:firstline.",".a:lastline."EasyAlign /\s[A-Z]/ {'lm':0,'rm':0}"
  silent! exec ":".a:firstline.",".a:lastline."EasyAlign /=/ {'lm':1,'rm':1}"
endfunction

function! AlignIoInstance() range
   silent! exec ":".a:firstline.",".a:lastline."EasyAlign /\./g/\\s\\+\\./l0r0"
   silent! exec ":".a:firstline.",".a:lastline."EasyAlign /(/g/\\s\\+\\./l0r0"
   
endfunction

function! AutoAlignIoInstance()
   let l:cline = line('.')
   let l:fline = l:cline-1
   let l:done = 0

   while substitute(getline(l:fline), '\s', '', 'g')[0] == '.'
      let l:fline = l:fline-1
   endwhile

   let l:fline = l:fline+1
   if l:fline < l:cline
      call AlignIoInstance(l:fline, l:cline)
   endif
   call cursor(l:cline, col('$'))
endfunction

function! RplcSemicolonToDot()
   silent! exec ":".a:firstline.",".a:lastline."s/,/;/g"
endfunction

function! InsertDot() range
   exec ":".a:firstline.",".a:lastline."v/^\\gn^\\\//normal! I."
endfunction

function! AppendComma() range
   silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\//s/\\\s\\\+$//g"
   silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\//normal! A,"
endfunction

function! AppendSemicolon() range
   silent! exec ":".a:firstline.",".a:lastline."v/^\\\s\\+\\gn\\\//s/\\\s\\\+$//g"
   silent! exec ":".a:firstline.",".a:lastline."v/^\\\s\\+\\gn\\\//normal! A;"
endfunction

function! FormatIoInstance() range
    echo a:firstline.",".a:lastline 
    " Substitute = with ( when parameter is found
    silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\/\\|^$/g/).*\\/\\*/s/).*\\/\\*/)/g"
    silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\/\\|^$/g/\\*\\/.*(/s/\\*\\/.*(/(/g"
    silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\/\\|^$/g/parameter /s/ = /(/g"
    " Substitute , with ), when paramater is found
    silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\/\\|^$/g/parameter .*,$/s/,$/),/g"
    " Append ) when last parameter ofathe list is found
    silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\/\\|,\\|^$/g/parameter /normal! A)"
    silent! exec ":".a:firstline.",".a:lastline."v/^\\\s\\+\\/\\/\\|^$/s/module \\s\\+\\|input \\s\\+\\|parameter \\s\\+\\|integer \\s\\+\\|wire \\s\\+\\|output \\s\\+\\|reg \\s\\+\\|logic \\s\\+\\|\\[.*\\]\\s\\+ //g"
    silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\/\\|^$/s/module \\|input \\|parameter \\|integer \\|wire \\|output \\|reg \\|logic \\|\\[.*\\] //g"
    silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\/\\|).*(\\|);\\|#(\\|^$/normal! I."
    silent! exec ":".a:firstline.",".a:lastline."v/\\s\\+\\/\\/\\|(\\|)\\|^$/s/\\s\\+$//g"
    silent! exec ":".a:firstline.",".a:lastline."v/^\\s\\+\\/\\/\\|(\\|)\\|^$/s/,/(),/g"
    silent! exec ":".a:firstline.",".a:lastline."v/\\/\\/\\|#(\\|(.*)\\|);\\|).*(\\|^$/normal! A()"
    silent! exec ":".a:firstline.",".a:lastline."EasyAlign /(/ g/\\s\\+\\./ {'lm':0,'rm':0}"
    " close above /)
endfunction

function! CloseIoInstance() range
   silent! exec ":".a:firstline.",".a:lastline."s/\\s)/)/g"
   silent! exec ":".a:firstline.",".a:lastline."s/\\s\\\+)/)/g"
endfunction

function! MultiLineComment() range
   silent! exec ":".a:firstline.",".a:lastline."normal! I// "
endfunction

function! HasWireRegDeclaration()
   if stridx(getline('.')[:col('.')-1], '//') >= 0
      return 0
   else
      return stridx(getline('.'), 'reg ') >= 0 ||
           \ stridx(getline('.'), 'wire ') >= 0
   fi
endfunction

function! HasIODeclaration()
   if stridx(getline('.')[:col('.')-1], '//') >= 0
      return 0
   else
      return stridx(getline('.'), 'input ') >= 0 || 
           \ stridx(getline('.'), 'output ') >= 0 ||
           \ stridx(getline('.'), 'inout ') >= 0

   fi
endfunction

function! HasParamDeclaration()
   if stridx(getline('.')[:col('.')-1], '//') >= 0
      return 0
   else
      return stridx(getline('.'), 'parameter ') >= 0
   fi
endfunction

function! HasDeclaration()
   return HasIODeclaration() || 
          \ HasWireRegDeclaration() || 
          \ HasParamDeclaration()
endfunction
