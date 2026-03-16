" vim-pink: vim-lsp extension

let s:enabled = 0

function! pink#extension#vim_lsp#enable() abort
  if s:enabled
    return
  endif
  let s:enabled = 1

  let g:pink_lsp_message = ''

  augroup pink_extension_vim_lsp
    autocmd!
    autocmd User lsp_progress_updated call s:notification()
  augroup END

  call pink#extension#add_middle(function('pink#extension#vim_lsp#status'))

  call pink#setup_colors()
  call pink#update()
endfunction

function! pink#extension#vim_lsp#status() abort
  return g:pink_lsp_message
endfunction

function! s:notification() abort
  let l:m = lsp#get_progress()
  if len(l:m) ==# 0
    let g:pink_lsp_message = ''
  else
    let g:pink_lsp_message = l:m[-1]['server'] . ': ' . l:m[-1]['title']
  endif
  call pink#update()
endfunction
