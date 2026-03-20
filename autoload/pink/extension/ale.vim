" vim-pink: ALE (Asynchronous Lint Engine) extension
" Shows error/warning counts in the right sections.

let s:enabled = 0

function! pink#extension#ale#enable() abort
  if s:enabled
    return
  endif
  let s:enabled = 1

  augroup pink_extension_ale
    autocmd!
    autocmd User ALELintPost,ALEFixPost call pink#update()
  augroup END

  let l:right = get(g:, 'pink_sections_right', [
    \ {'content': ' %{&fileencoding!=""?&fileencoding:&encoding} ', 'color': '#86BBD8', 'fg': '#2C3E50'},
    \ {'content': ' %l:%c ', 'color': '#06969A', 'fg': '#ECF0F1'},
    \ {'content': ' %{strftime("♡ %H:%M")} ', 'color': '#33658A', 'fg': '#ECF0F1', 'gui': 'bold'},
    \ ])

  let g:pink_sections_right = [
    \ {'content': ' %{pink#extension#ale#status()} ', 'color': '#DA627D', 'fg': '#ECF0F1', 'gui': 'bold'},
    \ ] + l:right

  call pink#setup_colors()
  call pink#update()
endfunction

function! pink#extension#ale#status() abort
  if !exists('*ale#statusline#Count')
    return ''
  endif
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:errors = l:counts.error + l:counts.style_error
  let l:warnings = l:counts.warning + l:counts.style_warning
  if l:errors == 0 && l:warnings == 0
    return "\u2714"
  endif
  let l:s = ''
  if l:errors > 0
    let l:s .= "\u2718 " . l:errors
  endif
  if l:warnings > 0
    let l:s .= (l:s !=# '' ? ' ' : '') . "\u26a0 " . l:warnings
  endif
  return l:s
endfunction
