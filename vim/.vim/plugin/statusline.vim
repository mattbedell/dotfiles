
" TODO: Fixup this file because it is a mess

highlight StatusLine   cterm=reverse      ctermfg=239 ctermbg=223 guifg=#272727 guibg=#ebdbb2
highlight StatusLineNC cterm=reverse      ctermfg=237 ctermbg=246 guifg=#101010 guibg=#a49580
highlight stlWarn      cterm=reverse,bold ctermfg=239 ctermbg=10  guifg=#272727 guibg=#00ff00
highlight stlWarnNC    cterm=reverse,bold ctermfg=237 ctermbg=246 guifg=#101010 guibg=#ebdbb2
highlight stlGit       cterm=reverse      ctermfg=109 ctermbg=223 guifg=#272727 guibg=#83a598
highlight link stlGitNC StatusLineNC

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

