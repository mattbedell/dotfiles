local hi_normalnc = vim.api.nvim_get_hl_by_name('NormalNC', true)
require("no-neck-pain").setup({
  enableOnVimEnter = false,
  width = 100,
  buffers = {
    backgroundColor = string.format('#%06x', hi_normalnc.background),
    right = {
      enabled = true,
    },
  },
})
