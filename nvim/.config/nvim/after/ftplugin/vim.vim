" set fold method to marker for vimrc only
if bufname('%') =~# '\.\?vimrc$'
  setlocal foldmethod=marker
endif

