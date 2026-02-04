function! TestRange() range
    echo a:firstline.' - '.a:lastline
endfunction

function! ReloadVimRc ()
   if has('gui') && filereadable($MYGVIMRC)
      silent! source $MYGVIMRC
   elseif filereadable($MYGVIMRC)
      silent! source $MYVIMRC
   endif
endfunction

function! AdjTemplate ()

   let l:currYear = strftime('%Y')
   let l:corp = expand($CORP)
   let l:corpemail = expand($EMAIL)
   let l:buffPath = expand('%:r')
   if l:corp == ''
      let l:corp = '<none>'
   endif

   if l:corpemail == ''
      let l:corpemail = '<none@domain.com>'
   endif

   let l:component = substitute(expand('%:p:r'), 
                     \ expand('%:p:h').'/', '', 'g')
   
   silent! exec ":%s/$YEAR/".l:currYear."/g"
   silent! exec ":%s/$CORP/".l:corp."/g"
   silent! exec ":%s/$EMAIL/".l:corpemail."/g"
   silent! exec ":%s/$COMPONENT_NAME/".l:component."/g"
   silent! exec ":%s/$MACRO/".toupper(l:component)."/g"
   silent! exec ":%s/$DATE/".strftime("%d-%m-%Y %H:%M")."/g"
   silent! exec ":%s/$USER/".$USER."/g"
   silent! exec ":%s/$FILE/".expand("%:t")."/g"
   silent! :1

endfunction

function! SetPWD(path)
   silent! exec ":cd! ".a:path
endfunction

function! GetCWD()
   let l:cwd = getcwd()."/"
   return substitute(l:cwd, $HOME."/", "~/", "g")
endfunction

function! GetPWD()
   let l:pwd = execute(':pwd')
   return l:pwd.'/'
endfunction

function! GetCWDRelFPath()
   let l:fpath = expand("%:p")
   return substitute(l:fpath, getcwd()."/", "", "g")
endfunction

function! Eatchar(pat)
   let c = nr2char(getchar(0))
   return (c =~ a:pat) ? '' : c
endfunction

function! ToLower()
    let cursor_pos = getpos(".")
    normal! viwu
    call setpos(".", cursor_pos)
endfunction

function! ToUpper()
    let cursor_pos = getpos(".")
    normal! viwU
    call setpos(".", cursor_pos)
endfunction

function! EchoYellowMsg(msg) range
  echohl StatusLineY
  echo a:msg
  echohl None
endfunction

function! EchoWarnMsg(msg)
  echohl WarningMsg
  echo a:msg
  echohl None
endfunction

function! ProfileStart()
    :profile start profile.log
    :profile func *
    :profile file *
endfunction

function! ProfileStop()
    :profile pause
endfunction

function! s:Log(eventName) abort
  silent execute '!echo '.a:eventName.' >> log'
endfunction

function! PrintVimrcVersion()
   ":normal ! echo "g:vimrcv".<CR>
   call EchoYellowMsg(g:vimrcv)
endfunction

" function! EnterWinBuffer()
"
"    if (&ft != 'help' && &ft != 'netrw' && &ft != 'nerdtree' && &buftype != 'terminal')
"        silent! lcd %:p:h | startinsert
"    else
"        silent! stopinsert
"    endif
"
" endfunction

"function! CtrlPExec()
"    stopinsert | CtrlP l:path
"endfunction

" function! GuiTabLabel()
"      let label = ''
"      let bufnrlist = tabpagebuflist(v:lnum)
" 
"      " Add '+' if one of the buffers in the tab page is modified
"      for bufnr in bufnrlist
"        if getbufvar(bufnr, "&modified")
"          let label = '+'
"          break
"        endif
"      endfor
" 
"      " Append the number of windows in the tab page if more than one
"      let l:wincount = tabpagewinnr(v:lnum, '$')
"      if l:wincount > 1
"        let label .= 'w('.l:wincount.')'
"      endif
"      if label != ''
"        let label .= ' '
"      endif
" 
"      " Append the buffer name
"      let &guitabtooltip = fnamemodify(bufname(bufnrlist[tabpagewinnr(v:lnum) - 1]), ":p")
"      return label . fnamemodify(bufname(bufnrlist[tabpagewinnr(v:lnum) - 1]),  ":t")
" endfunction

function! MyTabLine()
     let s = ''
     for i in range(tabpagenr('$'))
       " select the highlighting
       if i + 1 == tabpagenr()
         let s .= '%#TabLineSel#'
       else
         let s .= '%#TabLine#'
       endif

       " set the tab page number (for mouse clicks)
       let s .= '%' . (i + 1) . 'T'

       " the label is made by MyTabLabel()
       let s .= ' %{MyTabLabel(' . (i + 1) . ')} |'
     endfor

     " after the last tab fill with TabLineFill and reset tab page nr
     let s .= '%#TabLineFill#%T'

     " right-align the label to close the current tab page
     if tabpagenr('$') > 1
       let s .= '%=%#TabLineFill#%999Xx'
     endif

     return s
endfunction

function! MyTabLabel(n)
   let buflist = tabpagebuflist(a:n)
   let winnr = tabpagewinnr(a:n)
   return fnamemodify(bufname(buflist[winnr - 1]), ":t")
endfunction

function! TestTabBuflist()

   let tabn = tabpagenr()

   let buflist = tabpagebuflist(tabn)
   return join(bufname(buflist))
   " let winnr = tabpagewinnr(tabn)
   " return bufname(buflist[winnr - 1])
endfunction

" indent file in one shot
function! Indent()

   let cursor_pos = getpos(".")
   " indent
   normal! gg=G
   "normal! =
   " return to cursor position
   call setpos(".", cursor_pos)
   " endif

endfunction

function! GuiSave()

   if (&ft == 'nerdtree')
      call EchoYellowMsg("Hey dude, you're in nerdtree window...")
   else
     " :%s/\s*$//g
      if empty(bufname('%'))
         browse confirm write
      else
         :w!
      endif
      " :
   endif

endfunction

function! AdjustFontSize(amount)

   let s:pattern = '^\(.* \)\([1-9][0-9]*\)$'
   let s:minfontsize = 6
   let s:maxfontsize = 16

   let fontname = substitute(&guifont, s:pattern, '\1', '')
   let cursize = substitute(&guifont, s:pattern, '\2', '')
   let newsize = cursize + a:amount
   if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
      let newfont = fontname . newsize
      let &guifont = newfont
   endif

endfunction

function! LargerFont()
  call AdjustFontSize(1)
endfunction

function! SmallerFont()
  call AdjustFontSize(-1)
endfunction

" function! PopupBufferList2()
"    
"    let l:menuName = "BuffersList"
"    silent! exec ":aunmenu ".l:menuName
"    " All 'possible' buffers that may exist
"    let l:b_all = range(1, bufnr('$'))
"    " Unlisted ones
"    let l:b_unl = filter(l:b_all, '!buflisted(v:val)')
"    for l:nbuff in l:b_unl
"       let l:menuitem = substitute(bufname(l:nbuff), '\.', '\\.', 'g')
"       :exec ":amenu ]".l:menuName.".".l:menuitem." :b ".string(l:nbuff)."<CR>"
"    endfor
"    :exec ":popup ]".l:menuName
"    
" endfunction

function! JumpToTabWin(tabn, winn)
   silent! exec a:tabn."tabn"
   silent! exec "normal! ".a:winn."\<C-w>w"
endfunction

" function! PopupBufferList()
"    
"    let l:menuName = "BList"
"    silent! exec ":aunmenu ".l:menuName
"    
"    for l:t_idx in range(1, tabpagenr('$'))
"       let l:buf_list = tabpagebuflist(l:t_idx)
"       for l:idx in range(0, (len(l:buf_list)-1))
"          " windows are numbered from 1 to winnr('$')
"          let l:w_idx = l:idx+1
"          let l:menuitem = substitute(fnamemodify(bufname(l:buf_list[l:idx]), ':p:t'), '\.', '\\.', 'g')
"          let l:menuitem = substitute(l:menuitem, ' ', '_', 'g')
"          if empty(l:menuitem)
"             let l:menuitem = 'NoName'
"          endif
"          exec ":amenu ".l:menuName.".".l:menuitem." :call JumpToTabWin(".l:t_idx.",".l:w_idx.")<CR>"
"       endfor
"    endfor
" 
"    :exec ":popup ".l:menuName
"    
" endfunction

function! ClearBufferList()

   "let l:topline = line("w0")
   "let l:botline = line("w$")
   "let l:midline = float2nr((l:topline + l:botline)/2)
   "let l:cpos = getpos(".")
   "let l:cpos[1] = l:midline
   "call setpos(".", l:cpos)

   " All 'possible' buffers that may exist
   let b_all = range(1, bufnr('$'))
   " Unlisted ones
   let b_unl = filter(b_all, 'buflisted(v:val)')
   for nbuff in b_unl
      silent! :exec "bw! ".nbuff
   endfor

endfunction

function! PopupBufferList()
   let l:popupblstnm = []
   let l:blist = filter(range(1, bufnr('$')), 'buflisted(v:val)')
   
   for l:nbuff in l:blist
      let l:menuitem = fnamemodify(bufname(nbuff), ':p:t')
      let l:menuitem = "[".l:nbuff."] ".substitute(l:menuitem, ' ', '_', 'g')
      let l:popupblstnm = add(l:popupblstnm, l:menuitem)
   endfor

   call popup_menu(l:popupblstnm,
                  \ #{title: 'Buffer List',
                  \   pos: 'center',
                  \   scrollbar: 'false',
                  \   border: [],
                  \   padding: [1,1,0,1],
                  \   close: 'click',
                  \   type: 'popupMarker',
                  \   callback: 'PopupBufferChoose',
                  \   highlight: 'Question',
                  \   mapping: 'true'
                  \  }
                  \)
endfunction

function! PopupBufferChoose(id, result)
   echo "Pressed ".a:result
   silent! exec ":b ".a:result
endfunction

" function! BufferList()
" 
"    let l:blstnm = []
"    let l:blist = filter(range(1, bufnr('$')), 'buflisted(v:val)')
"    echohl StatusLineLB
"    echo "Buffer list (current buffer \# not shown)\n"
"    echohl None
"    for l:nbuff in l:blist
"       if l:nbuff != bufnr() 
"          " let l:menuitem = bufname(nbuff)
"          let l:menuitem = fnamemodify(bufname(nbuff), ':p:t')
"          let l:menuitem = substitute(l:menuitem, ' ', '_', 'g')
"          echohl StatusLineY
"          echon "[".l:nbuff."] "
"          echohl None
"          echohl StatusLineW
"          echon fnamemodify(bufname(nbuff), ':p:h')."/"
"          echohl None
"          echohl StatusLineG
"          echon l:menuitem."\n"
"          echohl None
"          " echohl StatusLineY
"          " echon "[".l:nbuff."]\n"
"          " echohl None
" 
"          " echom "[".l:nbuff."] ".l:menuitem
"       endif
"    endfor
"    echohl None
"    
"    let l:cmd = input("Type a buffer cmd [d => delete]: ")
"    if stridx(l:cmd, 'd') == 0
"       exec ":b".l:cmd
"    elseif stridx(l:cmd, '*') == 0
"       exec ":%bwipeout!"
"    else
"       exec ":b ".l:cmd
"    endif
" endfunction

function! BufferListSort(i1, i2) abort
   return a:i1['fname'] == a:i2['fname'] ? 0 : a:i1['fname'] > a:i2['fname'] ? 1 : -1
endfunction

function! BufferList()

   let l:blistshw = []
   let l:blist = filter(range(1, bufnr('$')), 'buflisted(v:val)')
   
   for l:nbuff in l:blist
      let l:blstnmitem = {'fname' : substitute(fnamemodify(bufname(nbuff), ':p:t'), ' ', '_', 'g'), 'fpath' : fnamemodify(bufname(nbuff), ':p:h')."/", 'bnum': l:nbuff}
      call add(l:blistshw, l:blstnmitem)
   endfor
   
   call sort(l:blistshw, 'BufferListSort')
   
   let l:idx = 0
   while l:idx < len(l:blistshw)
      if l:blistshw[l:idx]['bnum'] == bufnr()
         echohl StatusLineG
      else
         echohl StatusLineY
      endif   
      echon "[".l:idx."] "
      echohl None
      echohl StatusLineW
      echon substitute(l:blistshw[l:idx]['fpath'], $HOME, '~', 'g')
      echohl None
      echohl StatusLineG
      echon l:blistshw[l:idx]['fname']
      echohl None
      echohl StatusLineGR
      echon " b#".l:blistshw[l:idx]['bnum']." "
      echohl None
      echohl StatusLineY
      echon "[".l:idx."]\n"
      echohl None
      let l:idx = l:idx + 1
   endwhile
   
   call inputrestore()
   let l:cmd = input("[d,d!,d* &| idx v,s,w]: ")
   call inputsave()

   if l:cmd == ""
      return
   endif

   let l:cmdsplit = split(l:cmd, " ")
   if l:cmdsplit[0] == 'd' || cmdsplit[0] == 'd!'
      let l:nbuffstr = ""
      for l:idxstr in l:cmdsplit[1:]
         let l:nbuffstr = l:nbuffstr.' '.l:blistshw[str2nr(l:idxstr)]['bnum']
      endfor
      exec ":bd! ".l:nbuffstr
   elseif cmdsplit[0] == 'd*'
      exec ":%bwipeout!"
   elseif cmdsplit[0] =~ '\d'
      let l:idx = str2nr(cmdsplit[0])
      if bufexists(l:blistshw[l:idx]['bnum'])
         silent! exec ":b ".l:blistshw[l:idx]['bnum']
         "" if len(l:cmdsplit) == 1
         ""    " check for existing window in current tab
         ""    let l:winIdList = win_findbuf(l:blistshw[l:idx]['bnum'])
         ""    if len(l:winIdList) > 0
         ""       let l:winIdTabList = win_id2tabwin(join(winIdList))
         ""       if len(l:winIdTabList) > 0 && winIdTabList[0] == tabpagenr()
         ""          call win_gotoid(l:winIdList[0])
         ""       endif
         ""    else
         ""       silent! exec ":b ".l:blistshw[l:idx]['bnum']
         ""    endif
         "" else
         ""    if l:cmdsplit[1] == 'v'
         ""       exec ":vsplit ".l:blistshw[l:idx]['fpath'].l:blistshw[l:idx]['fname']
         ""    elseif l:cmdsplit[1] == 's'
         ""       exec ":split ".l:blistshw[l:idx]['fpath'].l:blistshw[l:idx]['fname']   
         ""    elseif l:cmdsplit[1] == 'w'
         ""       let l:winIdList = win_findbuf(l:blistshw[l:idx]['bnum'])
         ""       if len(l:winIdList) > 0
         ""          call win_gotoid(l:winIdList[0])
         ""       endif
         ""    endif
         "" endif
      endif
   endif
endfunction

function! TabsList()
   :tabs
   let l:cmd = input("Type a tab #: ")
   silent! exec ":tabn ".l:cmd
endfunction

function! GetMode()
   let l:mode = mode()
   if l:mode == 'n'
      return 'NORMAL'
   elseif l:mode == 'i'
      return 'INSERT'
   elseif l:mode == 'v'
      return 'VISUAL CHAR'
   elseif l:mode == 'V' 
      return 'VISUAL LINE'
   elseif l:mode == "\<C-V>"
      return 'VISUAL BLOCK'
   elseif l:mode == 's' || l:mode == 'S'
      return 'SELECT'
   elseif l:mode == 'R'
      return 'REPLACE'
   elseif l:mode == 't'
      return 'TERMINAL'
   elseif l:mode == 'c'
      return 'COMMAND'
   else
      return l:mode
   endif
endfunction

function! SetCursorLineMode()
   let l:mode = mode()
   if l:mode == 'n'
      hi CursorLine  guibg=#0007ff
   else
      hi CursorLine guibg=#555555
   endif
endfunction

function! SetStatusLineMode()
   let l:mode = mode()
   if l:mode == 'n'
      hi StatusLine guifg=#ffffff guibg=#0007ff
   elseif l:mode == 'i'
      hi StatusLine guifg=#FFFF00 guibg=#4900B8
   elseif l:mode == 'v' 
      hi StatusLine guifg=#1c5dff guibg=#F3C81B
   elseif l:mode == 'V'
      hi StatusLine guifg=#b602de guibg=#F3C81B
   elseif l:mode == "\<C-v>"
      hi StatusLine guifg=#0007ff guibg=#F3C81B
   elseif  l:mode == 's' || l:mode == 'S'
      hi StatusLine guifg=#4900B8 guibg=#F3C81B
   elseif l:mode == 'R' || l:mode == 'Rv'
      hi StatusLine guifg=#F3C81B guibg=#222222
   elseif l:mode == 't'
      hi StatusLine guifg=#41DF25 guibg=#222222
   " elseif l:mode == 'c'
   "    hi StatusLine guifg=#00FF00 guibg=#222222
   endif
      
endfunction

function! DeleteLineChars()
   normal! ^d$
endfunction

function! DeleteLine()
   normal! dd
endfunction

function! DeleteWord()

   " detect if we are
   " if len(getline('.')[col('.')-1:])
   "    normal! dw
   " elseif match(getline('.'), '^\s*$') != -1
   "    normal! b|dw
   " endif
   "
   if match(getline('.')[col('.')-1:], '^\s*$') != -1
      normal! b
   endif

   normal! dw

endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! Bclose(bang, buffer)

   if empty(a:buffer)
       let btarget = bufnr('%')
   elseif a:buffer =~ '^\d\+$'
       let btarget = bufnr(str2nr(a:buffer))
   else
       let btarget = bufnr(a:buffer)
   endif

   if btarget < 0
       call s:Warn('No matching buffer for '.a:buffer)
       return
   endif
   if empty(a:bang) && getbufvar(btarget, '&modified')
       "call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
       Bclose!
       return
   endif
   " Numbers of windows that view target buffer which we will delete.
   let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
   if !g:bclose_multiple && len(wnums) > 1
       call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
       return
   else
      " if the buffer is open only once, unload it completely from memory
      :bw!
   endif
   let wcurrent = winnr()
   for w in wnums
       execute w.'wincmd w'
       let prevbuf = bufnr('#')
       if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
           buffer #
       else
           bprevious
       endif
       if btarget == bufnr('%')
           " Numbers of listed buffers which are not the target to be deleted.
           let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
           " Listed, not target, and not displayed.
           let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
           " Take the first buffer, if any (could be more intelligent).
           let bjump = (bhidden + blisted + [-1])[0]
           if bjump > 0
               execute 'buffer '.bjump
           else
               execute 'enew'.a:bang
           endif
       endif
   endfor
   execute 'bdelete'.a:bang.' '.btarget
   execute wcurrent.'wincmd w'
endfunction

function! BetterBufferNext() abort

   for b in range(bufnr('%')+1, bufnr('$'))
      if buflisted(b) && bufwinnr(b)==-1
         silent! exe "normal! :b".b."\<cr>"
         return
      endif
  endfor

  for b in range(1, bufnr('%')-1)
      if buflisted(b) && bufwinnr(b)==-1
         silent! exe "normal! :b".b."\<cr>"
         return
      endif
  endfor

endfunction

function! BetterBufferPrev() abort

  for b in range(bufnr('%')-1, 1, -1)
    if buflisted(b) && bufwinnr(b)==-1
      silent! exe "normal! :b".b."\<cr>"
      return
    endif
 endfor

  for b in range(bufnr('$'), bufnr('%')+1, -1)
    if buflisted(b) && bufwinnr(b)==-1
      silent! exe "normal! :b".b."\<cr>"
      return
    endif
  endfor

endfunction

function! InComment(word)
   let l:commidx = stridx(getline('.'), '//')
   let l:wordidx = stridx(getline('.'), a:word)
   return ((l:commidx >= 0) && (l:commidx < l:wordidx))
endfunction

function! AddFtDict()
   let l:ftdictpath = $MYVIMDIR."dictionary/".&ft.".txt"
   if filereadable(l:ftdictpath) > 0
      exec "setlocal dict+=".l:ftdictpath
      exec "setlocal complete+=k".l:ftdictpath
   endif
endfunction

" function! CleverTab()
"
"    if pumvisible() == 0
"       if getline('.')[col('.') - 2] =~ '\w'
"          return "\<C-N>\<C-P>"
"       else
"          return "\<Tab>"
"       endif
"    else
"       return "\<C-N>"
"    endif
"
" endfunction

" function! PromptBufferOption()
"
"    echom "buffer x/c(lose)/n(ew)/o(pen): "
"    let l:char = getchar()
"    if l:char == 99 || l:char == 120
"       " c
"       exec ":silent! Bclose!"
"       if (winnr('$') > 2)
"          exec ":silent! :close!"
"       endif
"    elseif l:char == 110
"       " n
"       exec ":enew!"
"    elseif l:char == 111
"       " o
"       exec ":browse confirm e"
"    endif
"
" endfunction

function! FeedCompletePopUp()
   return "\<C-N>\<C-P>"
endfunction

function! ShowCompletePopUp()
   call feedkeys("\<C-N>\<C-P>", "n")
endfunction

function! AutoCompleteInoremap()

  let s:keysMappingDriven = [
        \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        \ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        \ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        \ 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        \ '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '_' ]
  for key in s:keysMappingDriven
    silent! execute "inoremap <expr> <silent> <nowait> ".key." pumvisible() == 0 ? \"".key."<c-r>=FeedCompletePopUp()<CR>\" : \"".key."\""
  endfor
endfunction

function! GoToLine()

   " silent! set norelativenumber
   " silent! redraw
   call inputsave()
   let l:line = input("Go to line: ")
   call inputrestore()
   silent! exec ":".l:line
   " silent! set relativenumber
   " silent! redraw
endfunction

function! GoToLineIntractv()

   let l:line = line('.')
   let l:col = col('.')

   let l:idx = 0
   let l:strIn = ""
   let l:cInEnter = 13
   let l:cInEsc = 27
   let l:cIn = 0
   echon "Line: ".l:strIn

   while l:cIn != l:cInEnter
      let l:cIn = getchar()
      let l:cInCh = nr2char(l:cIn)

      " if char2nr(l:cIn) >= char2nr('0') && char2nr(l:cIn) <= char2nr('9')
      if l:cIn =~# '\d'
         let l:strIn = l:strIn.l:cInCh
         let l:idx = l:idx + 1
      elseif l:cIn == "\<Backspace>"
         if l:idx > 0
            let l:idx = l:idx - 1
            let l:strIn = strpart(l:strIn, 0, l:idx)
         else
            let l:idx = 0
            let l:strIn = ""
         endif
      endif

      if l:cIn != l:cInEsc
         if strlen(l:strIn) > 0
            if l:strIn == '$'
               silent! :$
            else
               call cursor(str2nr(l:strIn), l:col)
            endif
         else
            call cursor(1, l:col)
         endif

         silent! zz
         silent! redraw
         
         echon "Line: ".l:strIn
      else
         let l:cIn = l:cInEnter
         " call cursor(l:line, l:col)
         silent! exec ":".l:line
         silent! exec "|".l:col
      endif
   endwhile
   
endfunction

" function! GoToLineCol()
"
"    let l:cLine = line('.')
"    let l:cCol = col('.')
"    let l:nLine = l:cLine
"    let l:nCol = l:cCol
"
"    call inputrestore()
"    let l:inStr = input("Go to [l (.),c]: ")
"    call inputsave()
"
"    if len(l:inStr) == 0
"       return
"    endif
"
"    let l:splitStr = split(l:inStr, ",")
"    let l:lineStr = l:splitStr[0]
"    let l:colStr = l:cCol
"    if len(l:splitStr) > 1
"       let l:colStr = l:splitStr[1]
"    endif
"
"    "echom "splitStr: ".join(l:splitStr) | sleep
"    "echom "len splitStr: ".len(l:splitStr) | sleep
"    "echom "Line: ".l:splitStr[0]." - Col: ".l:splitStr[1] | sleep
"
"    let l:nLine = l:cLine
"    let l:nCol = l:cCol
"
"    if stridx(l:lineStr, '+') == 0
"       let l:nLine = l:cLine + l:lineStr[1:]
"    elseif stridx(l:lineStr, '-') == 0
"       let l:nLine = l:cLine - l:lineStr[1:]
"    elseif l:lineStr == '.'
"       let l:nLine = l:cLine
"    else
"       let l:nLine = l:lineStr
"    endif
"
"    if stridx(l:colStr, '+') == 0
"       let l:nCol = l:cCol + l:colStr[1:]
"    elseif stridx(l:colStr, '-') == 0
"       let l:nCol = l:cCol - l:colStr[1:]
"    elseif l:nCol == '.'
"       let l:nCol = l:cCol
"    elseif l:nCol == '$'
"       let l:nCol = col('$')
"    else
"       let l:nCol = l:colStr
"    endif
"
"    call cursor(l:nLine, l:nCol)
" endfunction

" function! GoToCol()
"
"    let l:line = line('.')
"    let l:col = input("Go to column: ")
"    call cursor(l:line, l:col)
"
" endfunction

" function! PromptHelp()
"
"    let l:helpstr = input("Help: ")
"    if len(l:helpstr) != 0
"       exec ":h ".l:helpstr
"    endif
"
" endfunction

function! PromptFindI()
   :promptfind
endfunction

function! PromptReplI()
   :promptrepl
endfunction

" pending interactive implementation
" function! PromptFindI()
"
"    call inputrestore()
"    let l:sword = input("[F] Find: ")
"    call inputsave()
"    echom l:sword
"    silent! call search(l:sword, 'w')
"
" endfunction

function! TestGetChar()
   let l:c = 0
   let l:cInEsc = 27
   let l:cIn = 0
   while l:cIn != l:cInEsc
      let l:cIn = getchar()
      echom "l:cIn = ".l:cIn." = nr2char(".l:cIn.") = ". nr2char(l:cIn)
   endwhile
endfunction

function! TestSetLine()
   let l:line=line('.')
   let l:c = 0
   let l:cInEsc = 27
   let l:cIn = 0
   while l:cIn != l:cInEsc
      let l:cIn = getchar()
      "echom "l:cIn = ".l:cIn." = nr2char(".l:cIn.") = ". nr2char(l:cIn)
      for l:lidx in range(l:line, l:line+4)
         call setline(l:lidx, getline(l:lidx).l:cIn)
      endfor
      silent! redraw
   endwhile
endfunction

function! PromptFindI()

   let l:line = line('.')
   let l:col = col('.')
   let l:idx = 0
   let l:strIn = ""
   let l:cInEnter = 13
   let l:cInEsc = 27
   let l:cInCtrlV = 22
   let l:cIn = 0

   echon "[F] Find: "
   " set hlsearch
   while l:cIn != l:cInEnter

      let l:cIn = getchar()
      let l:cInCh = nr2char(l:cIn)

      " if char2nr(l:cIn) >= char2nr('0') && char2nr(l:cIn) <= char2nr('9')
      if l:cIn == "\<Backspace>"
         if l:idx > 0
            let l:idx = l:idx - 1
            let l:strIn = strpart(l:strIn, 0, l:idx)
         else
            let l:idx = 0
            let l:strIn = ""
         endif
      elseif l:cIn == l:cInCtrlV
         let l:strIn = l:strIn.@*
         let l:idx = l:idx + strlen(@*)
      else
         let l:strIn = l:strIn.l:cInCh
         let l:idx = l:idx + 1
      endif

      if l:cIn != l:cInEsc

         if strlen(l:strIn) > 0
            call search(l:strIn, 'wcz')
            silent! exec ":match Search /".l:strIn."/"
         endif

         redraw!
         echon "[F] Find: ".l:strIn

      else
         silent! exec ":match Search //"
         let l:cIn = l:cInEnter
         call cursor(l:line, l:col)
         redraw!
      endif
   endwhile
   " set nohlsearch
endfunction

" pending interactive implementation
function! PromptReplExctI()
   call inputrestore()
   let l:cLine = line('.')
   let l:cCol = col('.')
   let l:sword = input("[F/R exct] Find: ")
   let l:rword = input("[F/R exct] Repl: ")
   call inputsave()
   if len(l:rword) > 0
      silent! exec ":%s/\\<".l:sword."\\>/".l:rword."/g"
   endif
   call cursor(l:cLine, l:cCol)
endfunction

" pending interactive implementation
function! PromptReplI()
   call inputrestore()
   let l:cLine = line('.')
   let l:cCol = col('.')
   let l:sword = input("[F/R] Find: ")
   let l:rword = input("[F/R] Repl: ")
   call inputsave()
   if len(l:rword) > 0
      silent! exec ":%s/".l:sword."/".l:rword."/g"
   endif
   call cursor(l:cLine, l:cCol)
endfunction

" pending interactive implementation
function! PromptFindS()
   let l:sword = @*
   echom "[F] Find: ".l:sword
   call search(l:sword, 'wcz')
endfunction

function! PromptReplExctS()
   let l:cLine = line('.')
   let l:cCol = col('.')
   let l:sword = @*
   echom "[F/R] Find: ".l:sword
   call inputrestore()
   let l:rword = input("[F/R exct] Repl: ")
   call inputsave()
   if len(l:rword) > 0
      silent! exec ":%s/\\<".l:sword."\\>/".l:rword."/g"
   endif
   call cursor(l:cLine, l:cCol)
endfunction

function! PromptReplS()
   let l:cLine = line('.')
   let l:cCol = col('.')
   let l:sword = @*
   echom "[F/R] Find: ".l:sword
   call inputrestore()
   let l:rword = input("[F/R] Repl: ")
   call inputsave()
   if len(l:rword) > 0
      silent! exec ":%s/".l:sword."/".l:rword."/g"
   endif
   call cursor(l:cLine, l:cCol)
endfunction

function! ExecCmd()

   let l:cmd = input(":")
   exec ":".l:cmd

endfunction

function! PageUp()

   let l:cCol = col('.')
   let l:winheight = winheight('.')
   let l:firstvline = line('w0')
   
   call cursor(l:firstvline+1, l:cCol)
   call execute('normal! zb')
   if (l:firstvline == 1)
      call cursor(1, l:cCol)
   endif

endfunction

function! ScrollWheelUp(scroll)

   let l:cLine = line('.')
   let l:cCol = col('.')
   let l:winheight = winheight('.')
   let l:firstvline = line('w0')
   let l:bfirstline = 1
   
   if (l:firstvline == 1) || (l:cLine <= a:scroll)
      call cursor(1, l:cCol)
   else
      call cursor(l:cLine-a:scroll, l:cCol)
   endif

endfunction

function! PageDown()

   let l:cCol = col('.')
   let l:winheight = winheight('.')

   let l:lastvline = line('w$')
   let l:blastline = line('$')

   if (l:blastline - l:lastvline) >= l:winheight
      call cursor(l:lastvline-1, l:cCol)
      call execute('normal! zt')
   else
      call cursor(l:blastline, l:cCol)
   endif

endfunction

function! ScrollWheelDown(scroll)

   let l:cLine = line('.')
   let l:cCol = col('.')
   let l:winheight = winheight('.')

   let l:lastvline = line('w$')
   let l:blastline = line('$')

   if (l:blastline - l:lastvline) >= l:winheight
       call cursor(l:cLine+a:scroll, l:cCol)
   else
      call cursor(l:blastline, l:cCol)
   end
endfunction

function! GoToTab()
   $tabmove
   let bufnr = tabpagebuflist()[0]
   let tabnr = tabpagenr()
   for tabindex in range(1, tabpagenr('$'))
      if tabnr == tabindex
         continue
      endif
      let bufnrs = tabpagebuflist(tabindex)
      let bufindex = index(bufnrs, bufnr)
      if bufindex >= 0
         execute "tabn" .. tabindex
         execute "tabclose" .. tabnr
         break
      endif
   endfor
endfunction

function! GoToFirstWin()
   exec "normal! 1\<C-w>w"
endfunction

function! GoToLastWin()
   let l:lastWin = winnr('$')
   silent! exec "normal! ".l:lastWin."\<C-w>w"
endfunction

function! GoToPrevWin()
   let l:prevWin = winnr()-1
   call EchoYellowMsg(bufname(winbufnr(l:prevWin)))
   exec "normal! ".l:prevWin."\<C-w>w"
endfunction

function! GoToNextWin()
   let l:nextWin = winnr()+1
   call EchoYellowMsg(bufname(winbufnr(l:nextWin)))
   exec "normal! ".l:nextWin."\<C-w>w"
endfunction

function! GoToWin()

   let l:win = input("Go to win #")
   exec l:win."\<C-w>w"

endfunction

function! IsBlank( bufnr )
    return (empty(bufname(a:bufnr)) &&
    \ getbufvar(a:bufnr, '&modified') == 0 &&
    \ empty(getbufvar(a:bufnr, '&buftype'))
    \)
endfunction

function! ExistOtherBuffers( targetBufNr )
    return ! empty(filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != a:targetBufNr'))
endfunction

function! IsEmptyVim()
    let l:currentBufNr = bufnr('')
    return IsBlank(l:currentBufNr) && ! ExistOtherBuffers(l:currentBufNr)
endfunction

function! IsEmptyBuffer()
   if (line('$') == 1 && getline('.') == '') || wordcount()['words'] == 0
      return 1
   else
      return 0
   endif
endfunction

function! BuffInMoreWins(bnum)
   
   let l:buflist = []
   
   for l:t_i in range(1, tabpagenr('$'))
      let l:buflist += tabpagebuflist(l:t_i)
   endfor
   
   return count(l:buflist, a:bnum)
endfunction

function! CloseBuffer()
   
   if tabpagenr('$') > 1 || winnr('$') > 1
      let l:b_count = BuffInMoreWins(bufnr())
      if l:b_count > 1
         " echo "l:b_count > 1" | sleep
         silent! :close!
      else 
         let l:bufnr = bufnr()
         " echo "l:b_count = 1" | sleep
         silent! :bnext!
         silent! exec ":bd! ".l:bufnr
      endif
   else
      if IsEmptyBuffer() && IsEmptyVim()
         call EchoWarnMsg('Last win empty buffer, q to quit')
         if nr2char(getchar()) == 'q'
            silent! :q!
         endif
      else 
         " echo ":bw!" | sleep
         silent! :bw!
      endif
   endif
      
endfunction

" Return hex string equivalent to given decimal string or number.
"function! Dec2hex(arg)
"  return printf('%x', a:arg + 0)
"endfunction

" Return number equivalent to given hex string ('0x' is optional).
"function! Hex2dec(arg)
"  return (a:arg =~? '^0x') ? a:arg + 0 : ('0x'.a:arg) + 0
"endfunction

" function! CloseBuffer()
"    
"    let l:b_name = bufname()
"    let l:w_num = winnr('$')
"    let l:t_num = tabpagenr('$')
"    let l:b_count = 0
"    let l:btot = 0
" 
"    if IsEmptyVim()
"       call EchoWarnMsg('Last win empty buffer, q to quit')
"       if nr2char(getchar()) == 'q'
"          silent! :q
"       endif
"    else
"       for l:t_idx in range(1, l:t_num)
"          let l:buf_list = tabpagebuflist(l:t_idx)
"          for l:b_i in range(0, (len(l:buf_list)-1))
"             if bufname(l:buf_list[l:b_i]) == l:b_name
"                let l:b_count = l:b_count + 1
"             endif
" 
"             let l:btot = l:btot + 1
"          endfor
"       endfor
"    endif
" 
"    " if we have a duplicated buffer,
"    " just close the window
"    if l:btot == 1
"       call EchoWarnMsg('Last win empty buffer, q to quit')
"       if nr2char(getchar()) == 'q'
"          silent! :q
"       endif
"    else 
"       if l:b_count > 1
"          if &ft == 'netrw' || (line('.') == 1 && getline('.') == '')
"             silent! :bw!
"             silent! :close!
"          else
"             " echo "Duplicated buffer"
"             silent! :close!
"          endif
"       else
"          silent! :bw!
"          " if l:t_num > 1 || l:w_num > 1
"          "    " echo "l:t_num > 1 || l:w_num > 1"
"          "    silent! :close!
"          " elseif l:w_num == 1
"          "    " echo "l:w_num == 1"
"          "    silent! :bw!
"          " endif
"       endif
"    endif
" 
"    call DeleteHiddenBuffers()
" 
"    " if l:t_num || (l:b_count > 1 && l:w_num > 1)
"    "    " just close the window of the duplicated buffer
"    "    silent! :close
"    " else 
"    "    silent! :bw!
"    " endif
" 
" endfunction

function DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute ':bw!' buf
    endfor
endfunction

function! HighlightSearch(timer)
    if (g:firstCall)
        let g:originalStatusLineHLGroup = execute("hi StatusLine")
        let g:firstCall = 0
    endif
    if (exists("g:searching") && g:searching)
        let searchString = getcmdline()
        if searchString == "" 
            let searchString = "."
        endif
        let newBG = search(searchString) != 0 ? "green" : "red"
        if searchString == "."
            set whichwrap+=h
            normal h
            set whichwrap-=h
        endif
        execute("hi StatusLine ctermfg=" . newBG)
        let g:highlightTimer = timer_start(50, 'HighlightSearch')
        let g:searchString = searchString
    else
        let originalBG = matchstr(g:originalStatusLineHLGroup, 'ctermfg=\zs[^ ]\+')
        execute("hi StatusLine ctermfg=" . originalBG)
        if exists("g:highlightTimer")
            call timer_stop(g:highlightTimer)
            call HighlightCursorMatch()
        endif
    endif
endfunction

function! HighlightCursorMatch() 
    try
        let l:patt = '\%#'
        if &ic | let l:patt = '\c' . l:patt | endif
        exec 'match IncSearch /' . l:patt . g:searchString . '/'
    endtry
endfunction

function! IsWordUnderCursor()
   return getline(".")[col(".")-1] =~# '\w'
endfunction

function! HighlightWordUnderCursor()
    if IsWordUnderCursor()
        " exec 'match HighCW /\<'.expand('<cword>').'\>/'
        exec 'match HighCW /'.expand('<cword>').'/'
    else 
        match none 
    endif
endfunction

function! ConvBase(base)
   return string(str2nr(getreg('*'), a:base))
endfunction

function! Fold()
   EchoYellowMsg('Empty fold function, implement in after/ftplugin dir')
endfunction

function! TagJump (tag_word)

   silent! exec ":tjump ".a:tag_word
   call search(a:tag_word)
   call setreg('/', '')
   
endfunction

function! TagList(tag_word)

   let l:taglst = taglist(a:tag_word)
   let l:num = 0
   
   if len(l:taglst) == 0
      call EchoYellowMsg("No tags found")
   elseif len(l:taglst) == 1
      silent! exec ":split ".l:taglst[l:num].filename
      silent! exec l:taglst[l:num].cmd
   else
      let l:taglst = sort(l:taglst, 'l')

      echohl None
      echon "Tag: "
      echohl None
      echohl StatusLineLB
      echon a:tag_word."\n"
      echohl None
      for l:tag in l:taglst
         let l:tname = l:tag.name
         let l:tfilename = l:tag.filename
         let l:tstatic = l:tag.static
         let l:tcmd = l:tag.cmd
         let l:tcmdv = substitute(l:tcmd, '\/', '', 'g')
         let l:tcmdv = substitute(l:tcmdv, '\^', '', 'g')
         echohl StatusLineY
         echon "[".l:num."] "
         echohl None
         echohl StatusLineW
         echon l:tfilename." "
         echohl None
         echohl StatusLineG
         echon l:tcmdv."\n"
         echohl None
         let l:num = l:num + 1
      endfor
      
      let l:num = input("Type a tag #: ")
      if l:num =~# '^\d\+$'
         silent! exec ":split ".l:taglst[l:num].filename
         silent! exec l:taglst[l:num].cmd
      endif
   endif

endfunction

function! TagListXref(tag_word)
   echohl None
   echon "Tag: "
   echohl None
   echohl StatusLineLB
   echon a:tag_word."\n"
   echohl None

   let l:tagfile = expand('~/.tags')
   let l:tags = filter(readfile(l:tagfile), 'v:val =~ "'.a:tag_word.'"')
   
   if len(l:tags) == 1
      let l:splittag = split(l:tags[l:num], ',')
      silent! exec ":split ".l:splittag[1]
      silent! exec l:splittag[2]
   else
      let l:num = 0
      for l:tag in l:tags
         let l:splittag = split(l:tag, ',')
         let l:tname = l:splittag[0]
         let l:tfilename = l:splittag[1]
         let l:tcmd = l:splittag[2]
         let l:tvalue = l:splittag[3]
         echohl StatusLineY
         echon "[".l:num."] "
         echohl None
         echohl StatusLineW
         echon fnamemodify(l:tfilename, ':p:h').'/'
         echohl None
         echohl StatusLineG
         echon fnamemodify(l:tfilename, ':p:t')." "
         echohl None
         echohl StatusLineLB
         echon l:tvalue."\n"
         echohl None
         let l:num = l:num + 1
      endfor
      
      let l:num = input("Type a tag #: ")
      if l:num =~# '^\d\+$' && l:num >= 0 && l:num < len(l:tags)
         let l:splittag = split(l:tags[l:num], ',')
         if bufnr(l:splittag[1]) == -1
            silent! exec ":split ".l:splittag[1]
         elseif bufwinnr(l:splittag[1]) != -1
            silent! exec ":".bufwinnr(l:splittag[1])."\<C-w>w"
         endif
         silent! exec l:splittag[2]
      endif
   endif
   
endfunction

function! StrSub(astr)
   let l:str = substitute(a:astr, '\\/', '\\\/', 'g')
   return l:str
endfunction

function! AdjStr(reg)
   let l:srchstr = substitute(getreg(a:reg), '\/', '\\\/', 'g')
   let l:srchstr = substitute(l:srchstr, '\[', '\\\[', 'g')
   let l:srchstr = substitute(l:srchstr, '\]', '\\\]', 'g')
   let l:srchstr = substitute(l:srchstr, '\n', '\\n', 'g')
   let l:srchstr = substitute(l:srchstr, '\*', '\\*', 'g')
   return l:srchstr
endfunction

function! HighlightSet(name, ...)
    let colour_order = ['guifg', 'guibg', 'gui', 'ctermfg', 'ctermbg', 'cterm', 'term']
    let command = 'hi ' . a:name
    if (len(a:000) < 1) || (len(a:000) > (len(colour_order)))
        echoerr "No colour or too many colours specified"
    else
        for i in range(0,len(a:000)-1)
            let command .= ' ' . colour_order[i] . '=' . a:000[i]
        endfor
        exe command
    endif
endfunc

function! GetDate()
   let l:date = strftime('%a %Y-%m-%d %H:%M:%S%z')
   return l:date
endfunction

function! InsHeader()
    exec ":0r ".$MYVIMDIR."/templates/header/header.txt"
    call AdjTemplate()
endfunction

function! InsFooter()
    exec ":$r ".$MYVIMDIR."/templates/header/footer.txt"
    call AdjTemplate()
endfunction

function! MakePatch(afile, bfile)
   EchoYellowMsg("Nothing to do")
endfunction

function! SetIndentMarks ()
   let l:tabstop = &tabstop
   let l:tabstop = l:tabstop-1
   let l:leadSpace = repeat('\ ', l:tabstop)."\¦"
   exec ":setlocal listchars+=leadmultispace:".l:leadSpace
endfunction

function! InsTxtFromFile(path, line)
   let l:vbckp = getreg('v')
   let @v=join(readfile(a:path), "\n") 
   silent! exec ":".a:line."put v"
   let @v=l:vbckp
endfunction

function! JumpToPrevIndent()
   let l:prevcol = match(getline(line('.')-1), '\S')+1
   exec "normal! ".l:prevcol."A "
endfunction

function! ReformatStr(str) 
   let l:str = substitute(a:str, '\/', '\\\/', 'g')
   let l:str = substitute(l:str, '\[', '\\\[', 'g')
   let l:str = substitute(l:str, '\]', '\\\]', 'g')
   let l:str = substitute(l:str, '\n', '\\n', 'g')
   let l:str = substitute(l:str, '\*', '\\*', 'g')
   return l:str
endfunction

function! Replace(str, iret)
    call inputsave()
    let l:rplc = input("Replace: ".a:str." to: ", a:str)
    call inputrestore()
    redraw
    let l:rplc = ReformatStr(l:rplc)
    silent! exec ":%s/".a:str."/".l:rplc."/g | normal! g``"
    echo "Replaced ".a:str." to: ".l:rplc
    
    if (a:iret)
        startinsert
    endif
endfunction

function! SwapStr (a, b) range
    let l:rand = string(rand())
    let l:a_rnd = a:a."_".l:rand
    
    silent! exec a:firstline.",".a:lastline."s/".a:a."/".l:a_rnd."/g"
    silent! exec a:firstline.",".a:lastline."s/".a:b."/".a:a."/g"
    silent! exec a:firstline.",".a:lastline."s/".l:a_rnd."/".a:b."/g"
endfunction

" highlight the visual selection after pressing enter.
"snoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
" vnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
command! -bang -complete=buffer -nargs=? Bclose call s:Bclose('<bang>', '<args>')
command! -nargs=1 ClearReg call setreg(<f-args>, "")
command! -nargs=1 Diffsplit :vertical diffsplit <args>
command! -range -nargs=+ SwapStr :<line1>,<line2>call SwapStr (<f-args>)
" command! -nargs=2 MakePatch :call MakePatch(<f-args>)<CR>
command! -nargs=+ HiSet call HighlightSet(<f-args>)
command! -bang -nargs=0 InsDate :normal! i<C-r>=GetDate()<CR>
command! -nargs=0 SetIMarks :call SetIndentMarks()
command! ClearBufferList :call ClearBufferList()
command! InsHeader :call InsHeader()
command! InsFooter :call InsFooter()
