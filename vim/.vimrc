call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf' "fzf fuzzy finder wrapper
Plug 'junegunn/fzf.vim' "fzf fuzzy finder plugin
Plug 'sheerun/vim-polyglot' "multi-language syntax support
Plug 'tmsvg/pear-tree' "autopair parens, etc.
Plug 'tpope/vim-commentary' "comment code
Plug 'tpope/vim-surround' "mappings for surrounding characters
Plug 'tpope/vim-repeat' "make mappings repeatable
Plug 'romainl/vim-cool' "auto highlight search, add search match count
Plug 'unblevable/quick-scope' " highlight unique chars for 'f' and 't' motions
Plug 'ludovicchabant/vim-gutentags' "ctag manager
Plug 'nathanaelkane/vim-indent-guides' "indent guides
" Initialize plugin system
call plug#end()

" FZF configuration
let g:fzf_layout = { 'down': '~80%' }

" allow fzf Rg command to accept arguments
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git" '
  \  . (len(<q-args>) > 0 ? <q-args> : '""'), 1,
  \    fzf#vim#with_preview(), <bang>0)


" vim-javascript configuration
let g:javascript_plugin_jsdoc=1 " syntax highlighting for JSDOC

" vim-cool configuration
let g:CoolTotalMatches = 1

" quick-scope configuration
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#ff00ff' gui=bold ctermfg=201 cterm=bold
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#ff0000' gui=bold ctermfg=9 cterm=bold
augroup END
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T'] "Only highlight on keys
let g:qs_lazy_highlight = 1 " autocmd event from CursorMoved to CursorHold (reduces slowdown)

" vim-gutentags configuration
let g:gutentags_define_advanced_commands = 1
let g:gutentags_ctags_exclude = ['node_modules', 'dist']
if executable('fd')
  let g:gutentags_file_list_command = 'fd --type file'
endif

" vim-indent-guides configuration
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" -- Mapping --
let mapleader=" "
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <silent> <leader><space> :Buffers<CR>
nnoremap <leader>s :Rg<space>
nnoremap <leader>f :GFiles<CR>

nnoremap <leader>t :suspend<CR>
nnoremap <leader>q @@<CR>

" autocompletion popup menu enhancement
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


" FZF
nnoremap <leader>d :call fzf#vim#tags(expand('<cword>'), {'options': '--exact --select-1 --exit-0'})<CR>

" Use FZF for autocompletion
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" imap <c-x><c-l> <plug>(fzf-complete-line)

" Change cursor shape based on mode
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

:set hidden
:syntax on
:set timeoutlen=1000 ttimeoutlen=5
:set ignorecase
:set smartcase
:set hlsearch
:set list
:set listchars=trail:·
:set completeopt=longest,menuone
:set incsearch
:set ruler
:set wildmenu

" -- Theme --
:set termguicolors
:colorscheme pablo
:set background=dark

" Indentation
:set autoindent
:set smartindent
:set tabstop=2
:set softtabstop=2
:set shiftwidth=2
:set expandtab

" toggle hybrid line numbers based on mode
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

