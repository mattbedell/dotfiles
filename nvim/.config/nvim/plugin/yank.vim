
function Osc52Yank()
  if !exists('g:tty')
    return
  endif
  let buffer=system('base64', @0)
  let buffer=substitute(buffer, "\n", "", "")
  let buffer='\e]52;c;'.buffer.'\e\'
  silent exe "!echo -ne ".shellescape(buffer).
        \ " > ".shellescape(g:tty)
endfunction

if has('clipboard')
  augroup Yank
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
  augroup END
endif

