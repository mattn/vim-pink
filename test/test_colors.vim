" Run with: vim -Nu NONE -i NONE -n -es -S test/test_colors.vim
set nocompatible
let s:root = empty($PINK_TEST_ROOT) ? expand('<sfile>:p:h:h') : $PINK_TEST_ROOT
execute 'source' fnameescape(s:root . '/autoload/pink.vim')
let s:sid = getscriptinfo()[-1].sid
let s:Nearest = function('<SNR>' . s:sid . '_nearest_cube_index')
let s:Convert = function('<SNR>' . s:sid . '_hex_to_cterm')

" Compare every component with the original nearest-color search, including
" exact midpoint ties. RGB cube conversion is separable into these components.
let s:cube = [0, 95, 135, 175, 215, 255]
for s:v in range(256)
  let s:best = 0
  let s:distance = 99999
  for s:i in range(6)
    let s:d = abs(s:cube[s:i] - s:v)
    if s:d < s:distance
      let s:best = s:i
      let s:distance = s:d
    endif
  endfor
  call assert_equal(s:best, s:Nearest(s:v), 'component ' . s:v)
  let s:gray = s:v < 8 ? 16 : s:v > 248 ? 231 : 232 + ((s:v - 8) / 10)
  let s:hex = printf('#%02x%02x%02x', s:v, s:v, s:v)
  call assert_equal(s:gray, s:Convert(s:hex), s:hex)
  call assert_equal(s:gray, s:Convert(s:hex), 'cached ' . s:hex)
endfor

for [s:hex, s:expected] in [['#ff0000', 196], ['#00ff00', 46],
      \ ['#0000ff', 21], ['#5f87af', 67], ['#5F87AF', 67]]
  call assert_equal(s:expected, s:Convert(s:hex), s:hex)
  call assert_equal(s:expected, s:Convert(s:hex), 'cached ' . s:hex)
endfor
for s:invalid in [0, [], {}, '', 'NONE', '#fff', '#1234567', '#gg0000']
  call assert_equal(-1, s:Convert(s:invalid))
endfor

" A later setup must reflect changes to custom colors.
let g:pink_sections_left = [{'content': 'test', 'fg': '#ff0000', 'color': '#0000ff'}]
call pink#setup_colors()
call assert_equal('196', synIDattr(hlID('PinkL0'), 'fg', 'cterm'))
call assert_equal('21', synIDattr(hlID('PinkL0'), 'bg', 'cterm'))
let g:pink_sections_left[0].fg = '#00ff00'
call pink#setup_colors()
call assert_equal('46', synIDattr(hlID('PinkL0'), 'fg', 'cterm'))

if !empty(v:errors)
  call writefile(v:errors, 'test_colors.errors')
  cquit
endif
qa!
