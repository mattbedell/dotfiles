
" Plugins {{{
" vim {{{
packadd! cfilter " filter quickfix list, see :help CFilter
packadd! matchit " extend %
filetype plugin indent on

let g:netrw_altfile = 1

" }}}
" vim-plug {{{
call plug#begin('~/.config/nvim/plugged')
Plug 'prabirshrestha/async.vim'           " vim-lsp dependency, normalize async calls
Plug 'nvim-lua/completion-nvim'           " completion with LSP
Plug 'nvim-lua/diagnostic-nvim'           " diagnostic LSP configs
Plug 'junegunn/fzf'                       " fzf fuzzy finder wrapper
Plug 'junegunn/fzf.vim'                   " fzf fuzzy finder plugin
Plug 'rhysd/git-messenger.vim'            " fugitive Blame is slow, this is faster
Plug 'gruvbox-community/gruvbox'          " theme
Plug 'Yggdroot/indentLine'                " minimal indent guides
Plug 'neovim/nvim-lspconfig'              " convenient configs for language servers
Plug 'tmsvg/pear-tree'                    " autopair parens, etc.
Plug 'unblevable/quick-scope'             " highlight unique chars for 'f' and 't' motions
Plug 'wellle/targets.vim'                 " enhanced text objects
Plug 'vifm/vifm.vim'                      " vifm file manager
Plug 'tpope/vim-commentary'               " comment code
Plug 'romainl/vim-cool'                   " auto highlight search, add search match count
Plug 'tpope/vim-dispatch'                 " async make
Plug 'tpope/vim-fugitive'                 " git integration
Plug 'yassinebridi/vim-purpura'           " theme, all purple because its fun
Plug 'tpope/vim-repeat'                   " make mappings repeatable
Plug 'kshenoy/vim-signature'              " visual marks in gutter
Plug 'tpope/vim-surround'                 " mappings for surrounding characters
call plug#end()

"}}}
" plugin configurations {{{
" completion-nvim {{{
let g:completion_enable_auto_popup = 0
let g:completion_sorting="length"
inoremap <silent><expr> <c-n> pumvisible() ? '<C-n>' : completion#trigger_completion()
inoremap <expr> <S-tab> pumvisible() ? '<C-n>' : '<C-x><C-o>'
"}}}
" diagnostic-nvim {{{
let g:diagnostic_insert_delay = 1
" let g:diagnostic_enable_virtual_text = 1

augroup LspDiagnostics
  autocmd!
  autocmd ColorScheme * \
    highlight link LspDiagnosticsError DiffDelete
    \ | highlight link LspDiagnosticsWarning DiffText
    \ | highlight link LspDiagnosticsInformation DiffChange
    \ | highlight link LspDiagnosticsHint DiffAdd
augroup END

" highlight link LspDiagnosticsError stlWarn
" highlight link LspDiagnosticsWarning stlWarnNC
" highlight link LspDiagnosticsInformation stlGit
" highlight link LspDiagnosticsHint BufTabLineHidden

call sign_define("LspDiagnosticsErrorSign", {"text" : ">>", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "!>", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "^>", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "^^", "texthl" : "LspDiagnosticsHint"})
"}}}
" fzf {{{
let g:fzf_layout = { 'window': { 'width': 1, 'height': 1, 'yoffset': 1, 'border': 'top,bottom' } }

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git" '
  \  . (len(<q-args>) > 0 ? <q-args> : '""'), 1,
  \    fzf#vim#with_preview(), <bang>0)

"}}}
" indentline {{{
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_bufTypeExclude = ['help', 'terminal']

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
set undofile
set dictionary+=/usr/share/dict/words
set hidden
set timeoutlen=1000 ttimeoutlen=5
set ignorecase
set smartcase
set hlsearch
set list
set listchars=tab:>\ ,trail:•,extends:>,precedes:<,nbsp:+
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set incsearch
set ruler
set wildmenu
set wildignorecase
set splitbelow
set splitright
set laststatus=2
set cursorline
set cursorcolumn
set diffopt=vertical,filler
set nowrap
set linebreak
set showbreak=>\ 
set breakindent
set breakindentopt=sbr
set noshowcmd
if has('nvim-0.5')
  set signcolumn=number
endif

set history=1000
set scrolloff=1
set sidescrolloff=5
set sidescroll=1
set complete-=i
set sessionoptions-=options
set viewoptions-=options
set iskeyword+=-
set pastetoggle=<F1>
set formatoptions-=cro
set belloff=all
set noshowmode

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

" toggle hybrid line numbers based on mode
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd WinEnter,BufEnter,FocusGained,InsertLeave * if &l:buftype !=# 'help' | set relativenumber
  autocmd WinLeave,BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

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
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

"}}}
" LSP {{{
lua <<EOF
  local nvim_lsp = require'nvim_lsp'
  local on_attach_lsp = function(client)
     require'completion'.on_attach(client)
     require'diagnostic'.on_attach(client)
     vim.fn.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
     vim.fn.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
     vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
  end

  nvim_lsp.tsserver.setup{
    root_dir = nvim_lsp.util.root_pattern(".git", "package.json"),
    on_attach = on_attach_lsp
  }

  nvim_lsp.pyls_ms.setup{
      on_attach = on_attach_lsp
  }
  nvim_lsp.rust_analyzer.setup{
    on_attach = on_attach_lsp
  }
EOF
"}}}
"}}}
" Mappings {{{
let mapleader=" "

nnoremap <leader>t :suspend<CR>
nnoremap <leader>q @@<CR>
nnoremap <leader>s :w<CR>
nnoremap <silent><leader>z :ZoomToggle<CR>
nnoremap <leader>w <C-w>
nmap <leader>bd <plug>Kwbd

"close quickfix/location lists
nnoremap <silent><leader>c :ccl<CR>:lcl<CR>

" ctrl-a is bound to tmux toggle all bindings, a different binding is used for suspend (ctrl-z) so this is fine
nnoremap <C-Z> <C-A>
vnoremap <C-Z> <C-A>

" some window commands have two keymaps for opening horiz. splits, so take one of them for vertical splits
nnoremap <C-W><C-F> <C-W>vgf
nnoremap <C-W><C-]> <C-W>v<C-]>

noremap Y y$
nnoremap <silent>- :Vifm<CR>

" make character-wise search repeat keys always jump in the same direction. Ex. repeating Fa and fa, ; always jumps cursor to next 'a' character to the right
nnoremap <expr>; getcharsearch().forward ? ';' : ','
nnoremap <expr>, getcharsearch().forward ? ',' : ';'

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

nnoremap <silent> ]e :NextDiagnosticCycle<CR>
nnoremap <silent> [e :PrevDiagnosticCycle<CR>

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
au CompleteDone *
  \ if exists('b:oldpwd') |
  \   cd `=b:oldpwd` |
  \   unlet b:oldpwd |
  \ endif

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

" general overrides applied to all themes
augroup ThemeCust
  autocmd!
  autocmd OptionSet background call BatTheme(v:option_new)
  autocmd ColorScheme *
    \   highlight SpellBad       ctermbg=9 guibg=#770000

" gruvbox theme {{{
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'

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
  endif
endfunction
" set background color to black
" gruvbox overrides fzf popup colors, set black background
" override cursorline color with something more subtle on black background
" override red color to be less orange
augroup GruvboxCust
  autocmd!
  autocmd ColorScheme gruvbox call GruvCust()
augroup END

"}}}

silent! colorscheme gruvbox

"}}}
