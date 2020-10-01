" depends on https://github.com/iautom8things/gitlink-vim
function! gitlink#copygitlink(...) range
  redir @+
  silent echo gitlink#GitLink(get(a:, 1, 0))
  redir END
endfunction

