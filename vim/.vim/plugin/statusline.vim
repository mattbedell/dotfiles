
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
  "https://github.com/Lokaltog/vim-powerline/blob/09c0cea859a2e0989eea740655b35976d951a84e/autoload/Powerline/Functions.vim#L25
  "
  " Display a short path where the first directory is displayed with its
  " full name, and the subsequent directories are shortened to their
  " first letter, i.e. "/home/user/foo/foo/bar/baz.vim" becomes "~/foo/f/b/baz.vim"

  let dirsep = has('win32') && ! &shellslash ? '\' : '/'
  let filepath = expand('%:p')
  let mod = (exists('+acd') && &acd) ? ':~:h' : ':~:.:h'
  let fpath = split(fnamemodify(filepath, mod), dirsep)
  let fpath_shortparts = map(fpath[1:], 'v:val[0]')
  let ret = join(extend([fpath[0]], fpath_shortparts), dirsep) . dirsep
  if ret == ('.' . dirsep)
    let ret = ''
  endif

  return ret
endfunction

function! statusline#active() abort
  let stltext = ' '
  let stltext .= '%{statusline#truncatedpath()}'
  let stltext .= '%t'
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
  let stltext .= '%t'
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

