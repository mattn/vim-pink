" vim-pink: vim-signify extension
" Shows +added ~modified -removed hunks in the statusline.

let s:enabled = 0

function! pink#extension#vim_signify#enable() abort
  if s:enabled
    return
  endif
  let s:enabled = 1

  augroup pink_extension_vim_signify
    autocmd!
    autocmd User Signify call pink#update()
  augroup END

  call pink#extension#add_middle(function('pink#extension#vim_signify#status'))

  call pink#setup_colors()
  call pink#update()
endfunction

function! pink#extension#vim_signify#status() abort
  if !exists('*sy#repo#get_stats')
    return ''
  endif
  let [l:a, l:m, l:r] = sy#repo#get_stats()
  if l:a == 0 && l:m == 0 && l:r == 0
    return ''
  endif
  return printf('+%d ~%d -%d', l:a, l:m, l:r)
endfunction
