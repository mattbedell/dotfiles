function! utils#truncatedpath()
  " stolen from https://github.com/Lokaltog/vim-powerline/blob/09c0cea859a2e0989eea740655b35976d951a84e/autoload/Powerline/Functions.vim#L25
  "
  " Display a short path where the first directory is displayed with its
  " full name, and the subsequent directories are shortened to their
  " first letter, i.e. "/home/user/foo/foo/bar/baz.vim" becomes
  " "~/foo/f/b/baz.vim"
  "

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

