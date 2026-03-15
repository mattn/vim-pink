" vim-pink: statusline functions

let s:sep = "\ue0b0"  " Powerline right arrow

" Color palette (matching starship config)
let s:c1 = '#9A348E'  " purple - mode/username
let s:c2 = '#DA627D'  " pink/rose - directory/file
let s:c3 = '#FCA17D'  " peach/salmon - git/info
let s:c4 = '#86BBD8'  " light blue - language/details
let s:c5 = '#06969A'  " teal - extra
let s:c6 = '#33658A'  " dark blue - time
let s:white = '#ecf0f1'
let s:dark  = '#2c3e50'

function! pink#setup_colors() abort
  " Section backgrounds
  exe printf('hi PinkS1     guifg=%s guibg=%s gui=bold', s:white, s:c1)
  exe printf('hi PinkS1Sep  guifg=%s guibg=%s',          s:c1,    s:c2)
  exe printf('hi PinkS2     guifg=%s guibg=%s gui=bold', s:white, s:c2)
  exe printf('hi PinkS2Sep  guifg=%s guibg=%s',          s:c2,    s:c3)
  exe printf('hi PinkS3     guifg=%s guibg=%s gui=bold', s:dark,  s:c3)
  exe printf('hi PinkS3Sep  guifg=%s guibg=%s',          s:c3,    s:c4)
  exe printf('hi PinkS4     guifg=%s guibg=%s',          s:dark,  s:c4)
  exe printf('hi PinkS4Sep  guifg=%s guibg=%s',          s:c4,    s:c5)

  " Middle fill (use teal like starship's docker section)
  exe printf('hi PinkMid    guifg=%s guibg=%s',          s:white, s:c5)
  exe printf('hi PinkMidSep guifg=%s guibg=%s',          s:c5, 'NONE')

  " Right sections
  exe printf('hi PinkR1SepL guifg=%s guibg=%s',          s:c5,    s:c4)
  exe printf('hi PinkR1     guifg=%s guibg=%s',          s:dark,  s:c4)
  exe printf('hi PinkR1Sep  guifg=%s guibg=%s',          s:c4,    s:c5)
  exe printf('hi PinkR2     guifg=%s guibg=%s',          s:white, s:c5)
  exe printf('hi PinkR2Sep  guifg=%s guibg=%s',          s:c5,    s:c6)
  exe printf('hi PinkR3     guifg=%s guibg=%s gui=bold', s:white, s:c6)
  exe printf('hi PinkR3End  guifg=%s guibg=%s',          s:c6, 'NONE')

  " Inactive
  exe printf('hi PinkInactive guifg=%s guibg=%s',        s:white, s:c1)

  " Insert mode
  exe printf('hi PinkS1Ins    guifg=%s guibg=%s gui=bold', s:dark,  s:c3)
  exe printf('hi PinkS1InsSep guifg=%s guibg=%s',          s:c3,    s:c2)

  " Visual mode
  exe printf('hi PinkS1Vis    guifg=%s guibg=%s gui=bold', s:white, s:c5)
  exe printf('hi PinkS1VisSep guifg=%s guibg=%s',          s:c5,    s:c2)

  " Replace mode
  exe printf('hi PinkS1Rep    guifg=%s guibg=%s gui=bold', s:white, '#c0392b')
  exe printf('hi PinkS1RepSep guifg=%s guibg=%s',          '#c0392b', s:c2)
endfunction

function! s:mode_label() abort
  let l:m = mode()
  if l:m ==# 'n'
    return ['NORMAL', 'PinkS1', 'PinkS1Sep']
  elseif l:m ==# 'i'
    return ['INSERT', 'PinkS1Ins', 'PinkS1InsSep']
  elseif l:m ==# 'R'
    return ['REPLACE', 'PinkS1Rep', 'PinkS1RepSep']
  elseif l:m =~# '[vV\x16]'
    return ['VISUAL', 'PinkS1Vis', 'PinkS1VisSep']
  elseif l:m ==# 'c'
    return ['COMMAND', 'PinkS1', 'PinkS1Sep']
  elseif l:m ==# 't'
    return ['TERMINAL', 'PinkS1', 'PinkS1Sep']
  else
    return [l:m, 'PinkS1', 'PinkS1Sep']
  endif
endfunction

function! pink#build() abort
  let [l:label, l:mode_hl, l:sep_hl] = s:mode_label()

  let l:s = ''

  " S1: Mode (purple #9A348E)
  let l:s .= '%#' . l:mode_hl . '#'
  let l:s .= ' ' . l:label . ' '
  let l:s .= '%#' . l:sep_hl . '#' . s:sep

  " S2: File path (pink #DA627D)
  let l:s .= '%#PinkS2#'
  let l:s .= ' %f '
  let l:s .= '%#PinkS2Sep#' . s:sep

  " S3: Git branch / modified (peach #FCA17D)
  let l:s .= '%#PinkS3#'
  let l:s .= ' %{pink#branch()}'
  let l:s .= '%{&modified ? " +" : ""} '
  let l:s .= '%#PinkS3Sep#' . s:sep

  " S4: Filetype (light blue #86BBD8)
  let l:s .= '%#PinkS4#'
  let l:s .= ' %{&filetype!=""?&filetype:""} '
  let l:s .= '%#PinkS4Sep#' . s:sep

  " Middle (teal #06969A)
  let l:s .= '%#PinkMid#'
  let l:s .= '%='

  " Right: encoding (light blue #86BBD8)
  let l:s .= '%#PinkR1SepL#' . s:sep
  let l:s .= '%#PinkR1#'
  let l:s .= ' %{&fileencoding!=""?&fileencoding:&encoding} '

  " Right: line:col (teal #06969A)
  let l:s .= '%#PinkR1Sep#' . s:sep
  let l:s .= '%#PinkR2#'
  let l:s .= ' %l:%c '

  " Right: time (dark blue #33658A)
  let l:s .= '%#PinkR2Sep#' . s:sep
  let l:s .= '%#PinkR3#'
  let l:s .= ' %{strftime("♥ %H:%M")} '

  return l:s
endfunction

function! pink#build_inactive() abort
  let l:s = '%#PinkInactive#'
  let l:s .= '  %f'
  let l:s .= '%='
  let l:s .= '%l:%c '
  return l:s
endfunction

function! pink#branch() abort
  if exists('*FugitiveHead')
    let l:b = FugitiveHead()
    return l:b !=# '' ? "\ue0a0 " . l:b : ''
  endif
  silent let l:b = systemlist('git -C ' . shellescape(expand('%:p:h')) . ' rev-parse --abbrev-ref HEAD 2>/dev/null')
  return !empty(l:b) ? "\ue0a0 " . l:b[0] : ''
endfunction

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
