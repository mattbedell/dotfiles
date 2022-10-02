vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use {                                         -- fzf fuzzy finder wrapper
    'junegunn/fzf',
    requires = 'junegunn/fzf.vim',
    ensure_dependencies = true,
  }
  use 'rhysd/git-messenger.vim'                               -- fugitive Blame is slow, this is faster
  use 'iautom8things/gitlink-vim'                             -- generate a github link to current line
  use 'gruvbox-community/gruvbox'                             -- theme
  use 'lukas-reineke/indent-blankline.nvim'                   -- indent lines w/ treesitter context awareness
  use 'windwp/nvim-autopairs'                                 -- autopairs
  use {
    'hrsh7th/nvim-cmp',                                       -- completion + completion sources
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-vsnip',
    },
    ensure_dependencies = true,
  }
  use 'mfussenegger/nvim-dap'                                 -- debugger
  use 'neovim/nvim-lspconfig'                                 -- convenient configs for language servers
  use {                                                       -- abstraction layer for neovim's treesitter integration
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-textsubjects',
    },
    ensure_dependencies = true,
  }
  use 'windwp/nvim-ts-autotag'                                -- treesitter aware auto-close html tags
  use 'unblevable/quick-scope'                                -- highlight unique chars for 'f' and 't' motions
  use 'wellle/targets.vim'                                    -- enhanced text objects
  use 'vifm/vifm.vim'                                         -- vifm file manager
  use {                                                       -- comment code
    'tpope/vim-commentary',
    requires = 'JoosepAlviste/nvim-ts-context-commentstring', -- update commentstring using treesitter for injected languages
    ensure_dependencies = true,
  }
  use 'romainl/vim-cool'                                      -- auto highlight search, add search match count
  use 'tpope/vim-dispatch'                                    -- async make
  use 'tpope/vim-fugitive'                                    -- git integration
  use 'yassinebridi/vim-purpura'                              -- theme, all purple because its fun
  use 'vimjas/vim-python-pep8-indent'                         -- python treesitter indent is a WIP, use this until it's ready
  use 'tpope/vim-repeat'                                      -- make mappings repeatable
  use 'kshenoy/vim-signature'                                 -- visual marks in gutter TODO: replace this
  use 'tpope/vim-surround'                                    -- mappings for surround characters
  use 'fgsch/vim-varnish'                                     -- VCL syntax highlighting
  use 'hrsh7th/vim-vsnip'                                     -- lsp snippet support
end)
