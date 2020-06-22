" Plugins {{{
" vim {{{
packadd! cfilter " filter quickfix list, see :help CFilter
packadd! matchit " extend %
filetype plugin indent on

" }}}
" vim-plug {{{
call plug#begin('~/.vim/plugged')
Plug 'prabirshrestha/async.vim'           " vim-lsp dependency, normalize async calls
Plug 'junegunn/fzf'                       " fzf fuzzy finder wrapper
Plug 'junegunn/fzf.vim'                   " fzf fuzzy finder plugin
Plug 'gruvbox-community/gruvbox'          " theme
Plug 'tmsvg/pear-tree'                    " autopair parens, etc.
Plug 'unblevable/quick-scope'             " highlight unique chars for 'f' and 't' motions
Plug 'tpope/vim-commentary'               " comment code
Plug 'romainl/vim-cool'                   " auto highlight search, add search match count
Plug 'tpope/vim-dispatch'                 " async make
Plug 'tpope/vim-fugitive'                 " git integration
Plug 'ludovicchabant/vim-gutentags'       " ctag manager
Plug 'takac/vim-hardtime'                 " break bad habits
Plug 'machakann/vim-highlightedyank'      " briefly highlight yanked text
Plug 'nathanaelkane/vim-indent-guides'    " indent guides
Plug 'prabirshrestha/vim-lsp'             " enable use of language servers
Plug 'mattn/vim-lsp-settings'             " easily configure new language servers
Plug 'sheerun/vim-polyglot'               " multi-language syntax support
Plug 'yassinebridi/vim-purpura'           " theme, all purple because its fun
Plug 'tpope/vim-repeat'                   " make mappings repeatable
Plug 'tpope/vim-surround'                 " mappings for surrounding characters
Plug 'tmux-plugins/vim-tmux-focus-events' " add support for FocusGained and FocusLost events (proposed patch for this has been in limbo for years)
call plug#end()

"}}}
" plugin configurations {{{
" fzf {{{
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 1, 'border': 'top' } }

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git" '
  \  . (len(<q-args>) > 0 ? <q-args> : '""'), 1,
  \    fzf#vim#with_preview(), <bang>0)

"}}}
" quick-scope {{{
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#ff00ff' gui=bold ctermfg=201 cterm=bold
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#ff0000' gui=bold ctermfg=9 cterm=bold
augroup END
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T'] "Only highlight on keys
let g:qs_lazy_highlight = 1 " autocmd event from CursorMoved to CursorHold (reduces slowdown)

"}}}
" vim-cool {{{
let g:CoolTotalMatches = 1

" }}}
" vim-gutentags {{{
let g:gutentags_define_advanced_commands = 1
let g:gutentags_ctags_exclude = ['node_modules', 'dist', '*.spec.js', '**/fixtures', '*.stories.js', '*.spec-a11y.js', 'tests']
let g:gutentags_ctags_extra_args = ['--map-typescript=+.tsx']
let g:gutentags_generate_on_missing = 0

if executable('fd')
  let g:gutentags_file_list_command = 'fd --type file'
endif

"}}}
" vim-hardtime {{{
" let g:hardtime_default_on = 1
let g:hardtime_ignore_quickfix = 1

"}}}
" vim-indent-guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

"}}}
"vim-lsp {{{
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_highlight_references_enabled = 1
let g:lsp_semantic_enabled = 1
let g:lsp_signs_error = {'text': '>>'}
let g:lsp_signs_warning = {'text': '!!'}
let g:lsp_signs_hint = {'text': '>>'}

highlight link LspHintText DiffText
highlight link LspHintHighlight DiffText
highlight link LspWarningText DiffText
highlight link LspWarningHighlight DiffText
highlight link lspReference ColorColumn

"}}}
" vim-highlightedyank {{{
let g:highlightedyank_highlight_duration = 300

"}}}
" vim-javascript {{{
let g:javascript_plugin_jsdoc = 1 " syntax highlighting for JSDOC

"}}}
"}}}
"}}}
" Settings {{{
syntax on
set directory^=$HOME/.vim/swp//
set undofile
set undodir^=$HOME/.vim/undo//
set dictionary+=/usr/share/dict/words
set hidden
set timeoutlen=1000 ttimeoutlen=5
set ignorecase
set smartcase
set hlsearch
set list
set listchars=tab:>\ ,trail:•,extends:>,precedes:<,nbsp:+
set completeopt+=longest,menuone,popup
set incsearch
set ruler
set wildmenu
set wildignorecase
set splitbelow
set splitright
set laststatus=2
set cursorline
set cursorcolumn
set diffopt=vertical,filler,closeoff
set nowrap
set signcolumn=number
set history=1000
set scrolloff=1
set sidescrolloff=5
set sidescroll=1
set complete-=i
set sessionoptions-=options
set viewoptions-=options
set iskeyword+=-

" use vim-tmux-focus-events plug and autoread to update buffers on external
" changes to its file, the plugin makes focus events available in terminal vim
set autoread
" using vim-tmux-navigator like keybindings (<C-J>, etc) to navigate splits/panes
" makes the vim-tmux-focus-events plugin leave behind a ^[[0 on FocusLost, this
" autocmd fixes that
augroup AutoAutoRead
  autocmd!
  autocmd FocusLost * silent redraw!
augroup END

if executable("rg")
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ -g\ '!.git'
  set grepformat^=%f:%l:%c:%m
endif

" Indentation
set autoindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" toggle hybrid line numbers based on mode
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" cursor related settings {{{
" Change cursor shape based on mode
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

" toggle cursor line and cursor column on active window, if it is enabled for
" the buffer
" this allows for :set nocursorcolumn in the buffer without it being
" reenabled if the window loses and regains focus
function! ToggleCursorLC(isEnter)
  if a:isEnter && &g:cursorline | setlocal cursorline | endif
  if a:isEnter && &g:cursorcolumn | setlocal cursorcolumn | endif

  if !a:isEnter && &g:cursorline | setlocal nocursorline | endif
  if !a:isEnter && &g:cursorcolumn | setlocal nocursorcolumn | endif
endfunction

augroup ActiveWindow
  autocmd!
  autocmd WinEnter * call ToggleCursorLC(1)
  autocmd WinLeave * call ToggleCursorLC(0)
augroup END

"}}}
"}}}
" Mappings {{{
let mapleader=" "

nnoremap <leader>t :suspend<CR>
nnoremap <leader>q @@<CR>
nnoremap <leader>s :w<CR>

nnoremap <C-W><C-F> <C-W>vgf
noremap Y y$

" bindings ripped from vim-unimpaired
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]Q :clast<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]L :llast<CR>
nnoremap <silent> [L :lfirst<CR>

" https://github.com/whiteinge/dotfiles/blob/e728e33bd105b16aeef134eb12e1175e0c00ef0a/.vim/autoload/vimortmux.vim
" Natural movement around splits, if tmux, movement seamlessly extends to tmux panes
if !empty($TMUX)
  nnoremap <silent> <C-J> :call vimortmux#VimOrTmuxNav('j')<cr>
  nnoremap <silent> <C-K> :call vimortmux#VimOrTmuxNav('k')<cr>
  nnoremap <silent> <C-L> :call vimortmux#VimOrTmuxNav('l')<cr>
  nnoremap <silent> <C-H> :call vimortmux#VimOrTmuxNav('h')<cr>
else
  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>
  nnoremap <C-H> <C-W><C-H>
endif

" resize splits
nnoremap <silent> <Right> :vertical resize +2<CR>
nnoremap <silent> <Left> :vertical resize -2<CR>
nnoremap <silent> <Up> :resize +2<CR>
nnoremap <silent> <Down> :resize -2<CR>

" scroll the popup at the cursor
inoremap <expr> <C-n> popup#scroll_cursor_popup(1) ? '' : '<C-n>'
inoremap <expr> <C-p> popup#scroll_cursor_popup(0) ? '' : '<C-p>'
nnoremap <expr> <C-n> popup#scroll_cursor_popup(1) ? '<esc>' : '<C-n>'
nnoremap <expr> <C-p> popup#scroll_cursor_popup(0) ? '<esc>' : '<C-p>'

" relative filepath completion
" https://github.com/whiteinge/dotfiles/blob/e728e33bd105b16aeef134eb12e1175e0c00ef0a/.vimrc#L235
inoremap <C-f>
  \ <C-o>:let b:oldpwd = getcwd() <bar>
  \ lcd %:p:h<CR><C-x><C-f><C-r>=pumvisible() ? "\<lt>Down>" : ''<CR>
au CompleteDone *
  \ if exists('b:oldpwd') |
  \   cd `=b:oldpwd` |
  \   unlet b:oldpwd |
  \ endif

" vim-lsp {{{
" put diagnostics in the location list
nnoremap <silent> <leader>ll :LspDocumentDiagnostics<cr>
nnoremap <silent> <leader>ld :LspDefinition<cr>
nnoremap <silent> <leader>lf :LspFormat<cr>
nnoremap <silent> <leader>lr :LspReferences<cr>

"}}}

" vim-fugitive {{{
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>grb :Grebase 
nnoremap <leader>gri :Grebase -i HEAD~
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gl :Glog<CR>
nnoremap <leader>ge :Gedit<CR>
" git log of current buffer
nnoremap <leader>glb :0Glog<CR>

"}}}

" fzf {{{
nnoremap <leader>fd :call fzf#vim#tags(expand('<cword>'), {'options': '--exact --select-1 --exit-0'})<CR>
nnoremap <silent> <leader>fl :BLines<CR>
nnoremap <silent> <leader><space> :Buffers<CR>
nnoremap <leader>fs :Rg<space>
nnoremap <leader>ff :GFiles<CR>
nnoremap <leader>fa :Files ~/

" Use FZF for autocompletion
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" imap <c-x><c-l> <plug>(fzf-complete-line)
"}}}
"}}}
" Theme {{{
set background=dark
set termguicolors

" something to do with truecolor
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" general overrides applied to all themes
augroup ThemeCust
  autocmd!
  autocmd ColorScheme *
        \   highlight SpellBad       ctermbg=9 guibg=#770000

" gruvbox theme {{{
let g:gruvbox_contrast_dark='hard'
" set background color to black
" gruvbox overrides fzf popup colors, set black background
" override cursorline color with something more subtle on black background
" override red color to be less orange
augroup GruvboxCust
  autocmd!
  autocmd ColorScheme gruvbox highlight Normal guibg=#000000
    \ | highlight SpecialKey guifg='#ff00ff' ctermfg=201 cterm=bold
    \ | let g:fzf_colors.bg = ['bg', 'Normal']
    \ | highlight CursorLine ctermbg=232 guibg=#101010
    \ | highlight CursorLineNR cterm=bold ctermbg=232 guibg=#101010
    \ | highlight GruvboxRed guifg=#f6362f
    \ | highlight StatusLineNC guifg=#262626
augroup END

"}}}

silent! colorscheme gruvbox

"}}}


augroup VimrcAutoSrc
  autocmd!
  autocmd BufWritePost *vimrc nested source $MYVIMRC
augroup END

