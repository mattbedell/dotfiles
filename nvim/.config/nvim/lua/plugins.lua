return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      vim.api.nvim_command('highlight link GitSignsAdd DiagnosticHint')
      vim.api.nvim_command('highlight link GitSignsChange DiagnosticInfo')
      vim.api.nvim_command('highlight link GitSignsDelete DiagnosticError')
    end,
  },
  {
    'rhysd/git-messenger.vim',
    init = function()
      vim.g.git_messenger_no_default_mappings = true
    end,
    keys = {
      {
        '<leader>gm',
        '<cmd>GitMessenger<cr>',
        silent = true,
      }
    }
  },                               -- fugitive Blame is slow, this is faster
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      mappings = nil,
    },
    keys = {
      {
        '<leader>gh',
        '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>',
        silent = true
      },
      {
        '<leader>gh',
        '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>',
        mode = 'v',
      }
    }
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup{
        italic = {
          strings = false,
        },
        contrast = 'hard',
      }

      vim.cmd.colorscheme('gruvbox')

      vim.cmd('highlight clear SignColumn')
      -- force StatusLine and StatusLineNC to be different so spaces aren't replaced with carats in the active statusline
      vim.cmd('highlight StatusLine ctermfg=223')
      vim.cmd('highlight clear NormalFloat')
    end
  },
    -- use {                                                       -- indent lines w/ treesitter context awareness
    --   'lukas-reineke/indent-blankline.nvim',
    --   config = function()
    --     require('vendor.plugin.indent-blankline')
    --   end,
    -- }
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      break_undo = false,
    }
  },
    -- {                                                       -- debugger
    --   'mfussenegger/nvim-dap',
    --   config = function()
    --     require('vendor.plugin.nvim-dap')
    --   end,
    -- }
  {
    'unblevable/quick-scope',
    event = 'VeryLazy',
    init = function()
      vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}
      vim.g.qs_lazy_highlight = 1
    end,
    config = function()
      local theme = vim.api.nvim_create_augroup('QuickScopeColors', { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = theme,
        pattern = "gruvbox",
        callback = function()
          vim.api.nvim_set_hl(0, 'QuickScopePrimary', { fg = '#ff00ff', bold = true, ctermfg = 201 })
          vim.api.nvim_set_hl(0, 'QuickScopeSecondary', { fg = '#ff0000', bold = true, ctermfg = 9, cterm = { bold = true } })
        end
      })
    end
  },
  {
    'wellle/targets.vim',
    event = 'BufReadPost',
  },
  { 'vifm/vifm.vim' },
  {
    'tpope/vim-commentary',
    event = 'BufReadPost',
    config = function()
      local group = vim.api.nvim_create_augroup("VimCommentary", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "terraform",
        command = "set commentstring=#%s",
        group = group,
      })
      return {}
    end
  },
  {
    'tpope/vim-dispatch',
    event = 'VeryLazy',
  },
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
  },
  { 'yassinebridi/vim-purpura', enabled = false },
  {
    'tpope/vim-repeat',
    event = 'BufReadPost',
  },
  {
    'kshenoy/vim-signature',
    event = 'VeryLazy',
  },
  {
    'tpope/vim-surround',
    event = 'BufReadPost',
  },
  {
    'towolf/vim-helm',
    ft = { 'yaml' },
  },
  {
    'shortcuts/no-neck-pain.nvim',
    keys = {
      {
        '<leader>bc',
        '<cmd>lua require("no-neck-pain").toggle()<cr>',
        silent = true,
      }
    },
    opts = function()
      local hi_normalnc = vim.api.nvim_get_hl_by_name('NormalNC', true)
      return {
        autocmds = { enableOnVimEnter = false },
        width = 120,
          buffers = {
            -- colors = {
            --   background = string.format('#%06x', hi_normalnc.background),
            -- },
            right = {
              enabled = true,
            },
        },
      }
    end
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = function()
      vim.cmd([[cab cc CodeCompanion]])
      return {
        strategies = {
          chat = {
            adapter = 'copilot'
          },
          inline = {
            adapter = 'copilot'
          },
          agent = {
            adapter = 'copilot'
          }
        }
      }
    end,
    keys = {
      {
        '<leader>aa',
        '<cmd>CodeCompanionActions<cr>',
        noremap = true,
        silent = true,
      },
      {
        '<leader>aa',
        '<cmd>CodeCompanionActions<cr>',
        noremap = true,
        silent = true,
        mode = 'v'
      },
      {
        '<leader>ac',
        '<cmd>CodeCompanionChat Toggle<cr>',
        noremap = true,
        silent = true,
      },
      {
        '<leader>ac',
        '<cmd>CodeCompanionChat Toggle<cr>',
        noremap = true,
        silent = true,
        mode = 'v'
      },
      {
        '<leader>ad',
        '<cmd>CodeCompanionChat Add<cr>',
        noremap = true,
        silent = true,
        mode = 'v'
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter' },
    ft = { 'markdown', 'codecompanion' },
    opts = {
      file_types = { 'markdown', 'codecompanion'},
      heading = {
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH2Bg',
        }
      }
    }
  },
  -- use "Copilot auth" to get a token, then this can be disabled
  -- use {
  --   "zbirenbaum/copilot.lua",
  --   config = function()
  --     require("copilot").setup()
  --   end
  -- }
}
