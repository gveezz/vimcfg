let s:save_cpo = &cpoptions
set cpoptions&vim

let w:vimfm_last_bufnr = -1

function! s:keep_buffer_singularity() abort
    let related_win_ids = vimfm#compat#win_findbuf(bufnr('%'))
    if len(related_win_ids) <= 1
        return 1
    endif

    " Detected multiple windows for single buffer:
    " Duplicate the buffer to avoid unwanted sync between different windows
    call vimfm#buffer#duplicate()

    return 1
endfunction

function! s:lnum_to_item_index(lnum) abort
    return a:lnum - 1
endfunction

function! s:get_cursor_items(filer, mode) abort
    let items = a:filer.items
    if empty(items)
        return []
    endif

    let in_visual_mode = (a:mode ==? 'v')
    let lnums = in_visual_mode
                \ ? range(line('''<'), line('''>'))
                \ : [line('.')]
    return map(
                \ copy(lnums),
                \ 'items[s:lnum_to_item_index(v:val)]')
endfunction

function! s:get_selected_items(filer) abort
    let items = a:filer.items
    let selected_items = filter(
                \ copy(items),
                \ 'v:val.selected')
    if !empty(selected_items)
        return selected_items
    endif

    return s:get_cursor_items(a:filer, 'n')
endfunction


function! s:should_wipe_out(bufnr) abort
    if !bufexists(a:bufnr)
        return 0
    endif

    return vimfm#buffer#is_for_vimfm(a:bufnr)
                \ && !buflisted(a:bufnr)
                \ && !bufloaded(a:bufnr)
endfunction

function! s:clean_up_outdated_buffers() abort
    let all_bufnrs = range(1, bufnr('$'))
    let outdated_bufnrs = filter(
                \ all_bufnrs,
                \ 's:should_wipe_out(v:val)')
    for bufnr in outdated_bufnrs
        execute 'silent bwipeout '.bufnr
    endfor
endfunction

" a:000[0]: path
" a:000[1]: should_overwrite
function! vimfm#init(...) abort

    if &ft != 'vimfm'
        " Save las buffer number
        let w:vimfm_last_bufnr = bufnr()
    end

    let path = get(a:000, 0, '')
    if empty(path)
        let path = getcwd()
    endif

    let should_overwrite = get(a:000, 1, 0)

    let extracted_path = vimfm#buffer#extract_path_from_bufname(path)
    let path = !empty(extracted_path)
                \ ? extracted_path
                \ : path 

    let path = fnamemodify(path, ':p')

    if !isdirectory(path)
        " Open new directory buffer and overwrite it
        " (will be initialized by vimfm#event#on_bufenter)
        let dir = fnamemodify(path, ':h')
        execute 'edit '.fnameescape(dir)

        call vimfm#buffer#move_cursor_to_path(
                    \ fnamemodify(path, ':p'))
        return
    endif

    try
        call s:clean_up_outdated_buffers()

        if !should_overwrite && !vimfm#buffer#is_for_vimfm(bufnr('%'))
            enew
        endif

        let filer = vimfm#filer#create(path)
        call vimfm#filer#inherit(filer, vimfm#buffer#get_filer())
        let filer.items = vimfm#file#create_items_from_dir(
                    \ filer.dir,
                    \ filer.shows_hidden_files)

        call vimfm#buffer#init(filer)
    catch /:E37:/
        call vimfm#util#echo_error('E37: No write since last change')
        return
    endtry
endfunction


function! vimfm#refresh() abort
    call s:keep_buffer_singularity()

    let filer = vimfm#buffer#get_filer()
    let cursor_items = s:get_cursor_items(filer, 'n')
    if !empty(cursor_items)
        call vimfm#buffer#save_cursor(cursor_items[0])
    endif

    let new_filer = vimfm#filer#create(filer.dir)
    call vimfm#filer#inherit(new_filer, filer)
    let new_filer.items = vimfm#file#create_items_from_dir(
                \ new_filer.dir,
                \ new_filer.shows_hidden_files)
    call vimfm#buffer#set_filer(new_filer)

    call vimfm#buffer#redraw()
endfunction


function! vimfm#open_current(open_mode) abort
    call s:keep_buffer_singularity()

    let filer = vimfm#buffer#get_filer()
    let item = get(
                \ s:get_cursor_items(filer, 'n'),
                \ 0,
                \ {})
    if empty(item)
        return
    endif

    call vimfm#buffer#save_cursor(item)

    call vimfm#file#open([item], a:open_mode)
endfunction


function! vimfm#open_selected(open_mode) abort
    call s:keep_buffer_singularity()

    let filer = vimfm#buffer#get_filer()
    let items = s:get_selected_items(filer)
    if empty(items)
        return
    endif

    call vimfm#buffer#save_cursor(items[0])

    call vimfm#file#open(items, a:open_mode)
endfunction


function! vimfm#open(path) abort
    call s:keep_buffer_singularity()

    let filer = vimfm#buffer#get_filer()
    let filer_dir = filer.dir

    let cursor_items = s:get_cursor_items(filer, 'n')
    if !empty(cursor_items)
        call vimfm#buffer#save_cursor(cursor_items[0])
    endif

    let new_dir = isdirectory(expand(a:path)) ?
                \ expand(a:path) :
                \ fnamemodify(expand(a:path), ':h')
    let new_item = vimfm#item#from_path(new_dir)
    call vimfm#file#open([new_item], '')

    " Move cursor to previous current directory
    let prev_dir_item =vimfm#item#from_path(filer_dir)
    call vimfm#buffer#save_cursor(prev_dir_item)
    call vimfm#buffer#restore_cursor()
endfunction

function! vimfm#open_parent() abort
    let filer = vimfm#buffer#get_filer()
    let parent_dir = fnameescape(fnamemodify(filer.dir, ':h:p'))
    call vimfm#open(parent_dir)
endfunction


function! vimfm#toggle_current(mode) abort
    call s:keep_buffer_singularity()

    let filer = vimfm#buffer#get_filer()
    let items = s:get_cursor_items(filer, a:mode)
    if empty(items)
        return
    endif

    if len(items) == 1
        let item = items[0]
        let item.selected = item.selected ? 0 : 1

        call vimfm#buffer#redraw_item(item)

        " Move cursor to next item
        normal! j0

        return
    endif

    let selected = items[0].selected ? 0 : 1
    for item in items
        let item.selected = selected
        call vimfm#buffer#redraw_item(item)
    endfor
endfunction

function! vimfm#returnto_buffer()
    if exists("w:vimfm_last_bufnr") && (w:vimfm_last_bufnr != -1)
        if bufexists(w:vimfm_last_bufnr)
            exec "b ".w:vimfm_last_bufnr
        endif
    endif
endfunction

function! vimfm#toggle_all() abort
    call s:keep_buffer_singularity()

    let items = vimfm#buffer#get_filer().items
    if empty(items)
        return
    endif

    call vimfm#set_selected_all(
                \ !items[0].selected)
endfunction

function! vimfm#set_selected_all(selected) abort
    call s:keep_buffer_singularity()

    for item in vimfm#buffer#get_filer().items
        let item.selected = a:selected
    endfor

    call vimfm#buffer#redraw()
endfunction

function! vimfm#quit() abort
    " keep_buffer_singularity may create a new buffer so we
    " need to stash the current buffer beforehand
    let cur = bufnr('%')
    call s:keep_buffer_singularity()

    " Try restoring alternate buffer
    let alt = bufnr('#') > 0 ? bufnr('#') : -1
    " the case where cur == alt is when there are no other
    " buffers except for vimfm
    if bufexists(alt) && cur != alt
        execute 'buffer! '.alt
        return
    endif

    enew
endfunction


function! vimfm#delete_selected() abort
    call s:keep_buffer_singularity()

    let items = s:get_selected_items(
                \ vimfm#buffer#get_filer())
    if empty(items)
        return
    endif

    " pending setting (Y/n)
    let message = (len(items) == 1)
                \ ? "Delete '".items[0].basename."' (Y/n)? "
                \ : "Delete ".len(items)." selected files (y/N)? "
    let yn = input(message)
    if yn == 'n' || yn == 'N'
        call vimfm#util#echo('Cancelled.')
        return
    endif

    let lnum = line('.')

    call vimfm#file#delete(items)
    call vimfm#refresh()

    " Restore cursor position
    call vimfm#buffer#move_cursor_to_lnum(lnum)
endfunction


function! vimfm#move_selected() abort
    call s:keep_buffer_singularity()

    let filer = vimfm#buffer#get_filer()
    let items = s:get_selected_items(filer)
    if empty(items)
        return
    endif

    let message = (len(items) == 1)
                \ ? "Move '".items[0].basename."' to: "
                \ : "Move ".len(items)." selected files to: "
    let dst_name = input(message, '', 'dir')
    if empty(dst_name)
        call vimfm#util#echo("Cancelled.")
        return
    endif

    call vimfm#file#move(
                \ vimfm#buffer#get_filer(),
                \ items, dst_name)
    call vimfm#refresh()
endfunction


function! vimfm#mkdir() abort
    call s:keep_buffer_singularity()

    let name = input('New directory name: ', '', 'dir')
    if empty(name)
        call vimfm#util#echo('Cancelled.')
        return
    endif

    call vimfm#file#mkdir(
                \ vimfm#buffer#get_filer(),
                \ name)
    call vimfm#refresh()
endfunction

" function! vimfm#cp() abort
" 
"     let l:isdir = 0
"     call s:keep_buffer_singularity()
"     let items = s:get_selected_items(vimfm#buffer#get_filer())
"     if empty(items)
"         return
"     endif
" 
"     if isdirectory(items)
"         let l:isdir = 1 
"     endif
"     
"     if (l:isdir) 
"         let name = input('Enter destination: ', '', 'dir')
"     else 
"         let name = input('Enter destination: ', '', 'file') 
"     endif
"     
"     if empty(name)
"         call vimfm#util#echo('Cancelled.')
"         return
"     endif
" 
"     call vimfm#file#mkdir(vimfm#buffer#get_filer(), name)
"     call vimfm#refresh()
" endfunction

function! vimfm#new_file() abort
    call s:keep_buffer_singularity()

    let name = input('New file name: ', '', 'file')
    if empty(name)
        call vimfm#util#echo('Cancelled.')
        return
    endif

    call vimfm#file#edit(vimfm#buffer#get_filer(), name)
endfunction


function! vimfm#rename_selected() abort
    call s:keep_buffer_singularity()

    let items = s:get_selected_items(vimfm#buffer#get_filer())
    if empty(items)
        return
    endif

    if len(items) == 1
        let def_name = vimfm#util#get_last_component(
                    \ items[0].path, items[0].is_dir)
        let new_basename = input('New file name: ', def_name, 'file')
        if empty(new_basename)
            call vimfm#util#echo('Cancelled.')
            return
        endif

        let renamed_paths = vimfm#file#rename(
                    \ vimfm#buffer#get_filer(),
                    \ items, [new_basename])

        call vimfm#refresh()

        if !empty(renamed_paths[0])
            call vimfm#buffer#move_cursor_to_path(renamed_paths[0])
        endif
        return
    endif

    call vimfm#rename_buffer#new(items)
endfunction


function! vimfm#toggle_hidden() abort
    call s:keep_buffer_singularity()

    let filer = vimfm#buffer#get_filer()
    let filer.shows_hidden_files = !filer.shows_hidden_files
    call vimfm#buffer#set_filer(filer)

    let item = get(
                \ s:get_cursor_items(filer, 'n'),
                \ 0,
                \ {})
    if !empty(item)
        call vimfm#buffer#save_cursor(item)
    endif

    let filer = vimfm#buffer#get_filer()
    let filer.items = vimfm#file#create_items_from_dir(
                \ filer.dir,
                \ filer.shows_hidden_files)
    call vimfm#buffer#set_filer(filer)

    call vimfm#buffer#redraw()
endfunction

function! vimfm#fill_cmdline() abort
    let filer = vimfm#buffer#get_filer()

    let items = s:get_selected_items(filer)
    if empty(items)
        return
    endif

    let paths = map(items, 'fnameescape(v:val.path)')
    let cmdline = ": ".join(paths, ' ')."\<Home>"
    call feedkeys(cmdline)
endfunction

function! vimfm#chdir(path) abort
    call s:keep_buffer_singularity()

    try
        execute 'lcd '.fnameescape(a:path)
    catch /:E472:/
        " E472: Command failed
        " Permission denied, etc.
        call vimfm#util#echo_error("Changing directory failed: '".a:path."'")
    endtry
endfunction

function! vimfm#chdir_here() abort
    let filer = vimfm#buffer#get_filer()
    call vimfm#chdir(filer.dir)
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
