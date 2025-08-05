
" Plugins {{{
" vim {{{
packadd! cfilter " filter quickfix list, see :help CFilter
packadd! matchit " extend %

let g:netrw_altfile = 1

" }}}
let mapleader=" "

lua require("config.lazy")
"}}}
" lua user plugins {{{
lua require('usr.commands')
lua require('usr.highlights')

lua require('usr.plugin.autocmd')
lua require('usr.plugin.linenumbers')
lua require('usr.plugin.statusline')

" lua require('vendor.plugin.nvim-cmp')
"}}}
" plugin configurations {{{
" quick-scope {{{
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
set timeoutlen=1000 ttimeoutlen=5
set ignorecase
set smartcase
set hlsearch
set nowrapscan
set list
set listchars=tab:>\ ,trail:•,extends:>,precedes:<,nbsp:+
set fillchars+=vert:\ 
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
set formatoptions-=cro
set belloff=all
set noshowmode
set foldlevelstart=99
set signcolumn=yes
set mouse=

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

augroup highlight_yank
  autocmd!
  " autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
  autocmd TextYankPost * lua require'vim.hl'.on_yank({ timeout = 400 })
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

nnoremap <leader>t :suspend<CR>
nnoremap <leader>q @@<CR>
nnoremap <silent><leader>s :update<CR>
nnoremap <silent><leader>z :ZoomToggle<CR>
nnoremap <leader>w <C-w>
nmap <leader>bd <plug>Kwbd
nmap <leader>bf :let @* = expand('%:p')<CR>:echo 'Filepath copied to clipboard'<CR>
nmap <leader>br :let @* = expand('%')<CR>:echo 'Relative filepath copied to clipboard'<CR>
nmap <silent><leader>bc :lua require('no-neck-pain') require("no-neck-pain").toggle()<CR>
nnoremap <silent><leader>gp :lua require'usr.plugin.github'.open_pr()<CR>

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

"}}}

"}}}
" Theme {{{
set background=light
set termguicolors
"}}}


"}}}

