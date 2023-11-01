local group = vim.api.nvim_create_augroup("VimCommentary", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "terraform",
  command = "set commentstring=#%s",
  group = group,
})
