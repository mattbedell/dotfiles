
function! utils#syngroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

function! utils#synstack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" https://stackoverflow.com/a/5961837
function! utils#extendHighlight(base, new_group, add)
  redir => basehi
  sil! exe 'highlight' a:base
  redir END
  let grphi = split(basehi, '\n')[0]
  let grphi = substitute(grphi, '^'.a:base.'\s\+xxx', '', '')
  sil exe 'highlight' a:new_group grphi a:add
endfunction

" https://vi.stackexchange.com/a/12294
function! utils#getHighlightTerm(group, term)
  " Store output of group to variable
  let output = execute('hi ' . a:group)
  let linked = matchstr(output, 'links to \zs.*')

  " follow linked highlight groups
  " @TODO this seems dangerous
  while len(linked) > 0
     let output = execute('hi ' . linked)
     let linked = matchstr(output, 'links to \zs.*')
  endwhile
   " Find the term we're looking for
   return matchstr(output, a:term.'=\zs\S*')
endfunction

