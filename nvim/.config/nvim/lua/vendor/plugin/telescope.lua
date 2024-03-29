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

require('telescope').load_extension('fzf')
require('telescope').load_extension('live_grep_args')

function project_files()
  local opts = {}
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

function buffers()
  builtin.buffers({ sort_mru = true })
end

function live_grep_word()
  require('telescope').extensions.live_grep_args.live_grep_args({ default_text = vim.fn.expand('<cword>') })
end

vim.keymap.set('n', '<leader>ff', project_files, {})
vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
vim.keymap.set('n', '<leader>fs', require('telescope').extensions.live_grep_args.live_grep_args, {})
vim.keymap.set('n', '<leader>fw', live_grep_word, {})
vim.keymap.set('n', '<leader>fr', builtin.resume, {})
vim.keymap.set('n', '<leader><space>', buffers, {})

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
