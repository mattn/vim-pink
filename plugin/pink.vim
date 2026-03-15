" vim-pink: A pink/magenta powerline-style statusline
" Maintainer: mattn

if exists('g:loaded_pink') || &compatible
  finish
endif
let g:loaded_pink = 1

set laststatus=2
set noshowmode

augroup pink
  autocmd!
  autocmd ColorScheme,VimEnter * call pink#setup_colors()
  autocmd WinEnter,BufEnter,BufWritePost * call pink#refresh_branch() | call pink#refresh_exec()
  autocmd WinEnter,BufEnter,BufWritePost,InsertEnter,InsertLeave * call pink#update()
  autocmd WinLeave * call pink#update_inactive()
augroup END

call pink#setup_colors()
call pink#update()
