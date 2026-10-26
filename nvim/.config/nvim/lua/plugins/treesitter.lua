return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    -- main = 'nvim-treesitter.configs',
    dependencies = {
      -- 'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'windwp/nvim-ts-autotag',
        enabled = false,
      },
      {
        'RRethy/nvim-treesitter-textsubjects',
        enabled = false,
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
    config = function()
      local parsers = {
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
      }
      require('nvim-treesitter').install(parsers)

      local filetypes = {}
      for _, lang in ipairs(parsers) do
        vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
      end

      local indent_disabled = { "python", "rust", "yaml" }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function(args)
          vim.treesitter.start(args.buf)
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          if not vim.tbl_contains(indent_disabled, vim.bo[args.buf].filetype) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
    opts = {
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
    },
  }
}
