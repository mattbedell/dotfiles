
" Plugins {{{
" vim {{{
packadd! cfilter " filter quickfix list, see :help CFilter
packadd! matchit " extend %

let g:netrw_altfile = 1

" }}}
" vim-plug {{{
call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'junegunn/fzf'                                               " fzf fuzzy finder wrapper
Plug 'junegunn/fzf.vim'                                           " fzf fuzzy finder plugin
Plug 'rhysd/git-messenger.vim'                                    " fugitive Blame is slow, this is faster
Plug 'iautom8things/gitlink-vim'                                  " Generate a github link to current line
Plug 'gruvbox-community/gruvbox'                                  " theme
Plug 'lukas-reineke/indent-blankline.nvim'                        " indent lines w/ treesitter context awareness
Plug 'ray-x/lsp_signature.nvim'                                   " lsp function signatures
Plug 'hrsh7th/nvim-compe'                                         " completion
Plug 'neovim/nvim-lspconfig'                                      " convenient configs for language servers
Plug 'nvim-treesitter/nvim-treesitter'                            " abstraction layer for neovim's treesitter integration
Plug 'nvim-treesitter/nvim-treesitter-refactor'                   " nvim-treesitter dependency
Plug 'nvim-treesitter/nvim-treesitter-textobjects'                " nvim-treesitter dependency
Plug 'tmsvg/pear-tree'                                            " autopair parens, etc.
Plug 'unblevable/quick-scope'                                     " highlight unique chars for 'f' and 't' motions
Plug 'wellle/targets.vim'                                         " enhanced text objects
Plug 'vifm/vifm.vim'                                              " vifm file manager
Plug 'tpope/vim-commentary'                                       " comment code
Plug 'romainl/vim-cool'                                           " auto highlight search, add search match count
Plug 'tpope/vim-dispatch'                                         " async make
Plug 'tpope/vim-fugitive'                                         " git integration
Plug 'yassinebridi/vim-purpura'                                   " theme, all purple because its fun
Plug 'vimjas/vim-python-pep8-indent'                              " python treesitter indent is a WIP, use this until it's ready
Plug 'tpope/vim-repeat'                                           " make mappings repeatable
Plug 'kshenoy/vim-signature'                                      " visual marks in gutter
Plug 'tpope/vim-surround'                                         " mappings for surrounding characters
Plug 'hrsh7th/vim-vsnip'                                          " lsp snippet support
call plug#end()

"}}}
" lua user plugins {{{
lua require('usr.commands')
lua require('usr.highlights')

lua require('usr.plugin.lsp')
lua require('usr.plugin.treesitter')
lua require('usr.plugin.completion')
lua require('usr.plugin.statusline')
lua require('usr.plugin.linenumbers')
lua require('usr.plugin.notes')
lua require('usr.plugin.autocmd')
lua require('vendor.plugin.indent-blankline')
"}}}
" plugin configurations {{{
"ale {{{
" lint on save, insert leave
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 1

let g:ale_linters_explicit = 1
let g:ale_set_loclist = 0
let g:ale_disable_lsp = 1
let g:ale_linters = {'javascript': ['eslint'], 'typescript': ['eslint']}

let g:ale_set_highlights = 0
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '!>'
let g:ale_sign_info = '<>'
let g:ale_sign_style_error = '>>'
let g:ale_sign_style_warning = '!>'

augroup AleHi
  autocmd!
  autocmd ColorScheme *
    \ | highlight link ALEErrorSign DiffDelete
    \ | highlight link ALEWarningSign DiffText
    \ | highlight link ALEInfoSign DiffChange
    \ | highlight link ALEStyleErrorSign DiffDelete
    \ | highlight link ALEStyleWarningSign DiffText
augroup END
"}}}
" fzf {{{
let g:fzf_layout = { 'window': { 'width': 1, 'height': 1, 'border': 'bottom' } }

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '
  \  . (len(<q-args>) > 0 ? <q-args> : '""'), 1,
  \    fzf#vim#with_preview(), <bang>0)

"}}}
" nvim-treesitter {{{
augroup TreesitterHi
  autocmd!
  autocmd ColorScheme *
    \   highlight link TSDefinition DiffAdd
    \ | highlight link TSDefinitionUsage Search
augroup END
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
" vim-signature {{{
let g:SignatureMarkTextHL = 'Identifier'
      let g:SignatureMap = {
        \ 'Leader'             :  "m",
        \ 'PlaceNextMark'      :  "",
        \ 'ToggleMarkAtLine'   :  "",
        \ 'PurgeMarksAtLine'   :  "",
        \ 'DeleteMark'         :  "",
        \ 'PurgeMarks'         :  "",
        \ 'PurgeMarkers'       :  "",
        \ 'GotoNextLineAlpha'  :  "",
        \ 'GotoPrevLineAlpha'  :  "",
        \ 'GotoNextSpotAlpha'  :  "",
        \ 'GotoPrevSpotAlpha'  :  "",
        \ 'GotoNextLineByPos'  :  "",
        \ 'GotoPrevLineByPos'  :  "",
        \ 'GotoNextSpotByPos'  :  "",
        \ 'GotoPrevSpotByPos'  :  "",
        \ 'GotoNextMarker'     :  "",
        \ 'GotoPrevMarker'     :  "",
        \ 'GotoNextMarkerAny'  :  "",
        \ 'GotoPrevMarkerAny'  :  "",
        \ 'ListBufferMarks'    :  "m/",
        \ 'ListBufferMarkers'  :  ""
        \ }
"}}}
"}}}
"}}}
" Settings {{{
syntax on
set path+=src/**
set path+=packages/*/src/**
set undofile
set dictionary+=/usr/share/dict/words
set hidden
set timeoutlen=1000 ttimeoutlen=5
set ignorecase
set smartcase
set hlsearch
set list
set listchars=tab:>\ ,trail:•,extends:>,precedes:<,nbsp:+
set completeopt=menu,menuone,noselect
set shortmess+=c
set incsearch
set ruler
set wildmenu
set wildignorecase
set splitbelow
set splitright
set laststatus=2
set cursorline
set diffopt=vertical,filler
set linebreak
set showbreak=>\ 
set breakindent
set breakindentopt=sbr
set noshowcmd
set updatetime=750
if has('nvim-0.5')
  set signcolumn=number
endif

set history=1000
set scrolloff=1
set sidescrolloff=15
set sidescroll=1
set complete-=i
set sessionoptions-=options
set viewoptions-=options
set iskeyword+=-
set pastetoggle=<F1>
set formatoptions-=cro
set belloff=all
set noshowmode
set foldlevelstart=99
set signcolumn=yes

set autoread

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


" cursor related settings {{{
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

augroup highlight_yank
  autocmd!
  " autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
  autocmd TextYankPost * lua require'vim.highlight'.on_yank({ timeout = 400 })
augroup END

" general overrides for all filetype plugins
augroup GeneralFiletype
  autocmd!
  autocmd BufNewFile,BufRead *.graphql setfiletype graphql
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  " this was causing some weird redraw/broken window issues when the lsp opened a qf
  " autocmd FileType qf wincmd J
augroup END

"}}}
"}}}
" Mappings {{{
let mapleader=" "

nnoremap <leader>t :suspend<CR>
nnoremap <leader>q @@<CR>
nnoremap <silent><leader>s :update<CR>
nnoremap <silent><leader>z :ZoomToggle<CR>
nnoremap <leader>w <C-w>
nmap <leader>bd <plug>Kwbd
nmap <leader>bf :let @* = expand('%:p')<CR>:echo 'Filepath copied to clipboard'<CR>

"close quickfix/location lists
nnoremap <silent><leader>c :ccl<CR>:lcl<CR>

nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

" ctrl-a is bound to tmux toggle all bindings, a different binding is used for suspend (ctrl-z) so this is fine
nnoremap <C-Z> <C-A>
vnoremap <C-Z> <C-A>

" quickly switch to alternate buffer
nnoremap <CR> <C-^>

" remove alternate buffer switch keymap for quick/loc list and command history bufs
augroup AltBufSwitch
  autocmd!
  autocmd Filetype qf nnoremap <buffer><CR> <CR>
  autocmd CmdwinEnter * nnoremap <buffer><CR> <CR>
augroup END

" some window commands have two keymaps for opening horiz. splits, so take one of them for vertical splits
nnoremap <C-W><C-F> <C-W>vgf

noremap Y y$
nnoremap <silent>- :Vifm<CR>

" make character-wise search repeat keys always jump in the same direction. Ex. repeating Fa and fa, ; always jumps cursor to next 'a' character to the right
" nnoremap <expr>; getcharsearch().forward ? ';' : ','
" nnoremap <expr>, getcharsearch().forward ? ',' : ';'

" bindings ripped from vim-unimpaired
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]Q :clast<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]L :llast<CR>
nnoremap <silent> [L :lfirst<CR>
nnoremap <silent> ]a :next<CR>
nnoremap <silent> [a :previous<CR>
nnoremap <silent> ]A :last<CR>
nnoremap <silent> [A :first<CR>


" https://github.com/whiteinge/dotfiles/blob/e728e33bd105b16aeef134eb12e1175e0c00ef0a/.vim/autoload/vimortmux.vim
" Natural movement around splits, if tmux, movement seamlessly extends to tmux panes
nnoremap <silent> <C-J> :call vimortmux#VimOrTmuxNav('j')<cr>
nnoremap <silent> <C-K> :call vimortmux#VimOrTmuxNav('k')<cr>
nnoremap <silent> <C-L> :call vimortmux#VimOrTmuxNav('l')<cr>
nnoremap <silent> <C-H> :call vimortmux#VimOrTmuxNav('h')<cr>

" resize splits
nnoremap <silent> <Right> :vertical resize +2<CR>
nnoremap <silent> <Left> :vertical resize -2<CR>
nnoremap <silent> <Up> :resize +2<CR>
nnoremap <silent> <Down> :resize -2<CR>

inoremap <expr> <S-tab> pumvisible() ? '<C-n>' : '<C-x><C-o>'

" relative filepath completion
" https://github.com/whiteinge/dotfiles/blob/e728e33bd105b16aeef134eb12e1175e0c00ef0a/.vimrc#L235
inoremap <C-f>
  \ <C-o>:let b:oldpwd = getcwd() <bar>
  \ lcd %:p:h<CR><C-x><C-f>

augroup RelativeFilepathComp
  autocmd!
  autocmd CompleteDone *
  \ if exists('b:oldpwd') |
  \   cd `=b:oldpwd` |
  \   unlet b:oldpwd |
  \ endif
augroup END

" vim-fugitive {{{
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gb :Git blame -C<CR>
nnoremap <leader>grb :Grebase 
nnoremap <leader>gri :Grebase -i HEAD~
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gl :Glog<CR>
nnoremap <leader>ge :Gedit<CR>
" git log of current buffer
nnoremap <leader>glb :0Glog<CR>

nnoremap <leader>gh :call gitlink#copygitlink()<CR>
vnoremap <leader>gh :call gitlink#copygitlink(1)<CR>
"}}}

" fzf {{{
nnoremap <leader>fd :call fzf#vim#tags(expand('<cword>'), {'options': '--exact --select-1 --exit-0'})<CR>
nnoremap <silent> <leader>fl :BLines<CR>
nnoremap <silent> <leader><space> :Buffers<CR>
nnoremap <leader>fs :Rg<space>
nnoremap <leader>ff :GFiles<CR>
nnoremap <leader>fa :Files<space>

" Use FZF for autocompletion
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" imap <c-x><c-l> <plug>(fzf-complete-line)
"}}}
"}}}
" Theme {{{
set background=light
set termguicolors

function! BatTheme(bg) abort
  " bat is the underlying syntax highlighter for FZF preview windows
  " tell bat to use a theme that works with the current background setting
  if !exists('g:bat_theme')
    let g:bat_theme=$BAT_THEME
  endif

  if a:bg ==# 'light'
    let $BAT_THEME='GitHub'
  else
    let $BAT_THEME=g:bat_theme
  endif
endfunction

call BatTheme(&background)

" gruvbox theme {{{
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'

" set background color to black
" gruvbox overrides fzf popup colors, set black background
" override cursorline color with something more subtle on black background
" override red color to be less orange
function! GruvCust() abort
  if exists('g:gruvbox_contrast_dark') && &background ==# 'dark'
    let g:fzf_colors.bg = ['bg', 'Normal']
    highlight Normal guibg=#000000 guifg=#fce8c3
    highlight SpecialKey guifg='#ff00ff' ctermfg=201 cterm=bold
    highlight CursorLine ctermbg=233 guibg=#121212
    highlight CursorLineNR cterm=bold ctermbg=233 guibg=#121212
    highlight GruvboxRed guifg=#ef2f27
    highlight GruvboxOrange guifg=#ff5f00
    highlight GruvboxBlue guifg=#0aaeb3
    highlight GruvboxPurple guifg=#ff5c8f
  else
    highlight MatchParen guibg=#736a57 guifg=#a89984
  endif
  highlight clear SignColumn
endfunction

function! UpdateNormalNC() abort
  let custBg = synIDattr(hlID('CursorLine'),'bg#')
  exec 'hi NormalNC guibg=' . custBg
  exec 'hi VertSplit guibg=' . custBg
endfunction

augroup ThemeCustom
  autocmd!
  autocmd ColorScheme gruvbox call GruvCust()
  autocmd OptionSet background call BatTheme(v:option_new)
  autocmd ColorScheme * call UpdateNormalNC()
augroup END

"}}}

silent! colorscheme gruvbox

"}}}

