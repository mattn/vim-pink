" vim-pink: git helpers
"
" Resolve the current branch name by reading .git/HEAD directly, avoiding
" the cost of spawning `git`. Handles worktrees and submodules where
" .git is a file containing `gitdir: <path>`.

function! pink#git#head_branch(dir) abort
  let l:git = finddir('.git', a:dir . ';')
  if empty(l:git)
    let l:gitfile = findfile('.git', a:dir . ';')
    if empty(l:gitfile)
      return ''
    endif
    let l:lines = readfile(l:gitfile, '', 1)
    if empty(l:lines) || l:lines[0] !~# '^gitdir: '
      return ''
    endif
    let l:git = substitute(l:lines[0], '^gitdir: ', '', '')
    if l:git !~# '^\%([A-Za-z]:\)\?[/\\]'
      let l:git = fnamemodify(l:gitfile, ':p:h') . '/' . l:git
    endif
  endif
  let l:head = l:git . '/HEAD'
  if !filereadable(l:head)
    return ''
  endif
  let l:lines = readfile(l:head, '', 1)
  if empty(l:lines)
    return ''
  endif
  let l:m = matchlist(l:lines[0], '^ref: refs/heads/\(.*\)$')
  if !empty(l:m)
    return l:m[1]
  endif
  return strpart(l:lines[0], 0, 7)
endfunction
