local hi_normalnc = vim.api.nvim_get_hl_by_name('NormalNC', true)
require("no-neck-pain").setup({
  autocmds = { enableOnVimEnter = false },
  width = 120,
  buffers = {
    colors = {
      background = string.format('#%06x', hi_normalnc.background),
    },
    right = {
      enabled = true,
    },
  },
})
