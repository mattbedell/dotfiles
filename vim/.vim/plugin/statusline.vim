
function! statusline#updateHighlighGroups() abort
  call utils#extendHighlight('StatusLine', 'stlWarn',  'ctermbg=10 cterm=reverse,bold' . ' guibg=' . utils#getHighlightTerm('Question', 'guifg'))
  call utils#extendHighlight('StatusLineNC', 'stlWarnNC', 'cterm=reverse,bold')
  call utils#extendHighlight('StatusLine', 'stlGit', 'guibg=' . utils#getHighlightTerm('Identifier', 'guifg'))
  highlight link stlGitNC StatusLineNC
endfunction

call statusline#updateHighlighGroups()

augroup ColorStatusLine
  autocmd!
  autocmd Colorscheme * call statusline#updateHighlighGroups()
  autocmd OptionSet background call statusline#updateHighlighGroups()
augroup END

function! statusline#git() abort
  " https://github.com/milisims/vimfiles/blob/master/plugin/statusline.vim#L61
  let stltext = ''
  if exists('g:loaded_fugitive') && &modifiable
    let githead = fugitive#head()
    let stltext .= len(githead) ? '[' . githead . ']' : ''
  endif
  return stltext
endfunction

function! statusline#gutentags() abort
  let stltext = ''
  if exists('g:loaded_gutentags')
    let stltext .= '%{gutentags#statusline("[","]")}'
  endif
  return stltext
endfunction

function! statusline#truncatedpath() abort
  return pathshorten(expand('%:~:.'))
endfunction

function! statusline#active() abort
  let stltext = ' '
  let stltext .= '%{statusline#truncatedpath()}'
  let stltext .= ' %#stlGit#%{statusline#git()}%*'
  let stltext .= '%#stlWarn#%m%*%r'
  let stltext .= statusline#gutentags()

  let stltext .= '%='
  let stltext .= '%-4.(%P%)'

  return stltext
endfunction

function! statusline#inactive() abort
  let stltext = ' '
  let stltext .= '%{statusline#truncatedpath()}'
  let stltext .= ' %#stlGitNC#%{statusline#git()}%*'
  let stltext .= '%#stlWarnNC#%m%*%r'
  let stltext .= statusline#gutentags()

  let stltext .= '%='
  let stltext .= '%-4.(%P%)'

  return stltext
endfunction

set statusline=%!statusline#inactive()
augroup VimStatusline
  autocmd!
  autocmd WinLeave * setlocal statusline=%!statusline#inactive()
  autocmd WinEnter,BufEnter * setlocal statusline=%!statusline#active()
augroup END

