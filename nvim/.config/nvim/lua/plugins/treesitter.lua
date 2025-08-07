return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'RRethy/nvim-treesitter-textsubjects',
        configs = function()
            require('nvim-treesitter-textsubjects').configure({
              textsubjects = {
                enable = true,
                keymaps = {
                  ['.'] = 'textsubjects-smart',
                  [';'] = 'textsubjects-container-outer',
                  ['i;'] = 'textsubjects-container-inner',
                },
              },
            })
        end,
      },
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "comment",
        "css",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "graphql",
        "hcl",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "scss",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "yaml",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "python", "rust", "yaml" },
      },
      refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = false },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition_lsp_fallback = "gd",
            list_definitions = "gD",
            goto_next_usage = "]r",
            goto_previous_usage = "[r",
          },
        },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = "grr",
          },
        },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      textobjects = {
        lsp_interop = {
          enable = true,
          peek_definition_code = {
            ["<leader>lp"] = "@function.outer",
            ["<leader>lP"] = "@class.outer",
          },
        },
        select = {
          enable = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    }
  }
}
