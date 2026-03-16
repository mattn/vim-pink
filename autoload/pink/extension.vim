" vim-pink: extension loader

let g:pink_extension_middle_providers = []

function! pink#extension#enable(name) abort
  let l:name = substitute(a:name, '-', '_', 'g')
  call pink#extension#{l:name}#enable()
endfunction

" Register a middle-area content provider.
" Each provider is a funcref that returns a string (empty = skip).
function! pink#extension#add_middle(func) abort
  call add(g:pink_extension_middle_providers, a:func)
  let g:pink_color_middle = extend(get(g:, 'pink_color_middle', {}),
    \ {'content': '%{pink#extension#middle()}'})
endfunction

function! pink#extension#middle() abort
  let l:parts = []
  for l:F in g:pink_extension_middle_providers
    let l:s = l:F()
    if l:s !=# ''
      call add(l:parts, l:s)
    endif
  endfor
  return join(l:parts, ' | ')
endfunction
