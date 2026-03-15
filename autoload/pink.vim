" vim-pink: customizable statusline functions

" Mode normalization map
let s:mode_map = {
  \ 'n': 'n', 'i': 'i', 'R': 'R', 'c': 'c', 't': 't',
  \ 'v': 'v', 'V': 'v', "\x16": 'v',
  \ }

" Default mode labels
let s:mode_labels = {
  \ 'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE',
  \ 'v': 'VISUAL', 'c': 'COMMAND', 't': 'TERMINAL',
  \ }

" Default foreground / background (used when section omits 'fg' or 'color')
let s:default_fg = '#ECF0F1'
let s:default_bg = '#DA627D'

" Default left sections
"   content : statusline string, or 'mode' for the special mode indicator
"   color   : (optional) background color (hex) — defaults to s:default_bg
"   fg      : (optional) foreground color (hex) — defaults to s:default_fg
"   gui     : (optional) gui attributes, e.g. 'bold'
"   mode_colors : (optional, for content='mode') per-mode color overrides
"                 { 'i': {'color': '...', 'fg': '...'}, ... }
let s:default_left = [
  \ {'content': 'mode', 'color': '#9A348E', 'fg': '#ECF0F1', 'gui': 'bold',
  \  'mode_colors': {
  \    'i': {'color': '#FCA17D', 'fg': '#2C3E50'},
  \    'R': {'color': '#C0392B', 'fg': '#ECF0F1'},
  \    'v': {'color': '#06969A', 'fg': '#ECF0F1'},
  \  }},
  \ {'content': ' %f ', 'color': '#DA627D', 'fg': '#ECF0F1', 'gui': 'bold'},
  \ {'content': ' %{pink#branch()}%{&modified ? " +" : ""} ', 'color': '#FCA17D', 'fg': '#2C3E50', 'gui': 'bold'},
  \ {'content': ' %{&filetype!=""?&filetype:""} ', 'color': '#86BBD8', 'fg': '#2C3E50'},
  \ ]

" Default right sections
let s:default_right = [
  \ {'content': ' %{&fileencoding!=""?&fileencoding:&encoding} ', 'color': '#86BBD8', 'fg': '#2C3E50'},
  \ {'content': ' %l:%c ', 'color': '#06969A', 'fg': '#ECF0F1'},
  \ {'content': ' %{strftime("♥ %H:%M")} ', 'color': '#33658A', 'fg': '#ECF0F1', 'gui': 'bold'},
  \ ]

" Default middle (fill) and inactive colors
let s:default_middle   = {'color': '#06969A', 'fg': '#ECF0F1'}
let s:default_inactive = {'color': '#9A348E', 'fg': '#ECF0F1'}

" Accessor helpers --------------------------------------------------------

function! s:left() abort
  return get(g:, 'pink_sections_left', s:default_left)
endfunction

function! s:right() abort
  return get(g:, 'pink_sections_right', s:default_right)
endfunction

function! s:middle() abort
  return get(g:, 'pink_color_middle', s:default_middle)
endfunction

function! s:inactive() abort
  return get(g:, 'pink_color_inactive', s:default_inactive)
endfunction

function! s:sep() abort
  return get(g:, 'pink_separator', "\ue0b0")
endfunction

" Highlight setup ---------------------------------------------------------

function! s:sec_fg(sec) abort
  return get(a:sec, 'fg', get(g:, 'pink_default_fg', s:default_fg))
endfunction

function! s:sec_bg(sec) abort
  return get(a:sec, 'color', get(g:, 'pink_default_bg', s:default_bg))
endfunction

function! pink#setup_colors() abort
  let l:left = s:left()
  let l:right = s:right()
  let l:mid = s:middle()

  " Left sections
  for l:i in range(len(l:left))
    let l:sec = l:left[l:i]
    let l:fg  = s:sec_fg(l:sec)
    let l:bg  = s:sec_bg(l:sec)
    let l:gui = has_key(l:sec, 'gui') ? ' gui=' . l:sec.gui : ''
    let l:next_bg = l:i < len(l:left) - 1 ? s:sec_bg(l:left[l:i + 1]) : get(l:mid, 'color', s:default_bg)

    exe printf('hi PinkL%d guifg=%s guibg=%s%s', l:i, l:fg, l:bg, l:gui)
    exe printf('hi PinkL%dSep guifg=%s guibg=%s', l:i, l:bg, l:next_bg)

    " Per-mode variants
    if has_key(l:sec, 'mode_colors')
      for [l:mk, l:mc] in items(l:sec.mode_colors)
        let l:mc_bg  = get(l:mc, 'color', l:bg)
        let l:mc_fg  = get(l:mc, 'fg', l:fg)
        let l:mc_gui = has_key(l:mc, 'gui') ? ' gui=' . l:mc.gui : l:gui
        exe printf('hi PinkL%d_%s guifg=%s guibg=%s%s', l:i, l:mk, l:mc_fg, l:mc_bg, l:mc_gui)
        exe printf('hi PinkL%d_%sSep guifg=%s guibg=%s', l:i, l:mk, l:mc_bg, l:next_bg)
      endfor
    endif
  endfor

  " Middle fill
  exe printf('hi PinkMid guifg=%s guibg=%s', get(l:mid, 'fg', s:default_fg), get(l:mid, 'color', s:default_bg))

  " Right sections
  for l:i in range(len(l:right))
    let l:sec = l:right[l:i]
    let l:fg  = s:sec_fg(l:sec)
    let l:bg  = s:sec_bg(l:sec)
    let l:gui = has_key(l:sec, 'gui') ? ' gui=' . l:sec.gui : ''
    let l:prev_bg = l:i == 0 ? get(l:mid, 'color', s:default_bg) : s:sec_bg(l:right[l:i - 1])

    exe printf('hi PinkR%d guifg=%s guibg=%s%s', l:i, l:fg, l:bg, l:gui)
    exe printf('hi PinkR%dSepL guifg=%s guibg=%s', l:i, l:prev_bg, l:bg)
  endfor

  " Inactive window
  let l:inact = s:inactive()
  exe printf('hi PinkInactive guifg=%s guibg=%s', get(l:inact, 'fg', s:default_fg), get(l:inact, 'color', s:default_bg))
endfunction

" Mode helpers ------------------------------------------------------------

function! s:mode_key() abort
  return get(s:mode_map, mode(), 'n')
endfunction

function! s:mode_label() abort
  let l:labels = get(g:, 'pink_mode_labels', s:mode_labels)
  let l:key = s:mode_key()
  return get(l:labels, l:key, mode())
endfunction

" Build statusline --------------------------------------------------------

function! pink#build() abort
  let l:left  = s:left()
  let l:right = s:right()
  let l:sep   = s:sep()
  let l:mk    = s:mode_key()
  let l:s     = ''

  " Left sections
  for l:i in range(len(l:left))
    let l:sec = l:left[l:i]
    let l:is_mode = l:sec.content ==# 'mode'
    let l:use_variant = l:is_mode && has_key(get(l:sec, 'mode_colors', {}), l:mk)

    " Section highlight
    if l:use_variant
      let l:s .= '%#PinkL' . l:i . '_' . l:mk . '#'
    else
      let l:s .= '%#PinkL' . l:i . '#'
    endif

    " Section content
    if l:is_mode
      let l:s .= ' ' . s:mode_label() . ' '
    else
      let l:s .= l:sec.content
    endif

    " Separator
    if l:use_variant
      let l:s .= '%#PinkL' . l:i . '_' . l:mk . 'Sep#' . l:sep
    else
      let l:s .= '%#PinkL' . l:i . 'Sep#' . l:sep
    endif
  endfor

  " Middle fill
  let l:s .= '%#PinkMid#%='

  " Right sections
  for l:i in range(len(l:right))
    let l:s .= '%#PinkR' . l:i . 'SepL#' . l:sep
    let l:s .= '%#PinkR' . l:i . '#'
    let l:s .= l:right[l:i].content
  endfor

  return l:s
endfunction

function! pink#build_inactive() abort
  let l:s = '%#PinkInactive#'
  let l:s .= '  %f'
  let l:s .= '%='
  let l:s .= '%l:%c '
  return l:s
endfunction

" Git branch --------------------------------------------------------------

function! pink#refresh_branch() abort
  if exists('*FugitiveHead')
    let l:b = FugitiveHead()
  else
    silent let l:out = systemlist('git -C ' . shellescape(expand('%:p:h')) . ' rev-parse --abbrev-ref HEAD 2>/dev/null')
    let l:b = !empty(l:out) ? l:out[0] : ''
  endif
  let l:icon = has('win32') && !exists('g:pink_use_powerline') ? '' : "\ue0a0 "
  let b:pink_branch = l:b !=# '' ? l:icon . l:b : ''
endfunction

function! pink#branch() abort
  return get(b:, 'pink_branch', '')
endfunction

" Update ------------------------------------------------------------------

function! pink#update() abort
  for l:nr in range(1, winnr('$'))
    if l:nr == winnr()
      call setwinvar(l:nr, '&statusline', '%!pink#build()')
    else
      call setwinvar(l:nr, '&statusline', '%!pink#build_inactive()')
    endif
  endfor
endfunction

function! pink#update_inactive() abort
  call setwinvar(winnr(), '&statusline', '%!pink#build_inactive()')
endfunction
