" vim-pink: vim-gitgutter extension
" Shows +added ~modified -removed hunks in the statusline.

let s:enabled = 0

function! pink#extension#vim_gitgutter#enable() abort
  if s:enabled
    return
  endif
  let s:enabled = 1

  augroup pink_extension_vim_gitgutter
    autocmd!
    autocmd User GitGutter call pink#update()
  augroup END

  call pink#extension#add_middle(function('pink#extension#vim_gitgutter#status'))

  call pink#setup_colors()
  call pink#update()
endfunction

function! pink#extension#vim_gitgutter#status() abort
  if !exists('*GitGutterGetHunkSummary')
    return ''
  endif
  let [l:a, l:m, l:r] = GitGutterGetHunkSummary()
  if l:a == 0 && l:m == 0 && l:r == 0
    return ''
  endif
  return printf('+%d ~%d -%d', l:a, l:m, l:r)
endfunction
