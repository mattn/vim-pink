" vim-pink: copilot.vim extension
" Shows Copilot status icon in the statusline.

let s:enabled = 0

function! pink#extension#vim_copilot#enable() abort
  if s:enabled
    return
  endif
  let s:enabled = 1

  let l:right = get(g:, 'pink_sections_right', [
    \ {'content': ' %{&fileencoding!=""?&fileencoding:&encoding} ', 'color': '#86BBD8', 'fg': '#2C3E50'},
    \ {'content': ' %l:%c ', 'color': '#06969A', 'fg': '#ECF0F1'},
    \ {'content': ' %{strftime("♡ %H:%M")} ', 'color': '#33658A', 'fg': '#ECF0F1', 'gui': 'bold'},
    \ ])

  let g:pink_sections_right = [
    \ {'content': ' %{pink#extension#vim_copilot#status()} ', 'color': '#33658A', 'fg': '#ECF0F1'},
    \ ] + l:right

  call pink#setup_colors()
  call pink#update()
endfunction

function! pink#extension#vim_copilot#status() abort
  if !exists('*copilot#Enabled')
    return ''
  endif
  return copilot#Enabled() ? "\ue708" : ''
endfunction
