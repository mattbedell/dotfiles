local packer_augroup = vim.api.nvim_create_augroup('packer_user_config', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = packer_augroup,
  pattern = 'plugins.lua',
  desc = 'Packer compile on plugin config update',
  callback = function(args)
    vim.cmd('source ' .. args.file)
    vim.cmd('PackerCompile')
  end,
})

local packer_config = {
  plugin_package = 'packer-plugins',
}

return require('packer').startup({
  function(use)
    use {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('vendor.plugin.gitsigns')
      end,
      after = 'gruvbox.nvim',
    }
    use 'rhysd/git-messenger.vim'                               -- fugitive Blame is slow, this is faster
    use {
      'ruifm/gitlinker.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('vendor.plugin.gitlinker')
      end
    }
    use {
      'ellisonleao/gruvbox.nvim',
      config = function()
        require('vendor.plugin.gruvbox')
      end
    }
    use {                                                       -- indent lines w/ treesitter context awareness
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        require('vendor.plugin.indent-blankline')
      end,
    }
    use {
    'windwp/nvim-autopairs',                                    -- autopairs
      config = function()
        require('vendor.plugin.nvim-autopairs')
      end,
    }
    use {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-path',
        'hrsh7th/vim-vsnip',
        { 'hrsh7th/cmp-vsnip', after = { 'vim-vsnip' } },
      },
      config = function()
        require('vendor.plugin.nvim-cmp')
      end,
      after = {
        'cmp-buffer',
        'cmp-nvim-lsp',
        'cmp-nvim-lsp-signature-help',
        'cmp-path',
        'vim-vsnip',
        'cmp-vsnip',
      }
    }
    use {                                                       -- debugger
      'mfussenegger/nvim-dap',
      config = function()
        require('vendor.plugin.nvim-dap')
      end,
    }
    use {                                                       -- convenient configs for language servers
      'neovim/nvim-lspconfig',
      after = { 'cmp-nvim-lsp' },
      config = function()
        require('usr.plugin.lsp')
      end,
    }
    use {
      {
        'nvim-treesitter/nvim-treesitter',
        config = function()
          require('usr.plugin.treesitter')
        end,
      },
      {
        'windwp/nvim-ts-autotag',                               -- autoclose html tags
        after = 'nvim-treesitter',
      },
      {
        'nvim-treesitter/nvim-treesitter-refactor',
        after = 'nvim-treesitter',
      },
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
      },
      {
        'RRethy/nvim-treesitter-textsubjects',
        after = 'nvim-treesitter',
      },
      {
        'JoosepAlviste/nvim-ts-context-commentstring',          -- update commentstring using treesitter for injected languages
        after = 'nvim-treesitter',
      },
    }
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.0',
      requires = {
        {'nvim-lua/plenary.nvim'},
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        {'nvim-telescope/telescope-live-grep-args.nvim'}
      },
      config = function()
        require('vendor.plugin.telescope')
      end
    }
    use 'unblevable/quick-scope'                                -- highlight unique chars for 'f' and 't' motions
    use 'wellle/targets.vim'                                    -- enhanced text objects
    use 'vifm/vifm.vim'                                         -- vifm file manager
    use {                                                       -- comment code
      'tpope/vim-commentary',
      config = function()
        require('vendor.plugin.vim-commentary')
      end
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
    use 'towolf/vim-helm'
    use {                                                       -- center buffers
      "shortcuts/no-neck-pain.nvim",
      tag = "*",
      after = { 'gruvbox.nvim' },
      config = function()
        require('vendor.plugin.no-neck-pain')
      end
   }
  end,
  config = packer_config,
})
