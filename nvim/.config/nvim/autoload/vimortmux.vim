
" Stolen from here, which was stolen from tmux navigator:
" https://github.com/whiteinge/dotfiles/blob/e728e33bd105b16aeef134eb12e1175e0c00ef0a/.vim/autoload/vimortmux.vim

function! vimortmux#VimOrTmuxNav(direction)
  let l:nr = winnr()
  execute 'wincmd '. a:direction

  if (nr == winnr())
    let l:cmd = 'tmux select-pane -Z'. tr(a:direction, 'hjkl', 'LDUR')
    return system(l:cmd)
  endif
endfunction

