" vim-pink: coc.nvim extension
" Shows diagnostics and LSP status in the statusline.

let s:enabled = 0

function! pink#extension#coc_nvim#enable() abort
  if s:enabled
    return
  endif
  let s:enabled = 1

  augroup pink_extension_coc_nvim
    autocmd!
    autocmd User CocStatusChange,CocDiagnosticChange call pink#update()
  augroup END

  call pink#extension#add_middle(function('pink#extension#coc_nvim#status'))

  call pink#setup_colors()
  call pink#update()
endfunction

function! pink#extension#coc_nvim#status() abort
  return get(g:, 'coc_status', '')
endfunction
