call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf' "fzf fuzzy finder wrapper
Plug 'junegunn/fzf.vim' "fzf fuzzy finder plugin
Plug 'sheerun/vim-polyglot' "multi-language syntax support
Plug 'tmsvg/pear-tree' "autopair parens, etc.
Plug 'tpope/vim-commentary' "comment code
Plug 'romainl/vim-cool' "auto highlight search, add search match count
Plug 'unblevable/quick-scope' " highlight unique chars for 'f' and 't' motions
" Initialize plugin system
call plug#end()

" -- Theme --
set termguicolors

" FZF configuration
let g:fzf_layout = { 'down': '~80%' }

" vim-javascript configuration
let g:javascript_plugin_jsdoc=1 " syntax highlighting for JSDOC

" vim-cool configuration
let g:CoolTotalMatches = 1

" quick-scope configuration
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T'] "Only highlight on keys
let g:qs_lazy_highlight = 1 " autocmd event from CursorMoved to CursorHold (reduces slowdown)

" -- Mapping --
let mapleader=" "
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <silent> <leader><space> :Buffers<CR>
nnoremap <leader>s :Rg<space>
nnoremap <leader>f :Files<space>

nnoremap <leader>t :suspend<CR>
nnoremap <leader>q @@<CR>
 
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
:set hlsearch

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

