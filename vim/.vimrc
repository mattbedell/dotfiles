call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" Initialize plugin system
call plug#end()


" FZF Configuration
let g:fzf_layout = { 'down': '~80%' }

" -- Mapping --
let mapleader=" "
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <silent> <leader><space> :Buffers<CR>
nnoremap <silent> <leader>s :Rg<CR>
nnoremap <silent> <leader>f :Files<CR>
 
" Use FZF for autocompletion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Change cursor shape based on mode
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

:set hidden
:syntax on
:set timeoutlen=1000 ttimeoutlen=5
:set ignorecase
:set smartcase
:set listchars=tab:▸\ ,eol:¬

" Indentation
:set autoindent
:set smartindent
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set expandtab

command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" toggle hybrid line numbers based on mode
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

