return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false,
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        config = function(plugin)
          require('usr.util').lazy_on_load("telescope.nvim", function()
            local ok, err = pcall(require("telescope").load_extension, "fzf")
            if not ok then
              local lib = plugin.dir .. "/build/libfzf." .. (LazyVim.is_win() and "dll" or "so")
              if not vim.uv.fs_stat(lib) then
                vim.notify("`telescope-fzf-native.nvim` not built. Rebuilding...", vim.log.levels.WARN)
                require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                  vim.notify("Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.", vim.log.levels.INFO)
                end)
              else
                vim.notify("Failed to load `telescope-fzf-native.nvim`:\n" .. err, vim.log.levels.ERROR)
              end
            end
          end)
        end,
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim" ,
        version = "^1.0.0",
        config = function()
          require('usr.util').lazy_on_load('telescope.nvim', function()
            pcall(require('telescope').load_extension, 'live_grep_args')
          end)
        end
      },
    },
    keys = {
      {
        '<leader>ff',
        function()
          local opts = {}
          local ok = pcall(require"telescope.builtin".git_files, opts)
          if not ok then require"telescope.builtin".find_files(opts) end
        end
      },
      {
        '<leader>fa',
        function()
          require('telescope.builtin').find_files()
        end
      },
      {
        '<leader>fs',
        function()
          require('telescope').extensions.live_grep_args.live_grep_args()
        end
      },
      {
        '<leader>fw',
        function()
          require('telescope').extensions.live_grep_args.live_grep_args({ default_text = vim.fn.expand('<cword>') })
        end
      },
      {
        '<leader>fr',
        function()
          require('telescope.builtin').resume()
        end
      },
      {
        '<leader><space>',
        function()
          require('telescope.builtin').buffers({ sort_mru = true })
        end
      }
    },
    config = function()
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')
      require('telescope').setup{
        defaults = {
          layout_config = { height = 0.95, width = 0.95 },
          mappings = {
            i = {
              ['<esc>'] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { 'fd', '--type', 'f', '--no-ignore-vcs', '--hidden', '--follow', '--strip-cwd-prefix', '--exclude', '.git/*' },
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = false
          }
        }
      }

      vim.cmd('highlight link TelescopeNormal Normal')
      vim.cmd('highlight link TelescopePreviewLine CursorLine | highlight link TelescopeSelection CursorLine')

      local telescope_augroup = vim.api.nvim_create_augroup('telescope_user_config', { clear = true })

      vim.api.nvim_create_autocmd('ColorScheme', {
        group = telescope_user_config,
        pattern = '*',
        desc = 'Telescope to use Normal so NormalNC does not set background',
        command = 'highlight link TelescopeNormal Normal',
      })
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = telescope_user_config,
        pattern = '*',
        desc = 'Telescope highlight group links',
        command = 'highlight link TelescopePreviewLine CursorLine | highlight link TelescopeSelection CursorLine',
      })
    end
  }
}
